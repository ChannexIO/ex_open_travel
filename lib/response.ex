defmodule ExOpenTravel.Response do
  @moduledoc """
  Struct for response given by soap call.
  """

  defstruct body: nil, headers: [], request_url: nil, status_code: nil

  @type t :: %__MODULE__{
          body: any(),
          headers: list(tuple()),
          request_url: String.t(),
          status_code: pos_integer()
        }
  alias ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.FaultProcessor
  alias ExOpenTravel.Response.Parser

  @doc """
  Executing with xml response body as string.

  Function `parse/1` returns a full parsed response structure as map.
  """
  @spec parse_response(tuple(), any()) :: {:ok, map(), map()} | {:error, atom, map()}
  def parse_response({:ok, %{body: body, status_code: 200}, meta}, mapping_struct) do
    Converter.convert({:ok, body, meta}, mapping_struct)
  end

  def parse_response({:ok, %{status_code: status_code}, meta}, _)
      when status_code >= 500 do
    FaultProcessor.create_response(%{http_error: Integer.to_string(status_code)}, meta)
  end

  def parse_response({:ok, %{body: body, status_code: status_code}, meta}, _)
      when status_code >= 400 do
    Parser.parse(body, meta)
  end

  def parse_response({:error, _, meta} = e, _), do: FaultProcessor.create_response(e, meta)
end
