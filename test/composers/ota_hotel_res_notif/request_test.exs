defmodule ExOpenTravel.Composers.OtaHotelResNotif.RequestTest do
  use ExUnit.Case
  doctest ExOpenTravel
  @moduletag :ex_open_travel_request_ota_hotel_res_notif

  alias ExOpenTravel.Composers.OtaHotelResNotif.Request

  @meta %{
    request: nil,
    response: nil,
    method: nil,
    started_at: DateTime.utc_now(),
    finished_at: nil,
    success: true,
    errors: []
  }
  test "build_hotel_res_notif" do
    {element, _meta} =
      Request.build_hotel_res_notif(
        %{
          hotel_reservations: [
            %{
              unique_id: %{
                type: "14",
                id_context: "CrsConfirmNumber",
                id: "287329696/87030894|8953"
              },
              res_global_info: %{
                hotel_reservation_ids: [
                  %{
                    res_id_type: "10",
                    res_id_value: "123456ABCD",
                    res_id_source: "PMS",
                    res_id_source_context: "PmsConfirmNumber"
                  }
                ]
              }
            }
          ]
        },
        @meta
      )

    element |> XmlBuilder.generate()

    assert element ==
             {:"ns1:HotelReservations", nil,
              [
                {:"ns1:HotelReservation", nil,
                 [
                   {:"ns1:UniqueID",
                    %{ID: "287329696/87030894|8953", ID_Context: "CrsConfirmNumber", Type: "14"},
                    nil},
                   {:"ns1:ResGlobalInfo", nil,
                    [
                      {:"ns1:HotelReservationIDs", nil,
                       [
                         {:"ns1:HotelReservationID",
                          %{
                            ResID_Source: "PMS",
                            ResID_SourceContext: "PmsConfirmNumber",
                            ResID_Type: "10",
                            ResID_Value: "123456ABCD"
                          }, nil}
                       ]}
                    ]}
                 ]}
              ]}
  end

  test "build_hotel_res_notif_fail" do
    assert {:error, _, %{success: false, errors: [:empty_payload]}} =
             Request.build_hotel_res_notif(%{hotel_reservations: []}, @meta)
  end
end
