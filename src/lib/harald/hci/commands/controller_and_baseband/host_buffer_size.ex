defmodule Harald.HCI.Commands.ControllerAndBaseband.HostBufferSize do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.39.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<
        host_acl_data_packet_length::little-size(16),
        host_synchronous_data_packet_length,
        host_total_num_acl_data_packets::little-size(16),
        host_total_num_synchronous_data_packets::little-size(16)
      >>) do
    decoded_host_buffer_size = %{
      host_acl_data_packet_length: host_acl_data_packet_length,
      host_synchronous_data_packet_length: host_synchronous_data_packet_length,
      host_total_num_acl_data_packets: host_total_num_acl_data_packets,
      host_total_num_synchronous_data_packets: host_total_num_synchronous_data_packets
    }

    {:ok, decoded_host_buffer_size}
  end

  @impl Command
  def decode_return_parameters(<<encoded_status>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, %{status: decoded_status}}
  end

  @impl Command
  def encode(%{
        host_acl_data_packet_length: host_acl_data_packet_length,
        host_synchronous_data_packet_length: host_synchronous_data_packet_length,
        host_total_num_acl_data_packets: host_total_num_acl_data_packets,
        host_total_num_synchronous_data_packets: host_total_num_synchronous_data_packets
      }) do
    encoded_host_buffer_size = <<
      host_acl_data_packet_length::little-size(16),
      host_synchronous_data_packet_length,
      host_total_num_acl_data_packets::little-size(16),
      host_total_num_synchronous_data_packets::little-size(16)
    >>

    {:ok, encoded_host_buffer_size}
  end

  @impl Command
  def encode_return_parameters(%{status: decoded_status}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status>>}
  end

  @impl Command
  def ocf(), do: 0x33
end
