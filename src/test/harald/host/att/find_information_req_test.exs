defmodule Harald.Host.ATT.FindInformationReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.FindInformationReq

  describe "encode/1" do
    test "default" do
      starting_handle = 1
      ending_handle = 10
      parameters = %{starting_handle: starting_handle, ending_handle: ending_handle}
      expected_bin = <<starting_handle::little-size(16), ending_handle::little-size(16)>>
      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = FindInformationReq.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "zero test" do
      starting_handle = 0
      ending_handle = 1
      parameters = %{starting_handle: starting_handle, ending_handle: ending_handle}

      assert {:error, _} = FindInformationReq.encode(parameters)
    end

    test "ending_handle < starting_handle" do
      starting_handle = 10
      ending_handle = 1
      parameters = %{starting_handle: starting_handle, ending_handle: ending_handle}

      assert {:error, _} = FindInformationReq.encode(parameters)
    end
  end

  test "decode/1" do
    starting_handle = 10
    ending_handle = 20
    bin = <<starting_handle::little-size(16), ending_handle::little-size(16)>>
    expected_parameters = %{starting_handle: starting_handle, ending_handle: ending_handle}

    assert {:ok, expected_parameters} == FindInformationReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x04 == FindInformationReq.opcode()
  end
end
