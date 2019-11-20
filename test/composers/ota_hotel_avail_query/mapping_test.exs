defmodule ExOpenTravel.Composers.OtaHotelAvailQuery.ResponseTest do
  use ExUnit.Case
  doctest ExOpenTravel
  @moduletag :ex_open_travel_ota_hotel_avail_query_mapping
  import SweetXml
  alias ExOpenTravel.Response.Converter
  alias ExOpenTravel.Composers.OtaHotelAvailQuery.Mapping

  @raw_message ~s|<OTA_HotelAvailRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="1.0" TimeStamp="2005-08-01T09:30:47+02:00" EchoToken="abc123">
  <Success/>
  <RoomStays>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="SGL">
          <RoomDescription Name="Single Room"/>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate"/>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="SGL">
          <RoomDescription Name="Single Room"/>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="LTS">
          <RatePlanDescription Name="Long Term Stay"/>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="DBX">
          <RoomDescription Name="Deluxe Double Room"/>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate"/>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="DBL">
          <RoomDescription Name="Standard Double Room"/>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate"/>
        </RatePlan>
      </RatePlans>
    </RoomStay>
  </RoomStays>
</OTA_HotelAvailRS>
Response with additional room description
<OTA_HotelAvailRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="1.0" TimeStamp="2005-08-01T09:30:47+02:00" EchoToken="abc123">
  <Success/>
  <RoomStays>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="SGL">
          <RoomDescription Name="Single Room">
            <Text>Bedding is Queen sized bed. Continental breakfast for each guest.</Text>
          </RoomDescription>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate">
            <Text>Best available rate including breakfast.</Text>
          </RatePlanDescription>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="SGL">
          <RoomDescription Name="Single Room">
            <Text>Bedding is Queen sized bed. Continental breakfast for each guest.</Text>
          </RoomDescription>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="LTS">
          <RatePlanDescription Name="Long Term Stay">
            <Text>Special offer for 3 nights stay, pay only for 2!  Rates include breakfast.</Text>
          </RatePlanDescription>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="DBX">
          <RoomDescription Name="Deluxe Double Room">
            <Text>Bedding is 1 x King sized bed and 1 x Single bed. Continental breakfast for each guest.</Text>
          </RoomDescription>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate">
            <Text>Best available rate including breakfast.</Text>
          </RatePlanDescription>
        </RatePlan>
      </RatePlans>
    </RoomStay>
    <RoomStay>
      <RoomTypes>
        <RoomType RoomTypeCode="DBL">
          <RoomDescription Name="Standard Double Room">
            <Text>Bedding is 2 x Queen sized bed. Continental breakfast for each guest.</Text>
          </RoomDescription>
        </RoomType>
      </RoomTypes>
      <RatePlans>
        <RatePlan RatePlanCode="BAR">
          <RatePlanDescription Name="Best Available Rate">
            <Text>Best available rate including breakfast.</Text>
          </RatePlanDescription>
        </RatePlan>
      </RatePlans>
    </RoomStay>
  </RoomStays>
</OTA_HotelAvailRS>
|

  @message %{
    Success: true,
    OTA_HotelAvailRS: %{
      EchoToken: "abc123",
      TimeStamp: "2005-08-01T09:30:47+02:00",
      Version: "1.0",
      RoomStays: [
        %{
          RatePlans: [%{RatePlanCode: "BAR", RatePlanDescription: nil}],
          RoomTypes: [%{RoomDescription: %{Name: "Single Room", Text: ""}, RoomTypeCode: "SGL"}]
        },
        %{
          RatePlans: [%{RatePlanCode: "LTS", RatePlanDescription: nil}],
          RoomTypes: [%{RoomDescription: %{Name: "Single Room", Text: ""}, RoomTypeCode: "SGL"}]
        },
        %{
          RatePlans: [%{RatePlanCode: "BAR", RatePlanDescription: nil}],
          RoomTypes: [
            %{RoomDescription: %{Name: "Deluxe Double Room", Text: ""}, RoomTypeCode: "DBX"}
          ]
        },
        %{
          RatePlans: [%{RatePlanCode: "BAR", RatePlanDescription: nil}],
          RoomTypes: [
            %{RoomDescription: %{Name: "Standard Double Room", Text: ""}, RoomTypeCode: "DBL"}
          ]
        }
      ]
    }
  }

  test "convert success" do
    mapping = %{
      action: Mapping.get_action_name(),
      success_mapping: Mapping.get_mapping_for_success(),
      warning_mapping: Mapping.get_mapping_for_warnings(),
      error_mapping: Mapping.get_mapping_for_errors(),
      payload_mapping: Mapping.get_mapping_for_payload()
    }

    assert {:ok, @message, %{}} == Converter.convert({:ok, @raw_message, %{}}, mapping)
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
