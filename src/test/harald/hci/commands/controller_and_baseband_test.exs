defmodule Harald.HCI.Commands.ControllerAndBasebandTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.ControllerAndBaseband

  test "ogf/1" do
    assert 0x03 == ControllerAndBaseband.ogf()
  end
end
