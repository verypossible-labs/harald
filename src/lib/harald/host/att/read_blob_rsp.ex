defmodule Harald.Host.ATT.ReadBlobRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.6
  """

  def encode(%{part_attribute_value: part_attribute_value}) do
    {:ok, <<part_attribute_value::binary>>}
  end

  def encode(decoded_read_blob_rsp) do
    {:error, {:encode, {__MODULE__, decoded_read_blob_rsp}}}
  end

  def decode(<<part_attribute_value::binary>>) do
    parameters = %{part_attribute_value: part_attribute_value}
    {:ok, parameters}
  end

  def decode(encoded_read_blob_rsp) do
    {:error, {:decode, {__MODULE__, encoded_read_blob_rsp}}}
  end

  def opcode(), do: 0x0D
end
