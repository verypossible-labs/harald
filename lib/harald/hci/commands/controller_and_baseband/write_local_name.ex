defmodule Harald.HCI.Commands.ControllerAndBaseband.WriteLocalName do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.11.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @max_local_name_byte_size 248

  @impl Command
  def encode(%{local_name: local_name}) when byte_size(local_name) <= @max_local_name_byte_size do
    local_name = String.pad_trailing(local_name, @max_local_name_byte_size, <<0>>)
    {:ok, <<local_name::binary-size(@max_local_name_byte_size)>>}
  end

  def encode(%{local_name: local_name}) when byte_size(local_name) > @max_local_name_byte_size do
    {:error, :local_name_too_long}
  end

  def encode(_), do: {:error, :local_name_required}

  @impl Command
  def decode(<<local_name::binary>>) when byte_size(local_name) <= @max_local_name_byte_size do
    {:ok, %{read_local_name: local_name}}
  end

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x13
end
