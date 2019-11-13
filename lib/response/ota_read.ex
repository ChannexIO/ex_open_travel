defmodule ExOpenTravel.Response.OtaRead do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @list_nodes [
    "OTA_ResRetrieveRS/ReservationsList",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays/RoomStay/RoomTypes",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays/RoomStay/RoomRates",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays/RoomStay/RatePlans",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays/RoomStay/GuestCounts",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/RoomStays/RoomStay/RoomRates/RoomRate/Rates",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGlobalInfo/Comments",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGlobalInfo/Guarantee/GuaranteesAccepted",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGlobalInfo/HotelReservationIDs",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGlobalInfo/Profiles",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGuests",
    "OTA_ResRetrieveRS/ReservationsList/HotelReservation/ResGuests/ResGuest/Profiles"
  ]

  def list_nodes, do: @list_nodes
  def convert(struct), do: Converter.convert(struct, @list_nodes)

  def parse_query(%{body: body} = args) when is_map(args) do
    parse_query(body)
  end

  def parse_query(body) when is_binary(body) do
    try do
      {
        :ok,
        xpath(
          body,
          ~x"//*[local-name() = 'ReservationsList']",
          hotel_reservations: [
            ~x"./*[local-name() = 'HotelReservation']"ol,
            create_date_time: ~x"./@CreateDateTime"os,
            res_status: ~x"./@ResStatus"os,
            pos: [
              ~x"./*[local-name() = 'POS']"o,
              source: [
                ~x"./*[local-name() = 'Source']"o,
                booking_channel: [
                  ~x"./*[local-name() = 'BookingChannel']"o,
                  primary: ~x"./@Primary"os,
                  type: ~x"./@Type"os,
                  company_name: ~x"./*[local-name() = 'CompanyName']/text()"os
                ]
              ]
            ],
            unique_id: [
              ~x"./*[local-name() = 'UniqueID']"ol,
              id: ~x"./@ID"os,
              id_context: ~x"./@ID_Context"os,
              type: ~x"./@Type"os
            ],
            res_global_info: [
              ~x"./*[local-name() = 'ResGlobalInfo']"o,
              basic_property_info: [
                ~x"./*[local-name() = 'BasicPropertyInfo']"o,
                hotel_code: ~x"./@HotelCode"os
              ],
              # broken (no)
              comments: [
                ~x"./*[local-name() = 'Comments']"ol,
                comment: [
                  ~x"./*[local-name() = 'Comment']"ol,
                  text: ~x"./*[local-name() = 'Text']/text()"os
                ]
              ],
              # broken
              fees: [
                ~x"./*[local-name() = 'Fees']"ol,
                fee: [
                  ~x"./*[local-name() = 'Fee']"ol,
                  amount: ~x"./@Amount"os,
                  code: ~x"./@Code"os,
                  tax_inclusive: ~x"./@TaxInclusive"os,
                  type: ~x"./@Type"os,
                  description: [
                    ~x"./*[local-name() = 'Description']"o,
                    name: ~x"./@Name"os,
                    text: ~x"./*[local-name() = 'Text']/text()"os
                  ]
                ]
              ],
              total: [
                ~x"./*[local-name() = 'Total']"o,
                amount_after_tax: ~x"./@AmountAfterTax"os,
                currency_code: ~x"./@CurrencyCode"os
              ],
              guarantee: [
                ~x"./*[local-name() = 'Guarantee']"o,
                guarantees_accepted: [
                  ~x"./*[local-name() = 'GuaranteesAccepted']"ol,
                  guarantee_accepted: [
                    ~x"./*[local-name() = 'GuaranteeAccepted']"o,
                    payment_card: [
                      ~x"./*[local-name() = 'PaymentCard']"o,
                      card_code: ~x"./@CardCode"os,
                      card_number: ~x"./@CardNumber"os,
                      card_type: ~x"./@CardType"os,
                      expire_date: ~x"./@ExpireDate"os,
                      card_holder_name: ~x"./*[local-name() = 'CardHolderName']/text()"os
                    ]
                  ]
                ]
              ],
              # broken
              hotel_reservation_ids: [
                ~x"./*[local-name() = 'HotelReservationIDs']"ol,
                hotel_reservation_id: [
                  ~x"./*[local-name() = 'HotelReservationID']"o,
                  res_id_type: ~x"./@ResID_Type"os,
                  res_id_value: ~x"./@ResID_Value"os
                ]
              ],
              profiles: [
                ~x"./*[local-name() = 'Profiles']"ol,
                profile_info: [
                  ~x"./*[local-name() = 'ProfileInfo']"o,
                  profile_type: ~x"./@ProfileType"os,
                  customer: [
                    ~x"./*[local-name() = 'Customer']"o,
                    address: [
                      ~x"./*[local-name() = 'Address']"o,
                      country_name: ~x"./*[local-name() = 'CountryName']/text()"os
                    ],
                    email: ~x"./*[local-name() = 'Email']/text()"os,
                    person_name: [
                      ~x"./*[local-name() = 'PersonName']"o,
                      given_name: ~x"./*[local-name() = 'GivenName']/text()"os,
                      surname: ~x"./*[local-name() = 'Surname']/text()"os
                    ],
                    telephone: [
                      ~x"./*[local-name() = 'Telephone']"o,
                      phone_number: ~x"./*@PhoneNumber"os
                    ]
                  ]
                ]
              ]
            ],
            res_guests: [
              ~x"./*[local-name() = 'ResGuests']"ol,
              res_guest: [
                ~x"./*[local-name() = 'ResGuest']"o,
                primary_indicator: ~x"./@PrimaryIndicator"os,
                primary_indicator: ~x"./@ResGuestRPH"os
              ]
            ]
          ]
        )
      }
    catch
      :exit, _ -> {:error, :xml_parse_error}
    end
  end
