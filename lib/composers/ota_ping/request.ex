defmodule ExOpenTravel.Composers.OtaPing.Request do
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.Document

  @action "OTA_Ping"

  @type credentials :: %{user: String.t(), password: String.t(), endpoint: String.t()}
  @type options :: keyword() | any()

  @doc """
    Ping message

    This is a simple XML message that could be useful to test if the connection is working correctly. We suggest
  to implement this method first in order to be sure that the SOAP level communication is correct.

  ## Example

    ExOpenTravel.Composers.OtaPing.Request.execute()
  """
  @spec execute(credentials, Meta.t(), options) ::
          {:ok, struct(), Meta.t()} | {:error, any(), Meta.t()}
  def execute(credentials, meta, opts) do
    {{:"ns1:EchoData", nil, ["Echo text"]}, Map.put(meta, :method, @action)}
    |> Document.build(@action, credentials)
    |> Request.send(credentials, opts)
  end
end
