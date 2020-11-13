defmodule Harald.HCI.Commands.ControllerAndBaseband.HostNumberOfCompletedPackets do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.40.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<num_handles, arrayed_data::binary>>) do
    {the_map, remaining_bin} =
      Enum.reduce(1..num_handles, {%{}, arrayed_data}, fn
        index, {the_map, <<num_handle::little-size(16), the_rem_bin::binary>>} ->
          {Map.put(the_map, index, num_handle), the_rem_bin}
      end)

    {the_map, <<>>} =
      Enum.reduce(1..num_handles, {the_map, remaining_bin}, fn
        index, {the_map, <<num_completed::little-size(16), the_rem_bin::binary>>} ->
          {Map.update!(the_map, index, fn num_handle -> {num_handle, num_completed} end),
           the_rem_bin}
      end)

    map =
      Enum.into(the_map, %{}, fn {_, {num_handle, num_completed}} ->
        {num_handle, num_completed}
      end)

    {:ok, %{num_handles: num_handles, handles: map}}
  end

  @impl Command
  def decode_return_parameters(<<encoded_status>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, %{status: decoded_status}}
  end

  @impl Command
  def encode(%{num_handles: num_handles, handles: handles}) do
    {connection_handles, host_num_completed_packets} =
      Enum.reduce(handles, {<<>>, <<>>}, fn
        {handle, num_completed}, {acc_handle, acc_num_completed} ->
          acc_handle = <<acc_handle::binary, handle::little-size(16)>>
          acc_num_completed = <<acc_num_completed::binary, num_completed::little-size(16)>>
          {acc_handle, acc_num_completed}
      end)

    {:ok, <<num_handles, connection_handles::binary, host_num_completed_packets::binary>>}
  end

  @impl Command
  def encode_return_parameters(%{status: decoded_status}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status>>}
  end

  @impl Command
  def ocf(), do: 0x35
end