end

%{
  ResGuests: [
    %{
      ResGuest: %{
        "@PrimaryIndicator": 'true',
        "@ResGuestRPH": '1',
        Profiles: [
          %{
            ProfileInfo: %{
              Profile: %{
                "@ProfileType": '1',
                Customer: %{
                  Address: %{CountryName: "TH"},
                  Email: "jcabre.525334@guest.booking.com",
                  PersonName: %{GivenName: "Judith", Surname: "Rivero Cabrera"},
                  Telephone: %{"@PhoneNumber": '+66 80 906 7049'}
                }
              }
            }
          }
        ]
      }
    }
  ],
  RoomStays: [
    %{
      RoomStay: %{
        BasicPropertyInfo: %{"@HotelCode": 'TBF25184AU'},
        Comments: %{Comment: %{Text: "smoking preference: Non-Smoking"}},
        GuestCounts: [
          %{GuestCount: %{"@AgeQualifyingCode": '10', "@Count": '2'}}
        ],
        RatePlans: [
          %{
            RatePlan: %{
              "@EffectiveDate": '2018-05-10',
              "@ExpireDate": '2018-05-13',
              "@RatePlanCode": 'Studio Room Only',
              AdditionalDetails: %{
                AdditionalDetail: %{
                  "@Type": '43',
                  DetailDescription: %{
                    Text: "Breakfast is included in the room rate."
                  }
                }
              }
            }
          }
        ],
        ResGuestRPHs: %{ResGuestRPH: %{"@RPH": '1'}},
        RoomRates: [
          %{
            RoomRate: %{
              "@NumberOfUnits": '1',
              "@RatePlanCode": 'Studio Room Only',
              "@RoomTypeCode": 'Studio',
              Rates: [
                %{
                  Rate: %{
                    "@EffectiveDate": '2018-05-10',
                    "@ExpireDate": '2018-05-11',
                    "@RateTimeUnit": 'Day',
                    "@UnitMultiplier": '1',
                    Total: %{
                      "@AmountAfterTax": '1350.00',
                      "@CurrencyCode": 'THB'
                    }
                  }
                }
              ]
            }
          }
        ],
        RoomTypes: [
          %{
            RoomType: %{
              "@RoomType": 'Studio - General - Breakfast included - -55% Min 3',
              "@RoomTypeCode": 'Studio',
              RoomDescription: %{
                Text: "This studio has a balcony, flat-screen TV and air conditioning."
              }
            }
          }
        ],
        TimeSpan: %{"@End": '2018-05-13', "@Start": '2018-05-10'},
        Total: %{"@AmountAfterTax": '5310.00', "@CurrencyCode": 'THB'}
      }
    }
  ]
}
