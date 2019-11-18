defmodule ExOpenTravel do
  @moduledoc """
  Documentation for ExOpenTravel.
  """

  alias ExOpenTravel.Composers.{
    OtaHotelBookingRuleNotif,
    OtaHotelInvCountNotif,
    OtaHotelRateAmountNotif,
    OtaHotelResNotif,
    OtaPing,
    OtaRead
  }

  alias ExOpenTravel.Meta
  alias ExOpenTravel.Response

  @type credentials :: %{endpoint: String.t(), password: String.t(), user: String.t()}

  @doc """
    Ping message

    This is a simple XML message that could be useful to test if the connection is working correctly. We suggest
  to implement this method first in order to be sure that the SOAP level communication is correct.

  ## Example

    ExOpenTravel.ota_ping()
  """
  @spec ota_ping(credentials, map()) :: {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_ping(credentials, customization \\ %{})

  def ota_ping(credentials, customization) do
    response_mapping =
      Map.merge(
        %{
          action: OtaPing.Mapping.get_action_name(),
          success_mapping: OtaPing.Mapping.get_mapping_for_success(),
          warning_mapping: OtaPing.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaPing.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaPing.Mapping.get_mapping_for_payload()
        },
        customization
      )

    credentials
    |> OtaPing.Request.execute(prepare_meta())
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update availability.
  """
  @spec ota_hotel_inv_count_notif(OtaHotelInvCountNotif.t(), credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_hotel_inv_count_notif(params, credentials, customization \\ %{})

  def ota_hotel_inv_count_notif(
        %{hotel_code: _, inventories: _} = params,
        credentials,
        customization
      ) do
    response_mapping =
      Map.merge(
        %{
          action: OtaHotelInvCountNotif.Mapping.get_action_name(),
          success_mapping: OtaHotelInvCountNotif.Mapping.get_mapping_for_success(),
          warning_mapping: OtaHotelInvCountNotif.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaHotelInvCountNotif.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaHotelInvCountNotif.Mapping.get_mapping_for_payload()
        },
        customization
      )

    params
    |> OtaHotelInvCountNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update rates (per room prices).
  """
  @spec ota_hotel_rate_amount_notif(OtaHotelRateAmountNotif.t(), credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_hotel_rate_amount_notif(params, credentials, customization \\ %{})

  def ota_hotel_rate_amount_notif(
        %{hotel_code: _, rate_amount_messages: _} = params,
        credentials,
        customization
      ) do
    response_mapping =
      Map.merge(
        %{
          action: OtaHotelRateAmountNotif.Mapping.get_action_name(),
          success_mapping: OtaHotelRateAmountNotif.Mapping.get_mapping_for_success(),
          warning_mapping: OtaHotelRateAmountNotif.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaHotelRateAmountNotif.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaHotelRateAmountNotif.Mapping.get_mapping_for_payload()
        },
        customization
      )

    params
    |> OtaHotelRateAmountNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used to update booking rule.
  """
  @spec ota_hotel_booking_rule_notif(OtaHotelBookingRuleNotif.t(), credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_hotel_booking_rule_notif(params, credentials, customization \\ %{})

  def ota_hotel_booking_rule_notif(
        %{hotel_code: _, rule_messages: _} = params,
        credentials,
        customization
      ) do
    response_mapping =
      Map.merge(
        %{
          action: OtaHotelBookingRuleNotif.Mapping.get_action_name(),
          success_mapping: OtaHotelBookingRuleNotif.Mapping.get_mapping_for_success(),
          warning_mapping: OtaHotelBookingRuleNotif.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaHotelBookingRuleNotif.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaHotelBookingRuleNotif.Mapping.get_mapping_for_payload()
        },
        customization
      )

    params
    |> OtaHotelBookingRuleNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is used for booking confirmation.
  """
  @spec ota_hotel_res_notif(list(), credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_hotel_res_notif(booking_ids, credentials, customization \\ %{})

  def ota_hotel_res_notif(booking_ids, credentials, customization) do
    response_mapping =
      Map.merge(
        %{
          action: OtaHotelResNotif.Mapping.get_action_name(),
          success_mapping: OtaHotelResNotif.Mapping.get_mapping_for_success(),
          warning_mapping: OtaHotelResNotif.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaHotelResNotif.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaHotelResNotif.Mapping.get_mapping_for_payload()
        },
        customization
      )

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
    |> OtaHotelResNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(response_mapping)
  end

  @doc """
  This method is retrieve reservations for property.
  """
  @spec ota_read(%{hotel_code: String.t()}, credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_read(params, credentials, customization \\ %{})

  def ota_read(%{hotel_code: _} = params, credentials, customization) do
    response_mapping =
      Map.merge(
        %{
          action: OtaRead.Mapping.get_action_name(),
          success_mapping: OtaRead.Mapping.get_mapping_for_success(),
          warning_mapping: OtaRead.Mapping.get_mapping_for_warnings(),
          error_mapping: OtaRead.Mapping.get_mapping_for_errors(),
          payload_mapping: OtaRead.Mapping.get_mapping_for_payload()
        },
        customization
      )

    params
    |> OtaRead.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(response_mapping)
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
