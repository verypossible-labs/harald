defmodule Harald.HCI.Events.DisconnectionComplete do
  alias Harald.HCI.{ErrorCodes, Events.Event}

  @behaviour Event

  @impl Event
  def encode(%{
        status: decoded_status,
        connection_handle: connection_handle,
        reason: decoded_reason
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, encoded_reason} = ErrorCodes.encode(decoded_reason)

    encoded_disconnection_complete = <<
      encoded_status,
      connection_handle::binary-little-size(2),
      encoded_reason
    >>

    {:ok, encoded_disconnection_complete}
  end

  @impl Event
  def decode(<<
        encoded_status,
        connection_handle::binary-little-size(2),
        encoded_reason
      >>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, decoded_reason} = ErrorCodes.decode(encoded_reason)

    decoded_disconnection_complete = %{
      status: decoded_status,
      connection_handle: connection_handle,
      reason: decoded_reason
    }

    {:ok, decoded_disconnection_complete}
  end

  @impl Event
  def event_code(), do: 0x05
end
