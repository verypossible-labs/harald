defmodule Harald.Host.ATT.WriteCmd do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.5.3
  """

  def encode(%{attribute_handle: attribute_handle, attribute_value: attribute_value}) do
    {:ok, <<attribute_handle::little-size(16), attribute_value::binary>>}
  end

  def encode(decoded_write_cmd) do
    {:error, {:encode, {__MODULE__, decoded_write_cmd}}}
  end

  def decode(<<attribute_handle::little-size(16), attribute_value::binary>>) do
    parameters = %{attribute_handle: attribute_handle, attribute_value: attribute_value}
    {:ok, parameters}
  end

  def decode(encoded_write_cmd) do
    {:error, {:decode, {__MODULE__, encoded_write_cmd}}}
  end

  def opcode(), do: 0x52
end
