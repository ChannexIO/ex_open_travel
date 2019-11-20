defmodule ExOpenTravel.Composers.OtaHotelAvailQuery.Mapping do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @room_types [
    ~x"./*[local-name() = 'RoomTypes']/*[local-name() = 'RoomType']"ol,
    RoomTypeCode: ~x"./@RoomTypeCode"os,
    RoomDescription: [
      ~x"./*[local-name() = 'RoomDescription']"o,
      Name: ~x"./@Name"os,
      Text: ~x"./*[local-name() = 'Text']/text()"os
    ]
  ]

  @rate_plans [
    ~x"./*[local-name() = 'RatePlans']/*[local-name() = 'RatePlan']"ol,
    RatePlanCode: ~x"./@RatePlanCode"os,
    RatePlanDescription: [
      ~x"./*[local-name() = 'RateDescription']"o,
      Name: ~x"./@Name"os,
      Text: ~x"./*[local-name() = 'Text']/text()"os
    ]
  ]

  @room_stays [
    ~x"./*[local-name() = 'RoomStays']/*[local-name() = 'RoomStay']"ol,
    RoomTypes: @room_types,
    RatePlans: @rate_plans
  ]

  @sweet_xpath [
    OTA_HotelAvailRS: [
      ~x"//*[local-name() = 'OTA_HotelAvailRS']",
      Version: ~x"./@Version"os,
      EchoToken: ~x"./@EchoToken"os,
      TimeStamp: ~x"./@TimeStamp"os,
      RoomStays: @room_stays
    ]
  ]

  @success [
    OTA_HotelAvailRS: [
      ~x"//*[local-name() = 'OTA_HotelAvailRS']",
      Success: ~x"./*[local-name() = 'Success']"
    ]
  ]

  @errors [
    OTA_HotelAvailRS: [
      ~x"//*[local-name() = 'OTA_HotelAvailRS']",
      Errors: [
        ~x"./*[local-name() = 'Errors']/*[local-name() = 'Error']"l,
        Error: ~x"./text()"os,
        Type: ~x"./*[local-name() = 'Error']/@Type"os,
        Code: ~x"./*[local-name() = 'Error']/@Code"os
      ]
    ]
  ]

  @warnings [
    OTA_HotelAvailRS: [
      ~x"//*[local-name() = 'OTA_HotelAvailRS']",
      Warnings: [
        ~x"./*[local-name() = 'Warnings']/*[local-name() = 'Warning']"l,
        Warning: ~x"./text()"s,
        Type: ~x"./@Type"os,
        Code: ~x"./@Code"os,
        RecordID: ~x"./@RecordID"os
      ]
    ]
  ]

  @action :OTA_HotelAvailRS

  def get_action_name, do: @action
  def get_mapping_for_success, do: @success
  def get_mapping_for_errors, do: @errors
  def get_mapping_for_warnings, do: @warnings
  def get_mapping_for_payload, do: @sweet_xpath
  def convert_body(struct), do: Converter.convert(struct, @sweet_xpath)
end
