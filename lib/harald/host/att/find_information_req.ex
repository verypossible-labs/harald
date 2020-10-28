defmodule Harald.Host.ATT.FindInformationReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.3.1
  """

  # Starting handle cannot be 0, it is a reserved number
  def encode(%{starting_handle: starting_handle, ending_handle: _})
      when starting_handle == 0 do
    {:error, :encode}
  end

  def encode(%{starting_handle: starting_handle, ending_handle: ending_handle})
      when starting_handle <= ending_handle do
    bin = <<starting_handle::little-size(16), ending_handle::little-size(16)>>
    {:ok, bin}
  end

  def encode(decoded_find_information_req) do
    {:error, {:encode, {__MODULE__, decoded_find_information_req}}}
  end

  def decode(<<starting_handle::little-size(16), ending_handle::little-size(16)>>) do
    parameters = %{
      starting_handle: starting_handle,
      ending_handle: ending_handle
    }

    {:ok, parameters}
  end

  def decode(encoded_find_information_req) do
    {:error, {:decode, {__MODULE__, encoded_find_information_req}}}
  end

  def opcode(), do: 0x04
end
