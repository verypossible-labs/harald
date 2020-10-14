defmodule Harald.Transport.UART.FramingTest do
  # use ExUnit.Case, async: true
  # use ExUnitProperties
  # alias Harald.Generators
  # alias Harald.Transport.UART.Framing
  # alias Harald.Transport.UART.Framing.State

  # doctest Harald.Transport.UART.Framing, import: true

  # describe "init/1" do
  #   property "returns a fresh state" do
  #     check all args <- StreamData.term() do
  #       assert {:ok, %State{}} == Framing.init(args)
  #     end
  #   end
  # end

  # describe "add_framing/2" do
  #   property "returns data and state unchanged" do
  #     check all data <- StreamData.binary(),
  #               state <- StreamData.term() do
  #       assert {:ok, data, state} == Framing.add_framing(data, state)
  #     end
  #   end
  # end

  # describe "flush/2" do
  #   property ":transmit returns state unchanged" do
  #     check all state <- StreamData.term() do
  #       assert state == Framing.flush(:transmit, state)
  #     end
  #   end

  #   property ":receive returns a fresh state" do
  #     check all state <- StreamData.term() do
  #       assert %State{} == Framing.flush(:receive, state)
  #     end
  #   end

  #   property ":both returns a fresh state" do
  #     check all state <- StreamData.term() do
  #       assert %State{} == Framing.flush(:both, state)
  #     end
  #   end
  # end

  # describe "frame_timeout/1" do
  #   property "returns the state and an empty binary" do
  #     check all state <- StreamData.term() do
  #       assert {:ok, [state], <<>>} == Framing.frame_timeout(state)
  #     end
  #   end
  # end

  # describe "remove_framing/2" do
  #   property "bad packet types return the remaining data in error" do
  #     check all packet_type <- StreamData.integer(),
  #               packet_type not in 2..4,
  #               rest <- StreamData.bitstring(),
  #               binary = <<packet_type, rest::bits>> do
  #       assert {:ok, [{:error, {:bad_packet_type, binary}}], %State{}} ==
  #                Framing.remove_framing(binary, %State{})
  #     end
  #   end

  #   property "returns when receiving a complete binary of packets" do
  #     check all packets <- StreamData.list_of(Generators.HCI.packet()),
  #               binary = Enum.join(packets) do
  #       assert {:ok, ^packets, %{frame: "", remaining_bytes: nil}} =
  #                Framing.remove_framing(binary, %State{})
  #     end
  #   end

  #   property "returns when receiving a binary of packets that will end in_frame" do
  #     check all [head | tail] <- StreamData.list_of(Generators.HCI.packet(), length: 1),
  #               packets = Enum.join(tail),
  #               head_length = byte_size(head),
  #               partial_length <- StreamData.integer(1..(head_length - 1)),
  #               {0, partial_packet, _} = Framing.binary_split(head, partial_length) do
  #       assert {:in_frame, ^tail, %{frame: ^partial_packet}} =
  #                Framing.remove_framing(packets <> partial_packet, %State{})
  #     end
  #   end
  # end
end
