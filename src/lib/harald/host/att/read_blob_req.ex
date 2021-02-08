defmodule Harald.Host.ATT.ReadBlobReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.5
  """

  def encode(%{attribute_handle: attribute_handle, value_offset: value_offset}) do
    {:ok, <<attribute_handle::little-size(16), value_offset::little-size(16)>>}
  end

  def encode(decoded_read_blob_req) do
    {:error, {:encode, {__MODULE__, decoded_read_blob_req}}}
  end

  def decode(<<attribute_handle::little-size(16), value_offset::little-size(16)>>) do
    parameters = %{attribute_handle: attribute_handle, value_offset: value_offset}
    {:ok, parameters}
  end

  def decode(encoded_read_blob_req) do
    {:error, {:decode, {__MODULE__, encoded_read_blob_req}}}
  end

  def opcode(), do: 0x0C
end
