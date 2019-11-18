defmodule ExOpenTravel.Response.Converter do
  @callback get_mapping_for_payload() :: SweetXpath.t()
  @callback convert_body({atom, any, any}) :: {:ok, map, any} | {:error, any, any}

  import SweetXml
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Response.FaultProcessor

  @spec convert({atom, String.t(), Meta.t()}, map()) ::
          {:ok, map, Meta.t()} | {:error, atom, Meta.t()}
  def convert(
        {:ok, xml, meta},
        %{
          action: action,
          success_mapping: success_mapping,
          warning_mapping: warning_mapping,
          error_mapping: error_mapping,
          payload_mapping: payload_mapping
        } = mapping
      ) do
    try do
      payload =
        with result <- xmap(xml, success_mapping),
             %{Success: success} when not is_nil(success) <- Map.get(result, action) do
          get_payload(xml, mapping)
        else
          _ -> get_errors(xml, mapping)
        end

      {:ok, payload, meta}
    rescue
      e in ArgumentError -> FaultProcessor.create_response(e, meta)
      e in FunctionClauseError -> FaultProcessor.create_response(e, meta)
    catch
      :exit, e -> FaultProcessor.create_response({:exit, e}, meta)
      :fatal, e -> FaultProcessor.create_response({:fatal, e}, meta)
    end
  end

  def convert({:error, _, meta} = e, _), do: FaultProcessor.create_response(e, meta)

  defp get_payload(xml, %{action: action, payload_mapping: payload_mapping} = mapping) do
    result = xmap(xml, payload_mapping)

    updated_result =
      with payload when not is_nil(payload) <- Map.get(result, action) do
        Map.put(result, :Success, true)
      else
        _ -> result
      end

    enrich_warnings(updated_result, xml, mapping)
  end

  defp enrich_warnings(payload, xml, %{action: action, warning_mapping: warning_mapping}) do
    with result <- xmap(xml, warning_mapping),
         warnings when not is_nil(warnings) <- Map.get(result, action) do
      Map.put(payload, :Warnings, warnings)
    else
      _ -> payload
    end
  end

  defp enrich_warnings(payload, _xml, _mapping), do: payload

  defp get_errors({:error, xml}, %{}) do
    {:error, xml}
  end
end
