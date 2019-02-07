defmodule Harald.HCI.Event.LEMeta.AdvertisingReport do
  @moduledoc """
  > The LE Advertising Report event indicates that one or more Bluetooth devices have responded to
  > an active scan or have broadcast advertisements that were received during a passive scan. The
  > Controller may queue these advertising reports and send information from multiple devices in one
  > LE Advertising Report event.
  >
  > This event shall only be generated if scanning was enabled using the LE Set Scan Enable
  > command. It only reports advertising events that used legacy advertising PDUs.
  Bluetooth Spec v5
  """

  alias __MODULE__

  @enforce_keys [:event_type, :address_type, :address, :data, :rss]
  defstruct @enforce_keys

  @type t :: %__MODULE__{}

  def merge(%AdvertisingReport{data: d1} = ar1, %AdvertisingReport{data: d2} = ar2) do
    ar1
    |> Map.merge(ar2)
    |> Map.put(:data, Map.merge(d1, d2))
  end

  def parse(<<1>> <> params) do
    <<event_type, address_type, address::size(48)-little, length_data>> <> remaining_params =
      params

    data = binary_part(remaining_params, 0, length_data)

    <<rss>> = binary_part(remaining_params, length_data, 1)

    [
      %__MODULE__{
        event_type: event_type,
        address_type: address_type,
        address: Integer.to_string(address, 16),
        data: data |> parse_advertising_data() |> Map.new(),
        rss: rss
      }
    ]
  end

  def parse_advertising_data(""), do: []

  def parse_advertising_data(<<length_data, ad_type>> <> data) do
    adjusted_length = length_data - 1
    ad_datum = binary_part(data, 0, adjusted_length)
    remainder_datum = binary_part(data, adjusted_length, byte_size(data) - adjusted_length)

    [
      parse_ad_datum(ad_type, ad_datum)
      | parse_advertising_data(remainder_datum)
    ]
  end

  def parse_ad_datum(0xFF, <<0x4C, 0x00, 0x02, 0x15>> <> datum) do
    <<uuid::size(128), major::size(16), minor::size(16), tx_power>> = datum

    {:ibeacon, %{uuid: int_to_uuid(uuid), major: major, minor: minor, tx_power: tx_power}}
  end

  def parse_ad_datum(type, datum), do: {type, datum}

  @doc """
      iex> int_to_uuid(0x58c8d08376684590801f063c9346538e)
      "58C8D083-7668-4590-801F-063C9346538E"
  """
  def int_to_uuid(n) do
    uuid =
      n
      |> Integer.to_string(16)
      |> String.pad_leading(32, "0")

    Regex.replace(~r/^(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})$/, uuid, ~S(\1-\2-\3-\4-\5))
  end
end
