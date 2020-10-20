defmodule Harald.HCI.Commands.LEController.LESetAdvertisingParameters do
  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{
        advertising_interval_min: advertising_interval_min,
        advertising_interval_max: advertising_interval_max,
        advertising_type: advertising_type,
        own_address_type: own_address_type,
        peer_address_type: peer_address_type,
        peer_address: peer_address,
        advertising_channel_map: advertising_channel_map,
        advertising_filter_policy: advertising_filter_policy
      }) do
    bin =
      <<advertising_interval_min::little-size(16), advertising_interval_max::little-size(16),
        advertising_type, own_address_type, peer_address_type,
        peer_address::binary-little-size(6), advertising_channel_map, advertising_filter_policy>>

    {:ok, bin}
  end

  def encode(%{pin_type: :fixed}), do: {:ok, <<1>>}

  @impl Command
  def decode(
        <<advertising_interval_min::little-size(16), advertising_interval_max::little-size(16),
          advertising_type, own_address_type, peer_address_type,
          peer_address::binary-little-size(6), advertising_channel_map,
          advertising_filter_policy>>
      ) do
    parameters = %{
      advertising_interval_min: advertising_interval_min,
      advertising_interval_max: advertising_interval_max,
      advertising_type: advertising_type,
      own_address_type: own_address_type,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      advertising_channel_map: advertising_channel_map,
      advertising_filter_policy: advertising_filter_policy
    }

    {:ok, parameters}
  end

  @impl Command
  def ocf(), do: 0x06
end
