defmodule ExOpenTravel.Composers.OtaHotelAvailQuery.RequestTest do
  use ExUnit.Case
  doctest ExOpenTravel.Composers.OtaHotelAvailQuery.Request
  @moduletag :ex_open_travel_ota_hotel_avail_query_request

  alias ExOpenTravel.Composers.OtaHotelAvailQuery.Request

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
  test "build_hotel_avail_query" do
    {element, _meta} = Request.build_hotel_avail_query(%{hotel_code: @hotel_code}, @meta)

    assert XmlBuilder.generate(element)

    assert {:AvailRequestSegments, nil,
            [
              {:AvailRequestSegment, %{AvailReqType: "Room"},
               [
                 {:HotelSearchCriteria, nil,
                  [
                    {:Criterion, nil,
                     [
                       {:HotelRef, %{HotelCode: "00000"}, nil}
                     ]}
                  ]}
               ]}
            ]} ==
             element
  end
end
