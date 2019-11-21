defmodule ExOpenTravel do
  @moduledoc """
  Documentation for ExOpenTravel.
  """

  alias ExOpenTravel.Composers.{
    OtaHotelBookingRuleNotif,
    OtaHotelInvCountNotif,
    OtaHotelRateAmountNotif,
    OtaHotelResNotif,
    OtaHotelAvailQuery,
    OtaPing,
    OtaRead
  }

  alias ExOpenTravel.Meta
  alias ExOpenTravel.Response

  @type credentials :: %{endpoint: String.t(), password: String.t(), user: String.t()}
  @type response :: {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  @type options :: keyword() | any()

  @doc """
    Ping message

    This is a simple XML message that could be useful to test if the connection is working correctly. We suggest
  to implement this method first in order to be sure that the SOAP level communication is correct.

  ## Example

    ExOpenTravel.ota_ping()
  """
  @spec ota_ping(credentials, map(), options) :: response()
  def ota_ping(credentials, customization \\ %{}, opts \\ [])

  def ota_ping(credentials, customization, opts) do
    response_mapping = OtaPing |> get_default_mapping() |> Map.merge(customization)

    credentials
    |> OtaPing.Request.execute(prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update availability.
  """
  @spec ota_hotel_inv_count_notif(OtaHotelInvCountNotif.t(), credentials, map(), options) ::
          response()
  def ota_hotel_inv_count_notif(params, credentials, customization \\ %{}, opts \\ [])

  def ota_hotel_inv_count_notif(
        %{hotel_code: _, inventories: _} = params,
        credentials,
        customization,
        opts
      ) do
    response_mapping = OtaHotelInvCountNotif |> get_default_mapping() |> Map.merge(customization)

    params
    |> OtaHotelInvCountNotif.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update rates (per room prices).
  """
  @spec ota_hotel_rate_amount_notif(OtaHotelRateAmountNotif.t(), credentials, map(), options) ::
          response()
  def ota_hotel_rate_amount_notif(params, credentials, customization \\ %{}, opts \\ [])

  def ota_hotel_rate_amount_notif(
        %{hotel_code: _, rate_amount_messages: _} = params,
        credentials,
        customization,
        opts
      ) do
    response_mapping =
      OtaHotelRateAmountNotif |> get_default_mapping() |> Map.merge(customization)

    params
    |> OtaHotelRateAmountNotif.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update booking rule.
  """
  @spec ota_hotel_booking_rule_notif(
          OtaHotelBookingRuleNotif.t(),
          credentials,
          map(),
          options
        ) ::
          response()
  def ota_hotel_booking_rule_notif(params, credentials, customization \\ %{}, opts \\ [])

  def ota_hotel_booking_rule_notif(
        %{hotel_code: _, rule_messages: _} = params,
        credentials,
        customization,
        opts
      ) do
    response_mapping =
      OtaHotelBookingRuleNotif |> get_default_mapping() |> Map.merge(customization)

    params
    |> OtaHotelBookingRuleNotif.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used for booking confirmation.
  """
  @spec ota_hotel_res_notif(OtaHotelResNotif.t(), credentials, map(), options) :: response()
  def ota_hotel_res_notif(booking_ids, credentials, customization \\ %{}, opts \\ [])

  def ota_hotel_res_notif(booking_ids, credentials, customization, opts) do
    response_mapping = OtaHotelResNotif |> get_default_mapping() |> Map.merge(customization)

    %{
      hotel_reservations:
        Enum.map(
          booking_ids,
          &%{
            unique_id: %{
              type: "14",
              id_context: "CrsConfirmNumber",
              id: &1
            },
            res_global_info: %{
              hotel_reservation_ids: [
                %{
                  res_id_type: "10",
                  res_id_value: "xxxxxx",
                  res_id_source: "PMS",
                  res_id_source_context: "PmsConfirmNumber"
                }
              ]
            }
          }
        )
    }
    |> OtaHotelResNotif.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is retrieve reservations for property.
  Credential need contain fields: `endpoint, user, password`
  ## Examples

      iex > ExOpenTravel.ota_read(%{hotel_code: "123456"},
                                 %{endpoint: "https://pms.otachannel.com/requestor_id/OTA_PMS.php",
                                   password: "123456789",
                                   user: "987654321"}
                                 )
      {:ok, %{}, %{}}


  Also if you need request tokenization on PCI_Booking,
  credential should include `pci_proxy: :pci_booking`
    ## Examples

      iex > ExOpenTravel.ota_read(%{hotel_code: "123456"},
                                 %{endpoint: "https://pms.otachannel.com/requestor_id/OTA_PMS.php",
                                   password: "123456789",
                                   user: "987654321",
                                   pci_pci_proxy: :pci_booking,
                                   pci_booking_fetch_header: "X-OTACHANNELFETCHCC",
                                   pci_booking_profile_name: "ConcreteOpenTravelProfile",
                                   pci_booking_api_key: "00000000000000000000000000000000"}
                                 )
      {:ok, %{}, %{}}
  """
  @spec ota_read(OtaRead.t(), credentials, map(), options) :: response()
  def ota_read(params, credentials, customization \\ %{}, opts \\ [])

  def ota_read(%{hotel_code: _} = params, credentials, customization, opts) do
    response_mapping = OtaRead |> get_default_mapping() |> Map.merge(customization)

    params
    |> OtaRead.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to Availability querying
  """
  @spec ota_hotel_avail_query(OtaHotelAvailQuery.t(), credentials, map(), options) ::
          response()
  def ota_hotel_avail_query(params, credentials, customization \\ %{}, opts \\ [])

  def ota_hotel_avail_query(%{hotel_code: _} = params, credentials, customization, opts) do
    response_mapping = OtaHotelAvailQuery |> get_default_mapping() |> Map.merge(customization)

    params
    |> OtaHotelAvailQuery.Request.execute(credentials, prepare_meta(), opts)
    |> Response.parse_response(response_mapping)
  end

  defp get_default_mapping(module) do
    node = Node.self()

    %{
      action: :rpc.call(node, :"#{module}.Mapping", :get_action_name, []),
      success_mapping: :rpc.call(node, :"#{module}.Mapping", :get_mapping_for_success, []),
      warning_mapping: :rpc.call(node, :"#{module}.Mapping", :get_mapping_for_warnings, []),
      error_mapping: :rpc.call(node, :"#{module}.Mapping", :get_mapping_for_errors, []),
      payload_mapping: :rpc.call(node, :"#{module}.Mapping", :get_mapping_for_payload, [])
    }
  end

  defp prepare_meta() do
    %{
      request: nil,
      response: nil,
      method: nil,
      started_at: DateTime.utc_now(),
      finished_at: nil,
      success: true,
      errors: []
    }
  end
end
