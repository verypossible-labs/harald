defmodule Harald.HCI.Events.DisconnectionCompleteTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events.DisconnectionComplete

  describe "decode/1" do
    status = 0
    connection_handle = 1
    connection_handle_rfu = 0

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      connection_handle: connection_handle
    }

    reason = 0

    encoded_disconnection_complete = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      reason
    >>

    decoded_disconnection_complete = %{
      status: "Success",
      connection_handle: decoded_connection_handle,
      reason: "Success"
    }

    assert {:ok, decoded_disconnection_complete} ==
             DisconnectionComplete.decode(encoded_disconnection_complete)
  end

  describe "encode/1" do
    status = 0
    connection_handle = 1
    connection_handle_rfu = 0

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      connection_handle: connection_handle
    }

    reason = 0

    expected_encoded_disconnection_complete = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      reason
    >>

    decoded_disconnection_complete = %{
      status: "Success",
      connection_handle: decoded_connection_handle,
      reason: "Success"
    }

    assert {:ok, actual_encoded_disconnection_complete} =
             DisconnectionComplete.encode(decoded_disconnection_complete)

    assert expected_encoded_disconnection_complete ==
             actual_encoded_disconnection_complete
  end

  test "event_code/0" do
    assert 0x05 == DisconnectionComplete.event_code()
  end
end
