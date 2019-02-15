defmodule Harald.Transport.UART.Framing do
  defmodule State do
    @moduledoc false
    defstruct remaining_bytes: nil, in_process: <<>>, hci_packet_type: nil, event_type: 0
  end

  alias Circuits.UART.Framing

  @behaviour Framing

  @impl Framing
  def init(_args), do: {:ok, %State{}}

  @impl Framing
  def add_framing(data, state), do: {:ok, data, state}

  @impl Framing
  def flush(:transmit, state), do: state
  def flush(:receive, _state), do: %State{}
  def flush(:both, _state), do: %State{}

  @impl Framing
  def frame_timeout(state), do: {:ok, [state], <<>>}

  @impl Framing
  def remove_framing(new_data, state), do: process_data(new_data, state)

  defp process_data(data, state, messages \\ [])

  defp process_data(<<>>, state, messages) do
    {process_status(state), Enum.reverse(messages), state}
  end

  # HCI Packet Type 2
  defp process_data(
         <<2, _::size(16), length::size(16)>> <> data,
         %State{hci_packet_type: nil} = state,
         messages
       ) do
    new_state = %{state | hci_packet_type: 2}
    process_data(data, length, new_state, messages)
  end

  # HCI Packet Type 3
  defp process_data(
         <<3, _::size(16), length::size(8)>> <> data,
         %State{hci_packet_type: nil} = state,
         messages
       ) do
    new_state = %{state | hci_packet_type: 3}
    process_data(data, length, new_state, messages)
  end

  # HCI Packet Type 4
  defp process_data(
         <<4, event_type::size(8), ev_length::size(8)>> <> data,
         %State{hci_packet_type: nil} = state,
         messages
       ) do
    new_state = %{state | event_type: event_type, hci_packet_type: 4}
    process_data(data, ev_length, new_state, messages)
  end

  # This clause is hit when already in a packet, however it does not mean the packet type and
  # length have been received yet.
  defp process_data(data, state, messages) do
    process_data(data, state.remaining_bytes, state, messages)
  end

  defp process_data(<<>> = data, nil, state, messages) do
    process_data(data, state, messages)
  end

  defp process_data(data, nil, %State{in_process: <<>>} = state, messages) do
    process_data(<<>>, %{state | in_process: data}, messages)
  end

  defp process_data(data, nil, state, messages) do
    process_data(state.in_process <> data, %{state | in_process: <<>>}, messages)
  end

  defp process_data(data, remaining_bytes, state, messages) do
    case binary_split(data, remaining_bytes) do
      {0, message, remaining_data} ->
        messages =
          case state.hci_packet_type do
            4 -> [{state.event_type, state.in_process <> message} | messages]
            _ -> messages
          end

        process_data(remaining_data, %State{}, messages)

      {remaining_bytes, in_process, <<>> = remaining_data} ->
        process_data(
          remaining_data,
          %{state | remaining_bytes: remaining_bytes, in_process: state.in_process <> in_process},
          messages
        )
    end
  end

  defp process_status(%State{in_process: <<>>, remaining_bytes: nil}), do: :ok
  defp process_status(_state), do: :in_frame

  defp binary_split(bin, desired_length) do
    bin_length = byte_size(bin)

    if bin_length < desired_length do
      {desired_length - bin_length, bin, <<>>}
    else
      {0, binary_part(bin, 0, desired_length),
       binary_part(bin, bin_length, desired_length - bin_length)}
    end
  end
end
