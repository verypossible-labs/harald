defmodule Harald.HCI.Commands.InformationalParameters.ReadBufferSize do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.4.5.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes, Events.Event}

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(
        <<status, acl_data_packet_length::little-size(16), synchronous_data_packet_length,
          total_num_acl_data_packets::little-size(16),
          total_num_synchronous_data_packets::little-size(16)>>
      ) do
    {:ok, decoded_status} = ErrorCodes.decode(status)

    decoded_return_parameters = %{
      status: decoded_status,
      acl_data_packet_length: acl_data_packet_length,
      synchronous_data_packet_length: synchronous_data_packet_length,
      total_num_acl_data_packets: total_num_acl_data_packets,
      total_num_synchronous_data_packets: total_num_synchronous_data_packets
    }

    {:ok, decoded_return_parameters}
  end

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def encode_return_parameters(%{
        status: decoded_status,
        acl_data_packet_length: acl_data_packet_length,
        synchronous_data_packet_length: synchronous_data_packet_length,
        total_num_acl_data_packets: total_num_acl_data_packets,
        total_num_synchronous_data_packets: total_num_synchronous_data_packets
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    encoded_return_parameters =
      <<encoded_status, acl_data_packet_length::little-size(16), synchronous_data_packet_length,
        total_num_acl_data_packets::little-size(16),
        total_num_synchronous_data_packets::little-size(16)>>

    {:ok, encoded_return_parameters}
  end

  @impl Command
  def ocf(), do: 0x05
end
