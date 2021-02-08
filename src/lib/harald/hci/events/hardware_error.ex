defmodule Harald.HCI.Events.HardwareError do
  alias Harald.HCI.Events.Event

  @behaviour Event

  @impl Event
  def decode(<<hardware_code>>), do: {:ok, %{hardware_code: hardware_code}}

  @impl Event
  def encode(%{hardware_code: hardware_code}), do: {:ok, <<hardware_code>>}

  @impl Event
  def event_code(), do: 0x10
end
