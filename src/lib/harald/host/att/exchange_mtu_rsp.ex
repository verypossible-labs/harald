defmodule Harald.Host.ATT.ExchangeMTURsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.2.1
  """

  def encode(%{server_rx_mtu: decoded_server_rx_mtu}) do
    {:ok, <<decoded_server_rx_mtu::little-size(16)>>}
  end

  def encode(decoded_exchange_mtu_rsp) do
    {:error, {:encode, {__MODULE__, decoded_exchange_mtu_rsp}}}
  end

  def decode(<<decoded_server_rx_mtu::little-size(16)>>) do
    parameters = %{server_rx_mtu: decoded_server_rx_mtu}
    {:ok, parameters}
  end

  def decode(encoded_exchange_mtu_rsp) do
    {:error, {:decode, {__MODULE__, encoded_exchange_mtu_rsp}}}
  end

  def opcode(), do: 0x03
end
