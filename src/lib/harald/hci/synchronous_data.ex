defmodule Harald.HCI.SynchronousData do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 5.4.3.
  """

  @enforce_keys [
    :connection_handle,
    :packet_status_flag,
    :rfu,
    :data_total_length,
    :data
  ]

  defstruct [
    :connection_handle,
    :packet_status_flag,
    :rfu,
    :data_total_length,
    :data
  ]

  def decode(<<
        connection_handle::bits-size(12),
        encoded_packet_status_flag::size(2),
        rfu::size(2),
        data_total_length,
        data::binary-size(data_total_length)
      >>) do
    decoded = %__MODULE__{
      connection_handle: connection_handle,
      packet_status_flag: decode_packet_status_flag!(encoded_packet_status_flag),
      rfu: rfu,
      data_total_length: data_total_length,
      data: data
    }

    {:ok, decoded}
  end

  def encode(%__MODULE__{
        connection_handle: connection_handle,
        packet_status_flag: decoded_packet_status_flag,
        rfu: rfu,
        data_total_length: data_total_length,
        data: data
      }) do
    encoded_packet_status_flag = encode_packet_status_flag!(decoded_packet_status_flag)

    encoded = <<
      connection_handle::bits-size(12),
      encoded_packet_status_flag::size(2),
      rfu::size(2),
      data_total_length,
      data::binary
    >>

    {:ok, encoded}
  end

  def new(connection_handle, packet_status_flag, rfu, data) do
    synchronous_data = %__MODULE__{
      connection_handle: connection_handle,
      packet_status_flag: packet_status_flag,
      rfu: rfu,
      data_total_length: byte_size(data),
      data: data
    }

    {:ok, synchronous_data}
  end

  defp decode_packet_status_flag!(0b00 = bc_flag) do
    %{
      description:
        "Correctly received data. The payload data belongs to received eSCO or SCO packets that the baseband marked as \"good data\".",
      value: bc_flag
    }
  end

  defp decode_packet_status_flag!(0b01 = bc_flag) do
    %{
      description:
        "Possibly invalid data. At least one eSCO packet has been marked by the baseband as \"data with possible errors\" and all others have been marked as \"good data\" in the eSCO interval(s) corresponding to the HCI Synchronous Data packet.",
      value: bc_flag
    }
  end

  defp decode_packet_status_flag!(0b10 = bc_flag) do
    %{
      description:
        "No data received. All data from the baseband received during the (e)SCO interval(s) corresponding to the HCI Synchronous Data packet have been marked as \"lost data\" by the baseband. The Payload data octets shall be set to 0.",
      value: bc_flag
    }
  end

  defp decode_packet_status_flag!(0b11 = bc_flag) do
    %{
      description:
        "Data partially lost. Not all, but at least one (e)SCO packet has been marked as \"lost data\" by the baseband in the (e)SCO intervals corresponding to the HCI Synchronous Data packet. The payload data octets corresponding to the missing (e)SCO packets shall be set to 0.",
      value: bc_flag
    }
  end

  defp encode_packet_status_flag!(%{value: encoded_bc_flag})
       when encoded_bc_flag in [0b00, 0b01, 0b10, 0b11] do
    encoded_bc_flag
  end
end
