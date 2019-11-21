defmodule ExOpenTravel.Composers.OtaHotelResNotif.ResponseTest do
  use ExUnit.Case
  doctest ExOpenTravel
  @moduletag :ex_open_travel_mapping_ota_hotel_res_notif
  import SweetXml
  alias ExOpenTravel.Response.Converter
  alias ExOpenTravel.Composers.OtaHotelResNotif.Mapping

  @raw_message_with_warning ~s|<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:ns2="http://www.w3.org/2005/08/addressing" xmlns:ns3="http://www.opentravel.org/OTA/2003/05">
    <SOAP-ENV:Header>
        <ns1:MessageID>uuid:61b23eff-778c-797a-0a2d-f65de1b1ea1f</ns1:MessageID>
        <ns2:RelatesTo>uuid:0a5ef840-89e8-46de-9389-c59466858db8</ns2:RelatesTo>
    </SOAP-ENV:Header>
    <SOAP-ENV:Body>
        <ns3:OTA_HotelResNotifRS TimeStamp="2019-11-18T11:41:03+01:00">
            <ns3:Success/>
            <ns3:Warnings>
                <ns3:Warning Type="Booking reference invalid" Code="87" RecordID=""/>
                <ns3:Warning Type="Booking reference invalid" Code="87" RecordID=""/>
            </ns3:Warnings>
        </ns3:OTA_HotelResNotifRS>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|

  @message_with_warnings %{
    OTA_HotelResNotifRS: %{"@EchoToken": "", "@TimeStamp": "2019-11-18T11:41:03+01:00", "@Version": ""},
    Success: true,
    Warnings: [
      %{"@Code": "87", "@RecordID": "", "@Type": "Booking reference invalid", Warning: ""},
      %{"@Code": "87", "@RecordID": "", "@Type": "Booking reference invalid", Warning: ""}
    ]
  }

  test "convert success" do
    mapping = %{
      action: Mapping.get_action_name(),
      success_mapping: Mapping.get_mapping_for_success(),
      warning_mapping: Mapping.get_mapping_for_warnings(),
      error_mapping: Mapping.get_mapping_for_errors(),
      payload_mapping: Mapping.get_mapping_for_payload()
    }

    assert {:ok, @message_with_warnings, %{}} ==
             Converter.convert({:ok, @raw_message_with_warning, %{}}, mapping)
  end

  test "convert fail" do
    mapping = %{
      action: Mapping.get_action_name(),
      success_mapping: Mapping.get_mapping_for_success(),
      warning_mapping: Mapping.get_mapping_for_warnings(),
      error_mapping: Mapping.get_mapping_for_errors(),
      payload_mapping: Mapping.get_mapping_for_payload()
    }

    assert {:error,
            %ExOpenTravel.Error{
              reason:
                {:catch_error,
                 {:fatal,
                  {:expected_element_start_tag, {:file, :file_name_unknown}, {:line, 1},
                   {:col, 2}}}}
            },
            %{
              errors: [
                "Catch error: {:fatal, {:expected_element_start_tag, {:file, :file_name_unknown}, {:line, 1}, {:col, 2}}}}"
              ],
              success: false
            }} ==
             Converter.convert({:ok, "abrakadabra", %{}}, mapping)
  end
end
