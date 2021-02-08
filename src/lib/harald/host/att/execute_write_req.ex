defmodule Harald.Host.ATT.ExecuteWriteReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.6.3
  """

  def encode(%{flags: flags}) do
    binary_flags =
      case flags do
        :cancel_all -> <<0x00>>
        :write_all -> <<0x01>>
      end

    {:ok, binary_flags}
  end

  def encode(decoded_execute_write_req) do
    {:error, {:encode, {__MODULE__, decoded_execute_write_req}}}
  end

  def decode(<<binary_flags>>) do
    flags =
      case binary_flags do
        0x00 -> :cancel_all
        0x01 -> :write_all
      end

    parameters = %{flags: flags}
    {:ok, parameters}
  end

  def decode(encoded_execute_write_req) do
    {:error, {:decode, {__MODULE__, encoded_execute_write_req}}}
  end

  def opcode(), do: 0x18
end
