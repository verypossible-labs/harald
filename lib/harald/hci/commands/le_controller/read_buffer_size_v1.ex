defmodule Harald.HCI.Commands.LEController.ReadBufferSizeV1 do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.8.2.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(
        <<encoded_status, le_acl_data_packet_length::little-size(16),
          total_num_le_acl_data_packets>>
      ) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)

    {:ok,
     %{
       status: decoded_status,
       le_acl_data_packet_length: le_acl_data_packet_length,
       total_num_le_acl_data_packets: total_num_le_acl_data_packets
     }}
  end

  @impl Command
  def encode_return_parameters(%{
        status: decoded_status,
        le_acl_data_packet_length: le_acl_data_packet_length,
        total_num_le_acl_data_packets: total_num_le_acl_data_packets
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    {:ok,
     <<encoded_status, le_acl_data_packet_length::little-size(16), total_num_le_acl_data_packets>>}
  end

  @impl Command
  def ocf(), do: 0x02
end
