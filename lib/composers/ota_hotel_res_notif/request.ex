defmodule ExOpenTravel.Composers.OtaHotelResNotif.Request do
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.Document

  @action "OTA_HotelResNotif"

  @type options :: keyword() | any()
  @type credentials :: %{user: String.t(), password: String.t(), endpoint: String.t()}
  @type t ::
          %{
            hotel_reservations: [
              %{
                unique_id: %{
                  type: String.t(),
                  id_context: String.t(),
                  id: String.t()
                },
                res_global_info: %{
                  hotel_reservation_ids: [
                    %{
                      res_id_type: String.t(),
                      res_id_value: String.t(),
                      res_id_source: String.t(),
                      res_id_source_context: String.t()
                    }
                  ]
                }
              }
            ]
          }

  @doc """
  This method is used to update availability.
  """
  @spec execute(t, credentials, Meta.t(), options) ::
          {:ok, struct(), Meta.t()} | {:error, any(), Meta.t()}
  def execute(%{hotel_reservations: _} = params, credentials, meta, opts) do
    params
    |> build_hotel_res_notif(meta)
    |> Document.build(@action, credentials)
    |> Request.send(credentials, opts)
  end

  @spec build_hotel_res_notif(t, Meta.t()) :: {{atom(), map | nil, list | nil}, Meta.t()}
  def build_hotel_res_notif(%{hotel_reservations: []} = payload, meta) do
    {:error, payload, meta |> Map.put(:success, false) |> Map.put(:errors, [:empty_payload])}
  end

  def build_hotel_res_notif(%{hotel_reservations: hotel_reservations}, meta) do
    hotel_reservations_elements = Enum.map(hotel_reservations, &build_hotel_reservation/1)

    {{:"ns1:HotelReservations", nil, hotel_reservations_elements}, meta}
  end

  defp build_hotel_reservation(%{unique_id: unique_id, res_global_info: res_global_info}) do
    {:"ns1:HotelReservation", nil,
     [build_unique_id(unique_id), build_res_global_info(res_global_info)]}
  end

  defp build_unique_id(%{type: type, id_context: id_context, id: id}) do
    {:"ns1:UniqueID", %{Type: type, ID_Context: id_context, ID: id}, nil}
  end

  defp build_res_global_info(%{hotel_reservation_ids: hotel_reservation_ids}) do
    {:"ns1:ResGlobalInfo", nil,
     [{:"ns1:HotelReservationIDs", nil, Enum.map(hotel_reservation_ids, &hotel_reservation_id/1)}]}
  end

  defp hotel_reservation_id(%{
         res_id_type: res_id_type,
         res_id_value: res_id_value,
         res_id_source: res_id_source,
         res_id_source_context: res_id_source_context
       }) do
    {:"ns1:HotelReservationID",
     %{
       ResID_Type: res_id_type,
       ResID_Value: res_id_value,
       ResID_Source: res_id_source,
       ResID_SourceContext: res_id_source_context
     }, nil}
  end
end
