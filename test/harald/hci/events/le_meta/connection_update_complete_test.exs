defmodule Harald.HCI.Events.LEMeta.ConnectionUpdateCompleteTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events.LEMeta.ConnectionUpdateComplete

  test "decode/1" do
    status = 0
    connection_handle = <<1, 2>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80

    bin =
      <<status, connection_handle::binary-little-size(2), connection_interval::little-size(16),
        connection_latency::little-size(16), supervision_timeout::little-size(16)>>

    expected_parameters = %{
      status: status,
      connection_handle: connection_handle,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout
    }

    assert {:ok, expected_parameters} == ConnectionUpdateComplete.decode(bin)
  end

  test "encode/1" do
    status = 0
    connection_handle = <<1, 2>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80

    expected_bin =
      <<status, connection_handle::binary-little-size(2), connection_interval::little-size(16),
        connection_latency::little-size(16), supervision_timeout::little-size(16)>>

    parameters = %{
      status: status,
      connection_handle: connection_handle,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout
    }

    assert {:ok, actual_bin} = ConnectionUpdateComplete.encode(parameters)
    assert expected_bin == actual_bin
  end

  test "sub_event_code/0" do
    assert 0x03 == ConnectionUpdateComplete.sub_event_code()
  end
end
