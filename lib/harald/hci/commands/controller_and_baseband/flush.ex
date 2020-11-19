defmodule Harald.HCI.Commands.ControllerAndBaseband.Flush do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.12.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<handle::little-size(12), rfu::4>>) do
    decoded_flush = %{
      connection_handle: %{handle: handle, rfu: rfu}
    }

    {:ok, decoded_flush}
  end

  @impl Command
  def decode_return_parameters(<<encoded_status, handle::little-size(12), rfu::4>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)

    decoded_return_parameters = %{
      status: decoded_status,
      connection_handle: %{
        handle: handle,
        rfu: rfu
      }
    }

    {:ok, decoded_return_parameters}
  end

  @impl Command
  def encode(%{
        connection_handle: %{
          handle: handle,
          rfu: rfu
        }
      }) do
    {:ok, <<handle::little-size(12), rfu::4>>}
  end

  @impl Command
  def encode_return_parameters(%{
        status: decoded_status,
        connection_handle: %{connection_handle: handle, rfu: rfu}
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status, handle::little-size(12), rfu::4>>}
  end

  @impl Command
  def ocf(), do: 0x08
end
