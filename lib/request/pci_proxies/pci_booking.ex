defmodule ExOpenTravel.Request.PCIProxies.PCIBooking do
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.Helpers
  @api_endpoint "https://service.pcibooking.net/api"
  @type options :: keyword() | any()
  @spec proxy_send({String.t(), map()}, map(), options) ::
          {:ok, map(), map()} | {:error, map(), map()}
  def proxy_send(payload, credentials, opts \\ [])

  def proxy_send(
        {document, %{success: true} = meta},
        %{
          endpoint: endpoint,
          pci_booking_fetch_header: fetch_header,
          pci_booking_profile_name: profile_name,
          pci_booking_api_key: api_key
        },
        opts
      ) do
    with {:ok, temp_session} <- start_temporary_session(api_key, opts),
         url <- get_tokenized_booking_url(endpoint, temp_session, profile_name),
         {:ok, response, meta} <- send_request(url, {document, meta}, api_key, opts) do
      pci =
        with {:ok, meta} <- parse_headers(meta, fetch_header),
             {:ok, pci} <- convert_token_headers(meta) do
          pci
        end

      {:ok, response, Map.put(meta, :pci, pci)}
    end
  end

  def proxy_send({document, meta}, credentials, opts) do
    updated_meta =
      meta
      |> Helpers.update_meta_if_unfounded(credentials, :endpoint)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_booking_fetch_header)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_booking_profile_name)
      |> Helpers.update_meta_if_unfounded(credentials, :pci_booking_api_key)
      |> Map.put(:success, false)

    Request.send({document, updated_meta}, credentials, opts)
  end

  defp start_temporary_session(api_key, opts) do
    with {:ok, body, _} <-
           send_request("/payments/paycard/tempsession", {"", %{success: true}}, api_key, opts) do
      {:ok, String.replace(body.body, "\"", "")}
    end
  end

  defp get_tokenized_booking_url(endpoint, temp_session, profile_name) do
    get_url("/payments/paycard/capture",
      sessionToken: temp_session,
      httpMethod: "POST",
      profileName: profile_name,
      targetURI: endpoint,
      saveCVV: true
    )
  end

  defp send_request(url, body, api_key, opts) do
    Request.send(body, %{endpoint: "#{@api_endpoint}#{url}"}, headers(api_key), opts)
  end

  def parse_headers(%{headers: headers}, fetch_header) do
    {
      :ok,
      # The direction of the headers sequence is critical!
      %{
        tokens: headers |> get_from(fetch_header) |> split(";"),
        errors: headers |> get_from("X-pciBooking-Tokenization-Errors") |> split(";;"),
        warnings: headers |> get_from("X-pciBooking-Tokenization-Warnings") |> split(";;")
      }
    }
  end

  def parse_headers(meta, _fetch_header) do
    errors = Map.get(meta, :errors) || []

    {:error,
     Map.merge(meta, %{success: false, errors: ["Meta not content any headers" | errors]})}
  end

  def convert_token_headers(%{tokens: [], errors: [], warnings: []}) do
    {:ok, []}
  end

  def convert_token_headers(%{tokens: tokens, errors: [], warnings: []}) do
    {:ok, Enum.map(tokens, &%{tokens: &1})}
  end

  def convert_token_headers(%{tokens: tokens, errors: [], warnings: warnings}) do
    tokens
    |> list_to_indexed_map(:tokens)
    |> inject_same_length_list(:warnings, warnings)
  end

  def convert_token_headers(%{tokens: tokens, errors: errors, warnings: warnings}) do
    with {map, [], _} <-
           Enum.reduce(errors, {%{}, tokens, 0}, fn error, {map, reduced_tokens, count} ->
             with "" <- error, [head | tail] <- reduced_tokens do
               {Map.put(map, count + 1, %{tokens: head}), tail, count + 1}
             else
               [] -> {map, reduced_tokens, count}
               error -> {Map.put(map, count + 1, %{errors: error}), reduced_tokens, count + 1}
             end
           end) do
      inject_same_length_list(map, :warnings, warnings)
    else
      {_, _, _} -> {:error, :non_consistent_errors_list}
    end
  end

  defp inject_same_length_list(map, _inject_key, []) do
    {:ok, Enum.map(map, fn {_key, value} -> value end)}
  end

  defp inject_same_length_list(map, inject_key, list) do
    with {map, []} <-
           Enum.reduce_while(map, {%{}, list}, fn {key, value}, acc ->
             with {acc, [head | tail]} <- acc do
               value = Map.put(value, inject_key, head)
               {:cont, {Map.put(acc, key, value), tail}}
             else
               _ -> {:halt, {:error, :"non_consistent_#{inject_key}_list"}}
             end
           end) do
      {:ok, Enum.map(map, fn {_key, value} -> value end)}
    end
  end

  defp split(nil, _delimiter), do: []
  defp split(header, delimiter), do: String.split(header, delimiter)

  defp list_to_indexed_map(list, key, init \\ {%{}, 0}) do
    {map, _} =
      Enum.reduce(list, init, fn el, {map, count} ->
        {Map.put(map, count + 1, %{key => el}), count + 1}
      end)

    map
  end

  defp get_url(url, arguments) do
    arguments =
      arguments
      |> Enum.reduce(
        [],
        fn {key, value}, acc ->
          acc ++ ["#{key}=#{value}"]
        end
      )
      |> Enum.join("&")

    "#{url}?#{arguments}"
  end

  defp headers(api_key) do
    [
      {"Authorization", "APIKEY #{api_key}"},
      {"Cache-Control", "no-cache"}
    ]
  end

  defp get_from(headers, key) do
    with [{_, item} | _] <- Enum.filter(headers, fn {a, _} -> a == key end) do
      item
    else
      _ -> nil
    end
  end
end
