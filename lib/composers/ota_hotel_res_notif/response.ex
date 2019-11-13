defmodule ExOpenTravel.Composers.OtaHotelResNotif.Response do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @sweet_xpath [
    OTA_HotelResNotifRS: [
      ~x"//*[local-name() = 'OTA_HotelResNotifRS']",
      Version: ~x"./@Version"os,
      EchoToken: ~x"./@EchoToken"os,
      TimeStamp: ~x"./@TimeStamp"os,
      Success: ~x"./*[local-name() = 'Success']/text()"os,
      Errors: [
        ~x"./*[local-name() = 'Errors']"ol,
        Error: ~x"./*[local-name() = 'Error']/text()"os,
        Type: ~x"./*[local-name() = 'Error']/@Type"os,
        Code: ~x"./*[local-name() = 'Error']/@Code"os
      ]
    ]
  ]
  def get_mapping_table, do: @sweet_xpath
  def convert_body(struct), do: Converter.convert(struct, @sweet_xpath)
end
