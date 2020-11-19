defmodule Harald.HCI.Events.LEMeta.ConnectionComplete do
  alias Harald.HCI.Events.LEMeta

  @behaviour LEMeta

  @impl LEMeta
  def decode(<<
        status,
        connection_handle::little-size(16),
        role,
        peer_address_type,
        peer_address::little-size(48),
        connection_interval::little-size(16),
        connection_latency::little-size(16),
        supervision_timeout::little-size(16),
        master_clock_accuracy
      >>) do
    <<connection_handle_rfu::size(4), connection_handle::size(12)>> =
      <<connection_handle::size(16)>>

    parameters = %{
      status: status,
      connection_handle: %{rfu: connection_handle_rfu, handle: connection_handle},
      role: role,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      connection_latency: connection_latency,
      connection_interval: connection_interval,
      supervision_timeout: supervision_timeout,
      master_clock_accuracy: master_clock_accuracy
    }

    {:ok, parameters}
  end

  @impl LEMeta
  def encode(%{
        status: status,
        connection_handle: %{rfu: connection_handle_rfu, handle: connection_handle},
        role: role,
        peer_address_type: peer_address_type,
        peer_address: peer_address,
        connection_latency: connection_latency,
        connection_interval: connection_interval,
        supervision_timeout: supervision_timeout,
        master_clock_accuracy: master_clock_accuracy
      }) do
    <<connection_handle::little-size(16)>> =
      <<connection_handle_rfu::size(4), connection_handle::size(12)>>

    {:ok,
     <<
       status,
       connection_handle::size(16),
       role,
       peer_address_type,
       peer_address::little-size(48),
       connection_interval::little-size(16),
       connection_latency::little-size(16),
       supervision_timeout::little-size(16),
       master_clock_accuracy
     >>}
  end

  @impl LEMeta
  def sub_event_code(), do: 0x01
end
