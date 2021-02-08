defmodule Harald.HCI.Events.LEMeta.ConnectionUpdateComplete do
  alias Harald.HCI.Events.LEMeta

  @behaviour LEMeta

  @impl LEMeta
  def encode(%{
        status: status,
        connection_handle: connection_handle,
        connection_interval: connection_interval,
        connection_latency: connection_latency,
        supervision_timeout: supervision_timeout
      }) do
    {:ok,
     <<
       status,
       connection_handle::binary-little-size(2),
       connection_interval::little-size(16),
       connection_latency::little-size(16),
       supervision_timeout::little-size(16)
     >>}
  end

  @impl LEMeta
  def decode(<<
        status,
        connection_handle::binary-little-size(2),
        connection_interval::little-size(16),
        connection_latency::little-size(16),
        supervision_timeout::little-size(16)
      >>) do
    parameters = %{
      status: status,
      connection_handle: connection_handle,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout
    }

    {:ok, parameters}
  end

  @impl LEMeta
  def sub_event_code(), do: 0x03
end
