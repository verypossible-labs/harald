defmodule Harald.Host.ATT.ReadByTypeReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.1.
  """

  def encode(%{
        starting_handle: starting_handle,
        ending_handle: ending_handle,
        attribute_type: attribute_type
      }) do
    {:ok,
     <<starting_handle::little-size(16), ending_handle::little-size(16),
       attribute_type::little-size(16)>>}
  end

  def encode(decoded_read_by_type_req) do
    {:error, {:encode, {__MODULE__, decoded_read_by_type_req}}}
  end

  def decode(
        <<starting_handle::little-size(16), ending_handle::little-size(16),
          attribute_type::little-size(16)>>
      ) do
    parameters = %{
      starting_handle: starting_handle,
      ending_handle: ending_handle,
      attribute_type: attribute_type
    }

    {:ok, parameters}
  end

  def decode(encoded_read_by_type_req) do
    {:error, {:decode, {__MODULE__, encoded_read_by_type_req}}}
  end

  def opcode(), do: 0x08
end
