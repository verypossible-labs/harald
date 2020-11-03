defmodule Harald.Host.ATT.ErrorCodesTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ErrorCodes

  test "encode/1" do
    name = "Write Not Permitted"
    expected_code = 0x03
    assert {:ok, expected_code} == ErrorCodes.encode(name)
  end

  test "decode/1" do
    expected_name = "Write Not Permitted"
    code = 0x03
    assert {:ok, expected_name} == ErrorCodes.decode(code)
  end
end
