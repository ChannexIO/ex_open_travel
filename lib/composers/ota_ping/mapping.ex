defmodule ExOpenTravel.Composers.OtaPing.Mapping do
  @behaviour ExOpenTravel.Response.Converter
  alias ExOpenTravel.Response.Converter
  import SweetXml

  @sweet_xpath [
    OTA_PingRS: [
      ~x"//*[local-name() = 'OTA_PingRS']",
      "@Version": ~x"./@Version"os,
      "@EchoToken": ~x"./@EchoToken"os,
      "@TimeStamp": ~x"./@TimeStamp"os
    ]
  ]

  @success [
    OTA_PingRS: [
      ~x"//*[local-name() = 'OTA_PingRS']",
      Success: ~x"./*[local-name() = 'Success']"
    ]
  ]

  @errors [
    OTA_PingRS: [
      ~x"//*[local-name() = 'OTA_PingRS']",
      Errors: [
        ~x"./*[local-name() = 'Errors']/*[local-name() = 'Error']"l,
        Error: ~x"./text()"os,
        "@Type": ~x"./@Type"os,
        "@Code": ~x"./@Code"os
      ]
    ]
  ]

  @warnings [
    OTA_PingRS: [
      ~x"//*[local-name() = 'OTA_PingRS']",
      Warnings: [
        ~x"./*[local-name() = 'Warnings']/*[local-name() = 'Warning']"l,
        Warning: ~x"./text()"s,
        "@Type": ~x"./@Type"os,
        "@Code": ~x"./@Code"os,
        RecordID: ~x"./@RecordID"os
      ]
    ]
  ]

  @action :OTA_PingRS

  def get_action_name, do: @action
  def get_mapping_for_success, do: @success
  def get_mapping_for_errors, do: @errors
  def get_mapping_for_warnings, do: @warnings
  def get_mapping_for_payload, do: @sweet_xpath
  def convert_body(struct), do: Converter.convert(struct, @sweet_xpath)
end
