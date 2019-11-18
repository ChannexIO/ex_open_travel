defmodule ExOpenTravel.Composers.OtaHotelRateAmountNotif.Mapping do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @sweet_xpath [
    OTA_HotelRateAmountNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelRateAmountNotifRS']",
      Version: ~x"./@Version"os,
      EchoToken: ~x"./@EchoToken"os,
      TimeStamp: ~x"./@TimeStamp"os
    ]
  ]

  @success [
    OTA_HotelRateAmountNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelRateAmountNotifRS']",
      Success: ~x"./*[local-name() = 'Success']"
    ]
  ]

  @errors [
    OTA_HotelRateAmountNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelRateAmountNotifRS']",
      Errors: [
        ~x"./*[local-name() = 'Errors']/*[local-name() = 'Error']"l,
        Error: ~x"./text()"os,
        Type: ~x"./*[local-name() = 'Error']/@Type"os,
        Code: ~x"./*[local-name() = 'Error']/@Code"os
      ]
    ]
  ]

  @warnings [
    OTA_HotelRateAmountNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelRateAmountNotifRS']",
      Warnings: [
        ~x"./*[local-name() = 'Warnings']/*[local-name() = 'Warning']"l,
        Warning: ~x"./text()"s,
        Type: ~x"./@Type"os,
        Code: ~x"./@Code"os,
        RecordID: ~x"./@RecordID"os
      ]
    ]
  ]

  @action :OTA_HotelRateAmountNotifRS

  def get_action_name, do: @action
  def get_mapping_for_success, do: @success
  def get_mapping_for_errors, do: @errors
  def get_mapping_for_warnings, do: @warnings
  def get_mapping_for_payload, do: @sweet_xpath
  def convert_body(struct), do: Converter.convert(struct, @sweet_xpath)
end
