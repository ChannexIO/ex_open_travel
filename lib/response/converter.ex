defmodule ExOpenTravel.Response.Converter do
  @callback get_mapping_table() :: SweetXpath.t()
  @callback convert_body({atom, any, any}) :: {:ok, map, any} | {:error, any, any}

  import SweetXml
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Response.FaultProcessor

  @spec convert({atom, String.t(), Meta.t()}, SweetXpath.t()) ::
          {:ok, map, Meta.t()} | {:error, atom, Meta.t()}
  def convert({:ok, xml, meta}, sweet_xpath) do
    try do
      {:ok, xmap(xml, sweet_xpath), meta}
      |> FaultProcessor.create_response(meta)
    rescue
      e in ArgumentError -> FaultProcessor.create_response(e, meta)
      e in FunctionClauseError -> FaultProcessor.create_response(e, meta)
    catch
      :exit, e -> FaultProcessor.create_response({:exit, e}, meta)
      :fatal, e -> FaultProcessor.create_response({:fatal, e}, meta)
    end
  end
end
