# ExOpenTravel

OpenTravel API Extension for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_open_travel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_open_travel, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
def load_bookings() do
  ExOpenTravel.ota_read(
    %{hotel_code: "PMS_HOTEL_CODE"},
    %{
      endpoint: "https://pms.opentravelcompany.com/requestor_id/OTA_PMS.php",
      password: "PASSWORD",
      user: "USER"
    }
  )
end
```