defmodule Harald.HCI.Events.DisconnectionCompleteTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events.DisconnectionComplete

  describe "decode/1" do
    status = 0
    connection_handle = <<1, 2>>
    reason = 0

    encoded_disconnection_complete = <<
      status,
      connection_handle::binary-little-size(2),
      reason
    >>

    decoded_disconnection_complete = %{
      status: "Success",
      connection_handle: connection_handle,
      reason: "Success"
    }

    assert {:ok, decoded_disconnection_complete} ==
             DisconnectionComplete.decode(encoded_disconnection_complete)
  end

  describe "encode/1" do
    status = 0
    connection_handle = <<1, 2>>
    reason = 0

    encoded_disconnection_complete = <<
      status,
      connection_handle::binary-little-size(2),
      reason
    >>

    decoded_disconnection_complete = %{
      status: "Success",
      connection_handle: connection_handle,
      reason: "Success"
    }

    assert {:ok, encoded_disconnection_complete} ==
             DisconnectionComplete.encode(decoded_disconnection_complete)
  end
end
