defmodule Harald.Host.ATT.ErrorRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.{WriteReq, ErrorRsp, ErrorCodes}

  test "encode/1" do
    request_module_in_error = WriteReq
    attribute_handle_in_error = 1
    error_message = "Write Not Permitted"

    parameters = %{
      request_module_in_error: request_module_in_error,
      attribute_handle_in_error: attribute_handle_in_error,
      error_message: error_message
    }

    module_opcode = request_module_in_error.opcode()
    {:ok, error_code} = ErrorCodes.encode(error_message)

    expected_bin =
      <<module_opcode::little-size(8), attribute_handle_in_error::little-size(16),
        error_code::little-size(8)>>

    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ErrorRsp.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    request_module_in_error = WriteReq
    attribute_handle_in_error = 1
    error_message = "Write Not Permitted"

    expected_parameters = %{
      request_module_in_error: request_module_in_error,
      attribute_handle_in_error: attribute_handle_in_error,
      error_message: error_message
    }

    module_opcode = request_module_in_error.opcode()
    {:ok, error_code} = ErrorCodes.encode(error_message)

    bin =
      <<module_opcode::little-size(8), attribute_handle_in_error::little-size(16),
        error_code::little-size(8)>>

    assert {:ok, expected_parameters} == ErrorRsp.decode(bin)
  end

  test "opcode/0" do
    assert 0x01 == ErrorRsp.opcode()
  end
end
