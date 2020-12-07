defmodule Harald.Host.ATT.ExecuteWriteRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.6.4
  """

  def encode(%{}) do
    {:ok, <<>>}
  end

  def encode(decoded_execute_write_rsp) do
    {:error, {:encode, {__MODULE__, decoded_execute_write_rsp}}}
  end

  def decode(<<>>) do
    parameters = %{}
    {:ok, parameters}
  end

  def decode(encoded_execute_write_rsp) do
    {:error, {:decode, {__MODULE__, encoded_execute_write_rsp}}}
  end

  def opcode(), do: 0x19
end
