defmodule Harald.HCI.SynchronousDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.SynchronousData

  test "decode/1" do
    connection_handle = <<1::size(8), 2::size(4)>>
    packet_status_flag = 0b00
    rfu = 0b00
    data = <<1, 3, 3, 7>>
    data_total_length = byte_size(data)

    encoded_acl_data = <<
      connection_handle::bits-size(12),
      packet_status_flag::size(2),
      rfu::size(2),
      data_total_length,
      data::binary
    >>

    decoded_acl_data = %SynchronousData{
      connection_handle: connection_handle,
      packet_status_flag: %{
        description:
          "Correctly received data. The payload data belongs to received eSCO or SCO packets that the baseband marked as \"good data\".",
        value: packet_status_flag
      },
      rfu: rfu,
      data_total_length: data_total_length,
      data: data
    }

    assert {:ok, decoded_acl_data} == SynchronousData.decode(encoded_acl_data)
  end

  test "encode/1" do
    connection_handle = <<1::size(8), 2::size(4)>>
    packet_status_flag = 0b00
    rfu = 0b00
    data = <<1, 3, 3, 7>>
    data_total_length = byte_size(data)

    encoded_acl_data = <<
      connection_handle::bits-size(12),
      packet_status_flag::size(2),
      rfu::size(2),
      data_total_length,
      data::binary
    >>

    decoded_acl_data = %SynchronousData{
      connection_handle: connection_handle,
      packet_status_flag: %{
        description:
          "Correctly received data. The payload data belongs to received eSCO or SCO packets that the baseband marked as \"good data\".",
        value: packet_status_flag
      },
      rfu: rfu,
      data_total_length: data_total_length,
      data: data
    }

    assert {:ok, encoded_acl_data} == SynchronousData.encode(decoded_acl_data)
  end
end
