defmodule ExOpenTravel.Request do
  @moduledoc "Get HTTP request after validation payload"
  alias ExOpenTravel.Response.Parser
  @type options :: keyword() | any()
  @spec send({String.t(), map()}, map(), Keyword.t(), options) ::
          {:ok, map(), map()} | {:error, map(), map()}
  def send(params, credentials, headers \\ [], opts \\ [])

  def send({document, %{success: true} = meta}, %{endpoint: endpoint}, headers, opts) do
    headers = Keyword.merge([{"Content-Type", "text/xml;charset=UTF-8"}], headers)
    timeout = Keyword.get(opts, :timeout, 60_000)
    recv_timeout = Keyword.get(opts, :recv_timeout, 120_000)

    {_, payload} =
      response =
      HTTPoison.post(endpoint, document, headers, timeout: timeout, recv_timeout: recv_timeout)

    with {:ok, parsed_response} <- Parser.handle_response(response) do
      {:ok, parsed_response,
       Map.merge(meta, %{
         status_code: payload.status_code,
         response: payload.body,
         headers: payload.headers,
         finished_at: DateTime.utc_now(),
         request: document,
         request_url: endpoint
       })}
    else
      {:error, reason} ->
        {:error, response,
         Map.merge(meta, %{
           success: false,
           errors: [reason],
           finished_at: DateTime.utc_now(),
           request: document,
           request_url: endpoint
         })}
    end
  end

  def send({document, %{success: false} = meta}, _, _headers, _opts) do
    {:error, document, Map.merge(meta, %{success: false, errors: meta.errors})}
  end

  def send({:error, document, meta}, _, _headers, _opts) do
    {:error, document, Map.merge(meta, %{success: false, errors: meta.errors})}
  end

  def send({document, meta}, _, _headers, _opts) do
    {:error, document, Map.merge(meta, %{success: false, errors: [:invalid_endpoint]})}
  end
end
