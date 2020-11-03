defmodule Harald.Host.ATT.ErrorRsp do
  alias Harald.Host.ATT
  alias Harald.Host.ATT.ErrorCodes

  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.1.1
  """

  def encode(%{
        request_module_in_error: request_module_in_error,
        attribute_handle_in_error: attribute_handle_in_error,
        error_message: error_message
      }) do
    request_opcode_in_error = request_module_in_error.opcode()
    {:ok, error_code} = ErrorCodes.encode(error_message)

    {:ok,
     <<request_opcode_in_error::little-size(8), attribute_handle_in_error::little-size(16),
       error_code::little-size(8)>>}
  end

  def encode(decoded_error_rsp) do
    {:error, {:encode, {__MODULE__, decoded_error_rsp}}}
  end

  def decode(
        <<request_opcode_in_error::little-size(8), attribute_handle_in_error::little-size(16),
          error_code::little-size(8)>>
      ) do
    {:ok, request_module_in_error} = ATT.opcode_to_module(request_opcode_in_error)
    {:ok, error_message} = ErrorCodes.decode(error_code)

    parameters = %{
      request_module_in_error: request_module_in_error,
      attribute_handle_in_error: attribute_handle_in_error,
      error_message: error_message
    }

    {:ok, parameters}
  end

  def decode(encoded_error_rsp) do
    {:error, {:decode, {__MODULE__, encoded_error_rsp}}}
  end

  def opcode(), do: 0x01
end
