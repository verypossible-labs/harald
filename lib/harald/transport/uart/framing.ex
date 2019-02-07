defmodule Harald.Transport.UART.Framing do
  defmodule State do
    @moduledoc false
    defstruct remaining_bytes: 0, in_process: <<>>, event_type: 0
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

  defp process_data(
         <<4, event_type::size(8), ev_length::size(8)>> <> data,
         %State{in_process: ""} = state,
         messages
       ) do
    process_data(data, ev_length, %{state | event_type: event_type}, messages)
  end

  defp process_data(data, state, messages) do
    process_data(data, state.remaining_bytes, state, messages)
  end

  defp process_data(data, remaining_bytes, %{event_type: event_type} = state, messages) do
    case binary_split(data, remaining_bytes) do
      {0, message, remaining_data} ->
        process_data(remaining_data, %State{}, [
          {event_type, state.in_process <> message} | messages
        ])

      {remaining_bytes, in_process, remaining_data} ->
        process_data(
          remaining_data,
          %{state | remaining_bytes: remaining_bytes, in_process: state.in_process <> in_process},
          messages
        )
    end
  end

  defp process_status(%State{remaining_bytes: 0}), do: :ok
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
