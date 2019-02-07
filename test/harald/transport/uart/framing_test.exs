defmodule Harald.Transport.UART.FramingTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Transport.UART.Framing
  alias Harald.Transport.UART.Framing.State

  doctest Harald.Transport.UART.Framing, import: true

  test "init/1" do
    check all args <- StreamData.term() do
      assert {:ok, %State{}} == Framing.init(args)
    end
  end

  test "add_framing/2" do
    check all data <- StreamData.binary(),
              state <- StreamData.term() do
      assert {:ok, data, state} == Framing.add_framing(data, state)
    end
  end

  describe "flush/2" do
    test ":transmit" do
      check all state <- StreamData.term() do
        assert state == Framing.flush(:transmit, state)
      end
    end

    test ":receive" do
      check all state <- StreamData.term() do
        assert %State{} == Framing.flush(:receive, state)
      end
    end

    test ":both" do
      check all state <- StreamData.term() do
        assert %State{} == Framing.flush(:both, state)
      end
    end
  end

  test "frame_timeout/1" do
    check all state <- StreamData.term() do
      assert {:ok, [state], <<>>} == Framing.frame_timeout(state)
    end
  end

  describe "remove_framing/2" do
    test "empty data and empty state" do
      assert {:ok, [], %State{}} == Framing.remove_framing(<<>>, %State{})
    end

    test "partial data and empty state" do
      check all partial_event <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        remaining_bytes = 2
        ev_length = byte_size(partial_event)
        data = <<4, event_type, ev_length + remaining_bytes>> <> partial_event

        assert {:in_frame, [],
                %State{
                  remaining_bytes: remaining_bytes,
                  in_process: partial_event,
                  event_type: event_type
                }} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial data and partial state" do
      check all partial_a <- StreamData.binary(min_length: 1),
                partial_b <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        state = %State{
          remaining_bytes: byte_size(partial_b) + 2,
          in_process: partial_a,
          event_type: event_type
        }

        assert {:in_frame, [],
                %State{
                  remaining_bytes: 2,
                  in_process: partial_a <> partial_b,
                  event_type: event_type
                }} == Framing.remove_framing(partial_b, state)
      end
    end

    test "remaining data and partial state" do
      check all partial <- StreamData.binary(min_length: 1),
                remaining <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        state = %State{
          remaining_bytes: byte_size(remaining),
          in_process: partial,
          event_type: event_type
        }

        message = partial <> remaining

        assert {:ok, [{event_type, ^message}], %State{}} =
                 Framing.remove_framing(remaining, state)
      end
    end

    test "full data and empty state" do
      check all message <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        message_length = byte_size(message)
        data = <<4, event_type, message_length>> <> message

        assert {:ok, [{^event_type, ^message}], %State{}} = Framing.remove_framing(data, %State{})
      end
    end

    test "data continuation that starts with a 4" do
      assert {:ok, [{0, <<1, 2, 3, 4, 5>>}], %State{}} =
               Framing.remove_framing(<<4, 5>>, %State{
                 remaining_bytes: 2,
                 in_process: <<1, 2, 3>>,
                 event_type: 0
               })
    end

    test "multiple full frames ending with a partial frame" do
      check all messages <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1),
                partial <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        messages_data =
          for m <- messages, into: "" do
            m_length = byte_size(m)
            <<4, event_type, m_length>> <> m
          end

        expected_messages = for m <- messages, do: {event_type, m}

        partial_length = byte_size(partial) + 2
        data = messages_data <> <<4, event_type, partial_length>> <> partial

        assert {:in_frame, expected_messages,
                %State{remaining_bytes: 2, in_process: partial, event_type: event_type}} ==
                 Framing.remove_framing(data, %State{})
      end
    end
  end
end
