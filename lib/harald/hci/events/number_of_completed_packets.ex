defmodule Harald.HCI.Events.NumberOfCompletedPackets do
  alias Harald.HCI.Events.Event

  @behaviour Event

  @impl Event
  def encode(%{num_handles: num_handles, handles: handles}) do
    {connection_handles, num_completed_packets} =
      Enum.reduce(handles, {<<>>, <<>>}, fn
        {handle, handle_data}, {acc_handle, acc_num_completed} ->
          <<handle::size(16)>> = <<handle_data.rfu::size(4), handle::size(12)>>
          acc_handle = <<acc_handle::binary, handle::little-size(16)>>

          acc_num_completed =
            <<acc_num_completed::binary, handle_data.num_completed_packets::little-size(16)>>

          {acc_handle, acc_num_completed}
      end)

    {:ok, <<num_handles, connection_handles::binary, num_completed_packets::binary>>}
  end

  @impl Event
  def decode(<<num_handles, arrayed_data::binary>>) do
    {handles, remaining_bin} =
      Enum.reduce(1..num_handles, {%{}, arrayed_data}, fn
        index, {handles, <<connection_handle::little-size(16), the_rem_bin::binary>>} ->
          <<connection_handle_rfu::size(4), connection_handle::size(12)>> =
            <<connection_handle::size(16)>>

          {Map.put(handles, index, {connection_handle, connection_handle_rfu}), the_rem_bin}
      end)

    {handles, <<>>} =
      Enum.reduce(1..num_handles, {handles, remaining_bin}, fn
        index, {handles, <<num_completed_packets::little-size(16), the_rem_bin::binary>>} ->
          {Map.update!(handles, index, fn {connection_handle, connection_handle_rfu} ->
             {connection_handle,
              %{num_completed_packets: num_completed_packets, rfu: connection_handle_rfu}}
           end), the_rem_bin}
      end)

    handles =
      Enum.into(handles, %{}, fn {_, {num_handle, num_completed}} ->
        {num_handle, num_completed}
      end)

    {:ok, %{num_handles: num_handles, handles: handles}}
  end

  @impl Event
  def event_code(), do: 0x13
end
