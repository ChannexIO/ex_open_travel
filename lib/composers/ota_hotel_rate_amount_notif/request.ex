defmodule ExOpenTravel.Composers.OtaHotelRateAmountNotif.Request do
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.{Document, Helpers}

  @action "OTA_HotelRateAmountNotif"

  @type options :: keyword() | any()
  @type credentials :: %{user: String.t(), password: String.t(), endpoint: String.t()}
  @type t ::
          %{
            hotel_code: String.t(),
            rate_amount_messages: [
              %{
                status_application_control: %{
                  start: String.t(),
                  end: String.t(),
                  rate_plan_code: String.t(),
                  inv_type_code: String.t()
                },
                rates: [
                  %{
                    base_by_guest_amts: [
                      %{
                        currency_code: String.t(),
                        amount_after_tax: integer,
                        number_of_guests: integer,
                        age_qualifying_code: integer
                      }
                    ]
                  }
                ]
              }
            ]
          }

  @doc """
  This method is used to update rates (per room prices).
  """
  @spec execute(t, credentials, Meta.t(), options) ::
          {:ok, struct(), Meta.t()} | {:error, any(), Meta.t()}
  def execute(%{hotel_code: _, rate_amount_messages: _} = params, credentials, meta, opts) do
    params
    |> build_hotel_rate_amount_notif(Map.put(meta, :method, @action))
    |> Document.build(@action, credentials)
    |> Request.send(credentials, opts)
  end

  @spec build_hotel_rate_amount_notif(t, Meta.t()) :: {{atom(), map | nil, list | nil}, Meta.t()}
  def build_hotel_rate_amount_notif(%{hotel_code: _, rate_amount_messages: []} = payload, meta) do
    {:error, payload, meta |> Map.put(:success, false) |> Map.put(:errors, [:empty_payload])}
  end

  def build_hotel_rate_amount_notif(
        %{
          hotel_code: hotel_code,
          rate_amount_messages: rate_amount_messages
        },
        meta
      ) do
    rate_amount_messages_elements = Enum.map(rate_amount_messages, &build_def_amount_message/1)

    {
      {:"ns1:RateAmountMessages", %{HotelCode: "#{hotel_code}"}, rate_amount_messages_elements},
      meta
    }
  end

  defp build_def_amount_message(%{
         status_application_control: status_application_control,
         rates: rates
       }) do
    {:"ns1:RateAmountMessage", nil,
     [
       Helpers.build_status_application_control(status_application_control, nil, [
         {:RatePlanCode, status_application_control.rate_plan_code}
       ]),
       build_rates(rates)
     ]}
  end

  defp build_rates(rates) do
    {:"ns1:Rates", nil, Enum.map(rates, &build_rate/1)}
  end

  defp build_rate(%{base_by_guest_amts: base_by_guest_amts}) do
    {:"ns1:Rate", nil, [build_base_by_guest_amts(base_by_guest_amts)]}
  end

  defp build_base_by_guest_amts(base_by_guest_amts) do
    {:"ns1:BaseByGuestAmts", nil,
     Enum.map(base_by_guest_amts, fn base_by_guest_amt ->
       {:"ns1:BaseByGuestAmt", map_for_room_or_person(base_by_guest_amt), nil}
     end)}
  end

  defp map_for_room_or_person(%{
         currency_code: currency_code,
         amount_after_tax: amount_after_tax,
         number_of_guests: nil,
         age_qualifying_code: nil
       }) do
    %{
      AmountAfterTax: amount_after_tax,
      CurrencyCode: currency_code
    }
  end

  defp map_for_room_or_person(%{
         currency_code: currency_code,
         amount_after_tax: amount_after_tax,
         number_of_guests: number_of_guests,
         age_qualifying_code: age_qualifying_code
       }) do
    %{
      AmountAfterTax: amount_after_tax,
      CurrencyCode: currency_code,
      NumberOfGuests: number_of_guests,
      AgeQualifyingCode: age_qualifying_code
    }
  end
end
