defmodule ExOpenTravel.Composers.OtaRead.RequestTest do
  use ExUnit.Case
  doctest ExOpenTravel.Composers.OtaRead.Request
  @moduletag :ex_open_travel_ota_read_request

  alias ExOpenTravel.Composers.OtaRead.Request

  @hotel_code "00000"
  @meta %{
    request: nil,
    response: nil,
    method: nil,
    started_at: DateTime.utc_now(),
    finished_at: nil,
    success: true,
    errors: []
  }
  test "build_hotel_rate_amount_notif" do
    {element, _meta} = Request.build_read(%{hotel_code: @hotel_code}, @meta)

    assert XmlBuilder.generate(element)

    assert element ==
             {:"ns1:ReadRequests", nil,
              [
                {:"ns1:HotelReadRequest", %{HotelCode: "00000"}, nil}
              ]}
  end
end
