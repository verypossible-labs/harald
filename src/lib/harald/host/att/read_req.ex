defmodule Harald.Host.ATT.ReadReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.3
  """

  def encode(%{attribute_handle: attribute_handle}) do
    {:ok, <<attribute_handle::little-size(16)>>}
  end

  def encode(decoded_read_req) do
    {:error, {:encode, {__MODULE__, decoded_read_req}}}
  end

  def decode(<<attribute_handle::little-size(16)>>) do
    parameters = %{attribute_handle: attribute_handle}
    {:ok, parameters}
  end

  def decode(encoded_read_req) do
    {:error, {:decode, {__MODULE__, encoded_read_req}}}
  end

  def opcode(), do: 0x0A
end
