defmodule ExOpenTravel.Composers.OtaHotelInvCountNotif.Mapping do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @sweet_xpath [
    OTA_HotelInvCountNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelInvCountNotifRS']",
      Version: ~x"./@Version"os,
      EchoToken: ~x"./@EchoToken"os,
      TimeStamp: ~x"./@TimeStamp"os,
      Success: ~x"./*[local-name() = 'Success']/text()"os,
      Errors: [
        ~x"./*[local-name() = 'Errors']"l,
        Error: [
          ~x"./*[local-name() = 'Error']"l,
          Error: ~x"./text()"os,
          Type: ~x"./*[local-name() = 'Error']/@Type"os,
          Code: ~x"./*[local-name() = 'Error']/@Code"os
        ]
      ],
      Warnings: [
        ~x"./*[local-name() = 'Warnings']"l,
        Warning: [
          ~x"./*[local-name() = 'Warning']"l,
          Warning: ~x"./text()"s,
          Type: ~x"./@Type"os,
          Code: ~x"./@Code"os,
          RecordID: ~x"./@RecordID"os
        ]
      ]
    ]
  ]
  def get_mapping_struct, do: @sweet_xpath
  def convert_body(struct), do: Converter.convert(struct, @sweet_xpath)
end
