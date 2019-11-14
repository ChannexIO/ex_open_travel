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
    mapping_response =
      Map.get(customization, :mapping_response, OtaPing.Response.get_mapping_table())

    credentials
    |> OtaPing.Request.execute(prepare_meta())
    |> Response.parse_response(mapping_response)
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
    mapping_response =
      Map.get(
        customization,
        :mapping_response,
        OtaHotelInvCountNotif.Response.get_mapping_table()
      )

    params
    |> OtaHotelInvCountNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(mapping_response)
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
    mapping_response =
      Map.get(
        customization,
        :mapping_response,
        OtaHotelRateAmountNotif.Response.get_mapping_table()
      )

    params
    |> OtaHotelRateAmountNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(mapping_response)
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
    mapping_response =
      Map.get(
        customization,
        :mapping_response,
        OtaHotelBookingRuleNotif.Response.get_mapping_table()
      )

    params
    |> OtaHotelBookingRuleNotif.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(mapping_response)
  end

  @doc """
  This method is used for booking confirmation.
  """
  @spec ota_hotel_res_notif(list(), credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_hotel_res_notif(booking_ids, credentials, customization \\ %{})

  def ota_hotel_res_notif(booking_ids, credentials, customization) do
    mapping_response =
      Map.get(customization, :mapping_response, OtaHotelResNotif.Response.get_mapping_table())

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
    |> Response.parse_response(mapping_response)
  end

  @doc """
  This method is retrieve reservations for property.
  """
  @spec ota_read(%{hotel_code: String.t()}, credentials, map()) ::
          {:ok, any(), Meta.t()} | {:error, map(), Meta.t()}
  def ota_read(params, credentials, customization \\ %{})

  def ota_read(%{hotel_code: _} = params, credentials, customization) do
    mapping_response =
      Map.get(customization, :mapping_response, OtaRead.Response.get_mapping_table())

    params
    |> OtaRead.Request.execute(credentials, prepare_meta())
    |> Response.parse_response(mapping_response)
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
