defmodule ExOpenTravel.Response.FaultProcessor do
  alias ExOpenTravel.Error

  def create_response(e, meta) do
    error = convert(e)
    message = Error.message(error)

    {:error, error,
     meta |> Map.put(:success, false) |> Map.update(:errors, [message], &[message | &1])}
  end

  def convert(%{faultcode: code, faultstring: string}),
    do: Error.exception({:ota_error, {code, string}})

  def convert(%{"faultcode" => code, "faultstring" => string}),
    do: Error.exception({:ota_error, {code, string}})

  def convert(%{http_error: code}),
    do: Error.exception({:http_error, {code, nil}})

  def convert({:fatal, reason}), do: Error.exception({:fatal, reason})
  def convert({:exit, reason}), do: Error.exception({:exit, reason})
  def convert({:badrpc, {_, reason}}), do: Error.exception(reason)
  def convert({:error, _, %{errors: [reason]}}), do: Error.exception(reason)
  def convert(%ArgumentError{} = reason), do: Error.exception({:argument_error, reason})
  def convert(%FunctionClauseError{} = reason), do: Error.exception({:function_clause, reason})
  def convert(reason), do: Error.exception(reason)
end
