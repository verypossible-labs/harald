defmodule Harald.Host.ATT.PrepareWriteRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.6.2
  """

  def encode(%{
        attribute_handle: attribute_handle,
        value_offset: value_offset,
        part_attribute_value: part_attribute_value
      }) do
    {:ok,
     <<attribute_handle::little-size(16), value_offset::little-size(16),
       part_attribute_value::binary>>}
  end

  def encode(decoded_prepare_write_rsp) do
    {:error, {:encode, {__MODULE__, decoded_prepare_write_rsp}}}
  end

  def decode(
        <<attribute_handle::little-size(16), value_offset::little-size(16),
          part_attribute_value::binary>>
      ) do
    parameters = %{
      attribute_handle: attribute_handle,
      value_offset: value_offset,
      part_attribute_value: part_attribute_value
    }

    {:ok, parameters}
  end

  def decode(encoded_prepare_write_rsp) do
    {:error, {:decode, {__MODULE__, encoded_prepare_write_rsp}}}
  end

  def opcode(), do: 0x17
end
