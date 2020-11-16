defmodule Harald.HCI.ACLData do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 5.4.2.
  """

  alias Harald.Host.L2CAP
  alias Harald.HCI.Packet

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

  def decode(
        <<
          2,
          handle::little-size(12),
          encoded_packet_boundary_flag::size(2),
          encoded_broadcast_flag::size(2),
          data_total_length::little-size(16),
          data::binary-size(data_total_length)
        >> = encoded_bin
      ) do
    with {:ok, decoded_data} <- L2CAP.decode(data) do
      decoded = %__MODULE__{
        handle: handle,
        packet_boundary_flag: decode_packet_boundary_flag(encoded_packet_boundary_flag),
        broadcast_flag: decode_broadcast_flag(encoded_broadcast_flag),
        data_total_length: data_total_length,
        data: decoded_data
      }

      {:ok, decoded}
    else
      {:error, {:not_implemented, error, _bin}} ->
        {:error, {:not_implemented, error, encoded_bin}}
    end
  end

  def encode(%__MODULE__{
        broadcast_flag: broadcast_flag,
        data: data,
        data_total_length: data_total_length,
        handle: handle,
        packet_boundary_flag: packet_boundary_flag
      }) do
    encoded_packet_boundary_flag = encode_flag(packet_boundary_flag)
    encoded_broadcast_flag = encode_flag(broadcast_flag)
    {:ok, encoded_data} = L2CAP.encode(data)
    indicator = Packet.indicator(:acl_data)

    encoded = <<
      indicator,
      handle::little-size(12),
      encoded_packet_boundary_flag::size(2),
      encoded_broadcast_flag::size(2),
      data_total_length::little-size(16),
      encoded_data::binary-size(data_total_length)
    >>

    {:ok, encoded}
  end

  def new(handle, packet_boundary_flag, broadcast_flag, %data_module{} = data) do
    {:ok, data_bin} = data_module.encode(data)

    acl_data = %__MODULE__{
      handle: handle,
      packet_boundary_flag: packet_boundary_flag,
      broadcast_flag: broadcast_flag,
      data_total_length: byte_size(data_bin),
      data: data
    }

    {:ok, acl_data}
  end

  defp decode_broadcast_flag(0b00 = bc_flag) do
    %{description: "Point-to-point (ACL-U, AMP-U, or LE-U)", value: bc_flag}
  end

  defp decode_broadcast_flag(0b01 = bc_flag) do
    %{description: "BR/EDR broadcast (ASB-U)", value: bc_flag}
  end

  defp decode_broadcast_flag(0b10 = bc_flag) do
    %{description: "Reserved for future use.", value: bc_flag}
  end

  defp decode_broadcast_flag(0b11 = bc_flag) do
    %{description: "Reserved for future use.", value: bc_flag}
  end

  defp decode_packet_boundary_flag(0b00 = pb_flag) do
    %{
      description:
        "First non-automatically-flushable packet of a higher layer message (start of a non-automatically-flushable L2CAP PDU) from Host to Controller.",
      value: pb_flag
    }
  end

  defp decode_packet_boundary_flag(0b01 = pb_flag) do
    %{
      description: "Continuing fragment of a higher layer message",
      value: pb_flag
    }
  end

  defp decode_packet_boundary_flag(0b10 = pb_flag) do
    %{
      description:
        "First automatically flushable packet of a higher layer message (start of an automatically-flushable L2CAP PDU).",
      value: pb_flag
    }
  end

  defp decode_packet_boundary_flag(0b11 = pb_flag) do
    %{
      description: "A complete L2CAP PDU. Automatically flushable.",
      value: pb_flag
    }
  end

  defp encode_flag(%{value: encoded_flag}) when encoded_flag in [0b00, 0b01, 0b10, 0b11] do
    encoded_flag
  end
end
