defmodule ExOpenTravel.Composers.OtaHotelAvailQuery.Request do
  alias ExOpenTravel.Meta
  alias ExOpenTravel.Request
  alias ExOpenTravel.Request.Document

  @action "OTA_HotelAvailRQ"

  @type credentials :: %{user: String.t(), password: String.t(), endpoint: String.t()}
  @type t :: %{hotel_code: String.t()}
  @type options :: keyword() | any()

  @doc """
  This method is used to room_stay query.
  """
  @spec execute(t, credentials, Meta.t(), options) ::
          {:ok, struct(), Meta.t()} | {:error, any(), Meta.t()}
  def execute(%{hotel_code: _} = params, credentials, meta, opts) do
    params
    |> build_hotel_avail_query(Map.put(meta, :method, @action))
    |> Document.build(@action, credentials)
    |> Request.send(credentials, opts)
  end

  @spec build_hotel_avail_query(t, Meta.t()) :: {{atom(), map | nil, list | nil}, Meta.t()}
  def build_hotel_avail_query(%{hotel_code: hotel_code} = payload, meta) do
    hotel_ref = {:HotelRef, %{HotelCode: hotel_code}, nil}
    criterion = {:Criterion, nil, [hotel_ref]}
    criteria = {:HotelSearchCriteria, nil, [criterion]}
    segment = {:AvailRequestSegment, %{AvailReqType: "Room"}, [criteria]}
    {{:AvailRequestSegments, nil, [segment]}, meta}
  end
end
