defmodule Harald.Host.ATT.WriteRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.5.2
  """

  def encode(%{}) do
    {:ok, <<>>}
  end

  def encode(decoded_write_rsp) do
    {:error, {:encode, {__MODULE__, decoded_write_rsp}}}
  end

  def decode(<<>>) do
    parameters = %{}
    {:ok, parameters}
  end

  def decode(encoded_write_rsp) do
    {:error, {:decode, {__MODULE__, encoded_write_rsp}}}
  end

  def opcode(), do: 0x13
end
