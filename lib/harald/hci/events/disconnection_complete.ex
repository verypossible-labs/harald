defmodule Harald.HCI.Events.DisconnectionComplete do
  alias Harald.HCI.{ErrorCodes, Events.Event}

  @behaviour Event

  @impl Event
  def decode(<<
        encoded_status,
        connection_handle::little-size(16),
        encoded_reason
      >>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)

    <<t4::size(4), connection_handle_rfu::size(4), b8::size(8)>> = <<connection_handle::size(16)>>
    <<meaningful_connection_handle::size(12)>> = <<t4::size(4), b8::size(8)>>

    {:ok, decoded_reason} = ErrorCodes.decode(encoded_reason)

    decoded_disconnection_complete = %{
      status: decoded_status,
      connection_handle: %{
        rfu: connection_handle_rfu,
        connection_handle: meaningful_connection_handle
      },
      reason: decoded_reason
    }

    {:ok, decoded_disconnection_complete}
  end

  @impl Event
  def encode(%{
        status: decoded_status,
        connection_handle: %{
          rfu: connection_handle_rfu,
          connection_handle: meaningful_connection_handle
        },
        reason: decoded_reason
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    <<t4::size(4), b8::size(8)>> = <<meaningful_connection_handle::size(12)>>

    <<encoded_handle::little-size(16)>> =
      <<t4::size(4), connection_handle_rfu::size(4), b8::size(8)>>

    {:ok, encoded_reason} = ErrorCodes.encode(decoded_reason)

    encoded_disconnection_complete = <<
      encoded_status,
      encoded_handle::size(16),
      encoded_reason
    >>

    {:ok, encoded_disconnection_complete}
  end

  @impl Event
  def event_code(), do: 0x05
end
