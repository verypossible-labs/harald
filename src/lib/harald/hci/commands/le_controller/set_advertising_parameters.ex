defmodule Harald.HCI.Commands.LEController.SetAdvertisingParameters do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.8.5.
  """

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
    peer_address = String.pad_trailing(peer_address, 6, <<0>>)

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
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x06
end
