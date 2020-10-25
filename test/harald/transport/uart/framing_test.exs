defmodule Harald.Transport.UART.FramingTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.HCI.Transport.UART.Framing
  alias Harald.HCI.Transport.UART.Framing.State

  doctest Harald.HCI.Transport.UART.Framing, import: true

  describe "init/1" do
    property "returns a fresh state" do
      check all(args <- StreamData.term()) do
        assert {:ok, %State{}} == Framing.init(args)
      end
    end
  end

  describe "add_framing/2" do
    property "returns data and state unchanged" do
      check all(
              data <- StreamData.binary(),
              state <- StreamData.term()
            ) do
        assert {:ok, data, state} == Framing.add_framing(data, state)
      end
    end
  end

  describe "flush/2" do
    property ":transmit returns state unchanged" do
      check all(state <- StreamData.term()) do
        assert state == Framing.flush(:transmit, state)
      end
    end

    property ":receive returns a fresh state" do
      check all(state <- StreamData.term()) do
        assert %State{} == Framing.flush(:receive, state)
      end
    end

    property ":both returns a fresh state" do
      check all(state <- StreamData.term()) do
        assert %State{} == Framing.flush(:both, state)
      end
    end
  end

  describe "frame_timeout/1" do
    property "returns the state and an empty binary" do
      check all(state <- StreamData.term()) do
        assert {:ok, [state], <<>>} == Framing.frame_timeout(state)
      end
    end
  end

  describe "remove_framing/2" do
    property "bad packet types return the remaining data in error" do
      check all(
              packet_type <- StreamData.integer(),
              packet_type not in 2..4,
              rest <- StreamData.binary(),
              binary = <<packet_type, rest::binary>>
            ) do
        assert {:ok, [{:error, {:bad_packet_type, binary}}], %State{}} ==
                 Framing.remove_framing(binary, %State{})
      end
    end

    property "returns when receiving a complete binary of packets" do
      check all(
              tuples <-
                StreamData.list_of({StreamData.integer(2..4), StreamData.binary()},
                  min_length: 1
                ),
              max_runs: 1
            ) do
        packets =
          Enum.map(tuples, fn
            {2, binary} ->
              length = byte_size(binary)
              <<2, 1, 2, length::little-size(16), binary::binary>>

            {3, binary} ->
              length = byte_size(binary)
              <<3, 1, 2, length::little-size(16), binary::binary>>

            {4, binary} ->
              length = byte_size(binary)
              <<4, 0, length, binary::binary>>
          end)

        bin = Enum.join(packets)

        assert {:ok, ^packets, %{frame: "", remaining_bytes: nil}} =
                 Framing.remove_framing(bin, %State{})
      end
    end

    property "returns when receiving a binary of packets that will end in_frame" do
      check all(binaries <- StreamData.list_of(StreamData.binary(), min_length: 1)) do
        [<<bin_head::binary-size(1), _bin_tail::binary>> | tail] =
          Enum.map(binaries, fn binary ->
            length = byte_size(binary)
            <<4, 0, length, binary::binary>>
          end)

        bin = Enum.join(tail ++ [bin_head])

        assert {:in_frame, ^tail, %{frame: ^bin_head}} = Framing.remove_framing(bin, %State{})
      end
    end
  end
end
