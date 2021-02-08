defmodule Harald.Host.ATT.ReadRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.4
  """

  def encode(%{attribute_value: attribute_value}) do
    {:ok, <<attribute_value::binary>>}
  end

  def encode(decoded_read_rsp) do
    {:error, {:encode, {__MODULE__, decoded_read_rsp}}}
  end

  def decode(<<attribute_value::binary>>) do
    parameters = %{attribute_value: attribute_value}
    {:ok, parameters}
  end

  def decode(encoded_read_rsp) do
    {:error, {:decode, {__MODULE__, encoded_read_rsp}}}
  end

  def opcode(), do: 0x0B
end
