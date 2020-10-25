defmodule Harald.HCI.Commands.LEControllerTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.LEController

  test "ogf/1" do
    assert 0x08 == LEController.ogf()
  end
end
