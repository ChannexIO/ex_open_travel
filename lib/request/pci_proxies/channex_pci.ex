defmodule ExOpenTravel.Request.PCIProxies.ChannexPCI do
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.Helpers

  @pci_url "https://pci.channex.io/api/v1/capture"
  @type options :: keyword() | any()

  @spec proxy_send({String.t(), map()}, map(), options) ::
          {:ok, map(), map()} | {:error, map(), map()}
  def proxy_send(payload, credentials, opts \\ [])

  def proxy_send(
        {document, %{success: true} = meta},
        %{
          endpoint: endpoint,
          pci_proxy_fetch_header: fetch_header,
          pci_proxy_profile_name: profile_name,
          pci_proxy_api_key: api_key
        },
        opts
      ) do
    with url <- get_url(endpoint, profile_name, api_key),
         {:ok, response, meta} <- Request.send({document, meta}, %{endpoint: url}, opts) do
      enriched_meta =
        with {:ok, headers} <- parse_headers(meta, fetch_header),
             {:ok, pci} <- convert_token_headers(headers) do
          Map.put(meta, :pci, pci)
        else
          {:error, error} ->
            meta
            |> Map.put(:success, false)
            |> Map.update(:errors, error, &[error | &1])
        end

      {:ok, response, enriched_meta}
    end
  end

  def proxy_send({document, meta}, credentials, opts) do
    updated_meta =
      meta
      |> Helpers.update_meta_if_unfounded(credentials, :endpoint)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_proxy_fetch_header)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_proxy_profile_name)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_proxy_api_key)
      |> Map.put(:success, false)

    Request.send({document, updated_meta}, credentials, opts)
  end

  defp get_url(endpoint, profile_name, api_key) do
    "#{@pci_url}?apikey=#{api_key}&method=post&profile=#{profile_name}&url=#{endpoint}&savecvv=true"
  end

  def parse_headers(%{headers: headers}, fetch_header) do
    {
      :ok,
      # The direction of the headers sequence is critical!
      %{
        tokens: headers |> get_from(fetch_header) |> split(","),
        errors: headers |> get_from("X-PCI-CHANNEX-ERRORS") |> split(","),
        warnings: headers |> get_from("X-PCI-CHANNEX-WARNINGS") |> split(",")
      }
    }
  end

  def parse_headers(_meta, _header), do: {:error, "Meta not contains any headers"}

  def convert_token_headers(meta) do
    tokens = Map.get(meta, :tokens) || []

    errors = Map.get(meta, :errors) || List.duplicate("", length(tokens))

    warnings = Map.get(meta, :warnings) || List.duplicate("", length(tokens))

    combine_headers([], tokens, errors, warnings)
  end

  defp combine_headers(result, [], [], []), do: {:ok, result}

  defp combine_headers(result, [token | tokens], [error | errors], [warning | warnings]) do
    result
    |> result_headers_update(token, error, warning)
    |> combine_headers(tokens, errors, warnings)
  end

  defp combine_headers(_result, _tokens, _errors, []) do
    {:error, "Headers contains non consistent warnings list"}
  end

  defp combine_headers(_result, [], [], _warnings) do
    {:error, "Headers contains non consistent warnings list"}
  end

  defp combine_headers(_result, [], _errors, _warnings) do
    {:error, "Headers contains non consistent errors list"}
  end

  defp combine_headers(_result, _tokens, [], _warnings) do
    {:error, "Headers contains non consistent errors list"}
  end

  defp result_headers_update(result, token, error, warning) do
    insertion =
      %{}
      |> insert_header(:token, token)
      |> insert_header(:error, error)
      |> insert_header(:warning, warning)
      |> List.wrap()

    result ++ insertion
  end

  defp insert_header(map, _, ""), do: map

  defp insert_header(map, name, header), do: Map.put(map, name, header)

  defp split(nil, _delimiter), do: nil

  defp split(header, delimiter), do: header |> String.split(delimiter) |> Enum.map(&String.trim/1)

  defp get_from(headers, key) do
    with [[_, item] | _] <- Enum.filter(headers, fn [a, _] -> a == key end) do
      item
    else
      _ -> nil
    end
  end
end
