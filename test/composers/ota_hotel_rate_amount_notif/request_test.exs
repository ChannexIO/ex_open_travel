defmodule ExOpenTravel.Composers.OtaHotelRateAmountNotif.RequestTest do
  use ExUnit.Case
  doctest ExOpenTravel.Composers.OtaHotelRateAmountNotif.Request
  @moduletag :ex_open_travel_ota_hotel_rate_amount_request

  alias ExOpenTravel.Composers.OtaHotelRateAmountNotif.Request

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
    {element, _meta} =
      Request.build_hotel_rate_amount_notif(
        %{
          hotel_code: @hotel_code,
          rate_amount_messages: [
            %{
              status_application_control: %{
                start: "2010-11-25",
                end: "2010-11-25",
                rate_plan_code: "BB_BAR_ROOM",
                inv_type_code: "MTRD"
              },
              rates: [
                %{
                  base_by_guest_amts: [
                    %{
                      amount_after_tax: 123.00,
                      currency_code: "EUR",
                      number_of_guests: "1",
                      age_qualifying_code: "10"
                    }
                  ]
                }
              ]
            }
          ]
        },
        @meta
      )

    assert XmlBuilder.generate(element)

    assert element ==
             {:"ns1:RateAmountMessages", %{HotelCode: "00000"},
              [
                {:"ns1:RateAmountMessage", nil,
                 [
                   {:"ns1:StatusApplicationControl",
                    %{
                      End: "2010-11-25",
                      InvTypeCode: "MTRD",
                      RatePlanCode: "BB_BAR_ROOM",
                      Start: "2010-11-25"
                    }, nil},
                   {:"ns1:Rates", nil,
                    [
                      {:"ns1:Rate", nil,
                       [
                         {:"ns1:BaseByGuestAmts", nil,
                          [
                            {:"ns1:BaseByGuestAmt",
                             %{
                               AmountAfterTax: 123.0,
                               CurrencyCode: "EUR",
                               NumberOfGuests: "1",
                               AgeQualifyingCode: "10"
                             }, nil}
                          ]}
                       ]}
                    ]}
                 ]}
              ]}
  end

  test "build_hotel_rate_amount_notif_fail" do
    assert {:error, _, %{success: false, errors: [:empty_payload]}} =
             Request.build_hotel_rate_amount_notif(
               %{
                 hotel_code: @hotel_code,
                 rate_amount_messages: []
               },
               @meta
             )
  end
end
