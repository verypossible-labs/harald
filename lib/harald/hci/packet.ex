defmodule Harald.HCI.Packet do
  @moduledoc """
  Functions and definitions relevant to HCI packets.
  """

  @doc """
  Returns a keyword list definition of HCI packet types.

  > There are four kinds of HCI packets that can be sent via the UART Transport Layer; i.e. HCI Command Packet, HCI Event Packet, HCI ACL Data Packet and HCI Synchronous Data Packet
  Reference: Version 5.0, Vol 4, Part A, 2
  """
  def types do
    [
      # command: 0x01,
      # acl_data: 0x02,
      # synchronous_data: 0x03,
      event: 0x04
    ]
  end
end
