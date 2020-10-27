defmodule Harald.HCI.ACLData do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 5.4.2.
  """

  alias Harald.Host.L2CAP

  @enforce_keys [
    :handle,
    :packet_boundary_flag,
    :broadcast_flag,
    :data_total_length,
    :data
  ]

  defstruct [
    :handle,
    :packet_boundary_flag,
    :broadcast_flag,
    :data_total_length,
    :data
  ]

  def decode(<<
        handle::bits-size(12),
        pb_flag::size(2),
        bc_flag::size(2),
        data_total_length::little-size(16),
        data::binary-size(data_total_length)
      >>) do
    {:ok, decoded_data} = L2CAP.decode(data)

    decoded = %__MODULE__{
      handle: handle,
      packet_boundary_flag: decode_pb_flag!(pb_flag),
      broadcast_flag: decode_bc_flag!(bc_flag),
      data_total_length: data_total_length,
      data: decoded_data
    }

    {:ok, decoded}
  end

  def encode(%__MODULE__{
        handle: handle,
        packet_boundary_flag: pb_flag,
        broadcast_flag: bc_flag,
        data_total_length: data_total_length,
        data: data
      }) do
    encoded_pb_flag = encode_pb_flag!(pb_flag)
    encoded_bc_flag = encode_bc_flag!(bc_flag)
    {:ok, encoded_data} = L2CAP.encode(data)

    encoded = <<
      handle::bits-size(12),
      encoded_pb_flag::size(2),
      encoded_bc_flag::size(2),
      data_total_length::little-size(16),
      encoded_data::binary
    >>

    {:ok, encoded}
  end

  def new(handle, packet_boundary_flag, broadcast_flag, data) do
    acl_data = %__MODULE__{
      handle: handle,
      packet_boundary_flag: packet_boundary_flag,
      broadcast_flag: broadcast_flag,
      data_total_length: byte_size(data),
      data: data
    }

    {:ok, acl_data}
  end

  defp decode_bc_flag!(0b00 = bc_flag) do
    %{description: "Point-to-point (ACL-U, AMP-U, or LE-U)", value: bc_flag}
  end

  defp decode_bc_flag!(0b01 = bc_flag) do
    %{description: "BR/EDR broadcast (ASB-U)", value: bc_flag}
  end

  defp decode_bc_flag!(0b10 = bc_flag) do
    %{description: "Reserved for future use.", value: bc_flag}
  end

  defp decode_bc_flag!(0b11 = bc_flag) do
    %{description: "Reserved for future use.", value: bc_flag}
  end

  defp decode_pb_flag!(0b00 = pb_flag) do
    %{
      description:
        "First non-automatically-flushable packet of a higher layer message (start of a non-automatically-flushable L2CAP PDU) from Host to Controller.",
      value: pb_flag
    }
  end

  defp decode_pb_flag!(0b01 = pb_flag) do
    %{
      description: "Continuing fragment of a higher layer message",
      value: pb_flag
    }
  end

  defp decode_pb_flag!(0b10 = pb_flag) do
    %{
      description:
        "First automatically flushable packet of a higher layer message (start of an automatically-flushable L2CAP PDU).",
      value: pb_flag
    }
  end

  defp decode_pb_flag!(0b11 = pb_flag) do
    %{
      description: "A complete L2CAP PDU. Automatically flushable.",
      value: pb_flag
    }
  end

  defp encode_bc_flag!(%{value: encoded_bc_flag})
       when encoded_bc_flag in [0b00, 0b01, 0b10, 0b11] do
    encoded_bc_flag
  end

  defp encode_pb_flag!(%{value: encoded_pb_flag})
       when encoded_pb_flag in [0b00, 0b01, 0b10, 0b11] do
    encoded_pb_flag
  end
end
