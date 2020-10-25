defmodule Harald.HCI.ACLDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.ACLData

  test "decode/1" do
    handle = <<1::size(8), 2::size(4)>>
    pb_flag = 0b00
    bc_flag = 0b00
    data = <<1, 3, 3, 7>>
    data_total_length = byte_size(data)

    encoded_acl_data = <<
      handle::bits-size(12),
      pb_flag::size(2),
      bc_flag::size(2),
      data_total_length::little-size(16),
      data::binary
    >>

    decoded_acl_data = %ACLData{
      handle: handle,
      packet_boundary_flag: %{
        description:
          "First non-automatically-flushable packet of a higher layer message (start of a non-automatically-flushable L2CAP PDU) from Host to Controller.",
        value: pb_flag
      },
      broadcast_flag: %{description: "Point-to-point (ACL-U, AMP-U, or LE-U)", value: bc_flag},
      data_total_length: data_total_length,
      data: data
    }

    assert {:ok, decoded_acl_data} == ACLData.decode(encoded_acl_data)
  end

  test "encode/1" do
    handle = <<1::size(8), 2::size(4)>>
    pb_flag = 0b00
    bc_flag = 0b00
    data = <<1, 3, 3, 7>>
    data_total_length = byte_size(data)

    encoded_acl_data = <<
      handle::bits-size(12),
      pb_flag::size(2),
      bc_flag::size(2),
      data_total_length::little-size(16),
      data::binary
    >>

    decoded_acl_data = %ACLData{
      handle: handle,
      packet_boundary_flag: %{
        description:
          "First non-automatically-flushable packet of a higher layer message (start of a non-automatically-flushable L2CAP PDU) from Host to Controller.",
        value: pb_flag
      },
      broadcast_flag: %{description: "Point-to-point (ACL-U, AMP-U, or LE-U)", value: bc_flag},
      data_total_length: data_total_length,
      data: data
    }

    assert {:ok, encoded_acl_data} == ACLData.encode(decoded_acl_data)
  end
end
