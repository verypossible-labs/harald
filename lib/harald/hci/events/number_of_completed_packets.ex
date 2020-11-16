defmodule Harald.HCI.Events.NumberOfCompletedPackets do
  alias Harald.HCI.Events.Event

  @behaviour Event

  @impl Event
  def encode(%{num_handles: num_handles, handles: handles}) do
    {connection_handles, host_num_completed_packets} =
      Enum.reduce(handles, {<<>>, <<>>}, fn
        {handle, num_completed}, {acc_handle, acc_num_completed} ->
          acc_handle = <<acc_handle::binary, handle::little-size(12), 0::4>>
          acc_num_completed = <<acc_num_completed::binary, num_completed::little-size(16)>>
          {acc_handle, acc_num_completed}
      end)

    {:ok, <<num_handles, connection_handles::binary, host_num_completed_packets::binary>>}
  end

  @impl Event
  def decode(<<num_handles, arrayed_data::binary>>) do
    {the_map, remaining_bin} =
      Enum.reduce(1..num_handles, {%{}, arrayed_data}, fn
        index, {the_map, <<connection_handle::little-size(12), rfu::4, the_rem_bin::binary>>} ->
          {Map.put(the_map, index, {connection_handle, rfu}), the_rem_bin}
      end)

    {the_map, <<>>} =
      Enum.reduce(1..num_handles, {the_map, remaining_bin}, fn
        index, {the_map, <<num_completed_packets::little-size(16), the_rem_bin::binary>>} ->
          {Map.update!(the_map, index, fn {connection_handle, connection_handle_rfu} ->
             {connection_handle,
              %{num_completed_packets: num_completed_packets, rfu: connection_handle_rfu}}
           end), the_rem_bin}
      end)

    map =
      Enum.into(the_map, %{}, fn {_, {num_handle, num_completed}} ->
        {num_handle, num_completed}
      end)

    {:ok, %{num_handles: num_handles, handles: map}}
  end

  @impl Event
  def event_code(), do: 0x13
end
