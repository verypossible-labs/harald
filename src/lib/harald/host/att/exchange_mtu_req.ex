defmodule Harald.Host.ATT.ExchangeMTUReq do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.2.1
  """

  def encode(%{client_rx_mtu: decoded_client_rx_mtu}) do
    {:ok, <<decoded_client_rx_mtu::little-size(16)>>}
  end

  def encode(decoded_exchange_mtu_req) do
    {:error, {:encode, {__MODULE__, decoded_exchange_mtu_req}}}
  end

  def decode(<<decoded_client_rx_mtu::little-size(16)>>) do
    parameters = %{client_rx_mtu: decoded_client_rx_mtu}
    {:ok, parameters}
  end

  def decode(encoded_exchange_mtu_req) do
    {:error, {:decode, {__MODULE__, encoded_exchange_mtu_req}}}
  end

  def opcode(), do: 0x02
end
