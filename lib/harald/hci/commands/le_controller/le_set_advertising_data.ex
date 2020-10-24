defmodule Harald.HCI.Commands.LEController.LESetAdvertisingData do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.8.7.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{
        advertising_data_length: advertising_data_length,
        advertising_data: advertising_data
      }) do
    {:ok, <<advertising_data_length, advertising_data::binary-size(advertising_data_length)>>}
  end

  def encode(_), do: {:error, :encode}

  @impl Command
  def decode(<<advertising_data_length, advertising_data::binary-size(advertising_data_length)>>) do
    {:ok, %{advertising_data_length: advertising_data_length, advertising_data: advertising_data}}
  end

  def decode(_), do: {:error, :decode}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x08
end
