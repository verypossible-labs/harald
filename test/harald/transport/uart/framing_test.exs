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

  describe "remove_framing/2 - general" do
    test "empty data and empty state" do
      assert {:ok, [], %State{}} == Framing.remove_framing(<<>>, %State{})
    end
  end

  describe "remove_framing/2 - hci_packet_type 2" do
    test "partial data and empty state" do
      check all partial_data <- StreamData.binary(min_length: 1),
                handle <- StreamData.integer(0..0x0EFF),
                pb_flag <- StreamData.integer(0..3),
                bc_flag <- StreamData.integer(0..3) do
        remaining_bytes = 2
        ev_length = byte_size(partial_data) + remaining_bytes

        data =
          <<
            2,
            handle::size(12),
            pb_flag::size(2),
            bc_flag::size(2),
            ev_length::size(16)
          >> <> partial_data

        assert {:in_frame, [],
                %State{
                  event_type: 0,
                  hci_packet_type: 2,
                  in_process: partial_data,
                  remaining_bytes: remaining_bytes
                }} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial data and partial state" do
      check all partial_a <- StreamData.binary(min_length: 1) do
        state = %State{
          event_type: 0,
          hci_packet_type: 2,
          in_process: "",
          remaining_bytes: byte_size(partial_a) + 2
        }

        assert {:in_frame, [],
                %State{
                  event_type: 0,
                  hci_packet_type: 2,
                  in_process: partial_a,
                  remaining_bytes: 2
                }} == Framing.remove_framing(partial_a, state)
      end
    end

    test "remaining data and partial state" do
      check all partial <- StreamData.binary(min_length: 1),
                remaining <- StreamData.binary(min_length: 1) do
        state = %State{
          event_type: 0,
          hci_packet_type: 2,
          in_process: partial,
          remaining_bytes: byte_size(remaining)
        }

        assert {:ok, [], %State{}} = Framing.remove_framing(remaining, state)
      end
    end

    test "full data and empty state" do
      check all payload <- StreamData.binary(min_length: 1),
                handle <- StreamData.integer(0..0x0EFF),
                pb_flag <- StreamData.integer(0..3),
                bc_flag <- StreamData.integer(0..3) do
        payload_length = byte_size(payload)

        data = <<
          2,
          handle::size(12),
          pb_flag::size(2),
          bc_flag::size(2),
          payload_length::size(16),
          payload::binary
        >>

        assert {:ok, [], %State{}} = Framing.remove_framing(data, %State{})
      end
    end

    test "data continuation that starts with a 2" do
      assert {:ok, [], %State{}} =
               Framing.remove_framing(<<2, 5>>, %State{
                 event_type: 0,
                 hci_packet_type: 2,
                 in_process: "",
                 remaining_bytes: 2
               })
    end

    test "multiple full frames ending with a partial frame" do
      check all payloads <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1),
                partial <- StreamData.binary(min_length: 1),
                handle <- StreamData.integer(0..0x0EFF),
                pb_flag <- StreamData.integer(0..3),
                bc_flag <- StreamData.integer(0..3) do
        full_frames =
          for p <- payloads, into: "" do
            p_length = byte_size(p)

            <<
              2,
              handle::size(12),
              pb_flag::size(2),
              bc_flag::size(2),
              p_length::size(16),
              p::binary
            >>
          end

        partial_length = byte_size(partial) + 2

        data =
          full_frames <>
            <<
              2,
              handle::size(12),
              pb_flag::size(2),
              bc_flag::size(2),
              partial_length::size(16),
              partial::binary
            >>

        expected_state = %State{
          event_type: 0,
          hci_packet_type: 2,
          in_process: partial,
          remaining_bytes: 2
        }

        assert {:in_frame, [], expected_state} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial that does not include length initially" do
      check all messages <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1) do
        messages_data =
          for m <- messages, into: "" do
            m_length = byte_size(m)
            <<2, 0::size(16), m_length::size(16)>> <> m
          end

        data0 = messages_data <> <<2>>

        state0 = %State{
          event_type: 0,
          hci_packet_type: nil,
          in_process: <<2>>,
          remaining_bytes: nil
        }

        assert {:in_frame, [], state0} == Framing.remove_framing(data0, %State{})

        data1 = <<0::size(16)>>
        state1 = %{state0 | in_process: state0.in_process <> data1}

        assert {:in_frame, [], state1} == Framing.remove_framing(data1, state0)

        ev_length = 10
        data2 = <<ev_length::size(16)>>

        state2 = %{
          state1
          | event_type: 0,
            hci_packet_type: 2,
            in_process: <<>>,
            remaining_bytes: ev_length
        }

        assert {:in_frame, [], state2} == Framing.remove_framing(data2, state1)
      end
    end
  end

  describe "remove_framing/2 - hci_packet_type 3" do
    test "partial data and empty state" do
      check all partial_data <- StreamData.binary(min_length: 1),
                connection_handle <- StreamData.integer(0..0x0EFF),
                packet_status_flag <- StreamData.integer(0..3),
                rfu <- StreamData.integer(0..3) do
        remaining_bytes = 2
        ev_length = byte_size(partial_data)

        data =
          <<
            3,
            connection_handle::size(12),
            packet_status_flag::size(2),
            rfu::size(2),
            ev_length + remaining_bytes
          >> <> partial_data

        assert {:in_frame, [],
                %State{
                  event_type: 0,
                  hci_packet_type: 3,
                  in_process: partial_data,
                  remaining_bytes: remaining_bytes
                }} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial data and partial state" do
      check all partial_a <- StreamData.binary(min_length: 1) do
        state = %State{
          event_type: 0,
          hci_packet_type: 3,
          in_process: "",
          remaining_bytes: byte_size(partial_a) + 2
        }

        assert {:in_frame, [],
                %State{
                  event_type: 0,
                  hci_packet_type: 3,
                  in_process: partial_a,
                  remaining_bytes: 2
                }} == Framing.remove_framing(partial_a, state)
      end
    end

    test "remaining data and partial state" do
      check all partial <- StreamData.binary(min_length: 1),
                remaining <- StreamData.binary(min_length: 1) do
        state = %State{
          event_type: 0,
          hci_packet_type: 3,
          in_process: partial,
          remaining_bytes: byte_size(remaining)
        }

        assert {:ok, [], %State{}} = Framing.remove_framing(remaining, state)
      end
    end

    test "full data and empty state" do
      check all payload <- StreamData.binary(min_length: 1),
                connection_handle <- StreamData.integer(0..0x0EFF),
                packet_status_flag <- StreamData.integer(0..3),
                rfu <- StreamData.integer(0..3) do
        payload_length = byte_size(payload)

        data = <<
          3,
          connection_handle::size(12),
          packet_status_flag::size(2),
          rfu::size(2),
          payload_length::size(8),
          payload::binary
        >>

        assert {:ok, [], %State{}} = Framing.remove_framing(data, %State{})
      end
    end

    test "data continuation that starts with a 3" do
      assert {:ok, [], %State{}} =
               Framing.remove_framing(<<3, 5>>, %State{
                 event_type: 0,
                 hci_packet_type: 3,
                 in_process: "",
                 remaining_bytes: 2
               })
    end

    test "multiple full frames ending with a partial frame" do
      check all payloads <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1),
                partial <- StreamData.binary(min_length: 1),
                connection_handle <- StreamData.integer(0..0x0EFF),
                packet_status_flag <- StreamData.integer(0..3),
                rfu <- StreamData.integer(0..3) do
        full_frames =
          for p <- payloads, into: "" do
            p_length = byte_size(p)

            <<
              3,
              connection_handle::size(12),
              packet_status_flag::size(2),
              rfu::size(2),
              p_length::size(8),
              p::binary
            >>
          end

        partial_length = byte_size(partial) + 2

        data =
          full_frames <>
            <<
              3,
              connection_handle::size(12),
              packet_status_flag::size(2),
              rfu::size(2),
              partial_length::size(8),
              partial::binary
            >>

        expected_state = %State{
          event_type: 0,
          hci_packet_type: 3,
          in_process: partial,
          remaining_bytes: 2
        }

        assert {:in_frame, [], expected_state} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial that does not include length initially" do
      check all messages <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1) do
        messages_data =
          for m <- messages, into: "" do
            m_length = byte_size(m)
            <<3, 0::size(16), m_length>> <> m
          end

        data0 = messages_data <> <<3>>

        state0 = %State{
          event_type: 0,
          hci_packet_type: nil,
          in_process: <<3>>,
          remaining_bytes: nil
        }

        ret = Framing.remove_framing(data0, %State{})
        assert {:in_frame, [], state0} == ret

        data1 = <<0::size(16)>>
        state1 = %{state0 | in_process: state0.in_process <> data1}

        assert {:in_frame, [], state1} == Framing.remove_framing(data1, state0)

        ev_length = 10
        data2 = <<ev_length>>

        state2 = %{
          state1
          | event_type: 0,
            hci_packet_type: 3,
            in_process: <<>>,
            remaining_bytes: ev_length
        }

        assert {:in_frame, [], state2} == Framing.remove_framing(data2, state1)
      end
    end
  end

  describe "remove_framing/2 - hci_packet_type 4" do
    test "partial data and empty state" do
      check all partial_event <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        remaining_bytes = 2
        ev_length = byte_size(partial_event)
        data = <<4, event_type, ev_length + remaining_bytes>> <> partial_event

        assert {:in_frame, [],
                %State{
                  event_type: event_type,
                  hci_packet_type: 4,
                  in_process: partial_event,
                  remaining_bytes: remaining_bytes
                }} == Framing.remove_framing(data, %State{})
      end
    end

    test "partial data and partial state" do
      check all partial_a <- StreamData.binary(min_length: 1),
                partial_b <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        state = %State{
          event_type: event_type,
          hci_packet_type: 4,
          in_process: partial_a,
          remaining_bytes: byte_size(partial_b) + 2
        }

        assert {:in_frame, [],
                %State{
                  event_type: event_type,
                  hci_packet_type: 4,
                  in_process: partial_a <> partial_b,
                  remaining_bytes: 2
                }} == Framing.remove_framing(partial_b, state)
      end
    end

    test "remaining data and partial state" do
      check all partial <- StreamData.binary(min_length: 1),
                remaining <- StreamData.binary(min_length: 1),
                event_type <- StreamData.integer(0..255) do
        state = %State{
          event_type: event_type,
          hci_packet_type: 4,
          in_process: partial,
          remaining_bytes: byte_size(remaining)
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
                 event_type: 0,
                 hci_packet_type: 4,
                 in_process: <<1, 2, 3>>,
                 remaining_bytes: 2
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

        expected_state = %State{
          event_type: event_type,
          hci_packet_type: 4,
          in_process: partial,
          remaining_bytes: 2
        }

        assert {:in_frame, expected_messages, expected_state} ==
                 Framing.remove_framing(data, %State{})
      end
    end

    test "partial that does not include length initially" do
      check all messages <- StreamData.list_of(StreamData.binary(min_length: 1), min_length: 1),
                event_type <- StreamData.integer(0..255) do
        messages_data =
          for m <- messages, into: "" do
            m_length = byte_size(m)
            <<4, event_type, m_length>> <> m
          end

        expected_messages = for m <- messages, do: {event_type, m}

        data0 = messages_data <> <<4>>

        state0 = %State{
          event_type: 0,
          hci_packet_type: nil,
          in_process: <<4>>,
          remaining_bytes: nil
        }

        assert {:in_frame, expected_messages, state0} == Framing.remove_framing(data0, %State{})

        data1 = <<0x3E>>
        state1 = %{state0 | in_process: state0.in_process <> data1}

        assert {:in_frame, [], state1} == Framing.remove_framing(data1, state0)

        ev_length = 10
        data2 = <<ev_length>>

        state2 = %{
          state1
          | event_type: 0x3E,
            hci_packet_type: 4,
            in_process: <<>>,
            remaining_bytes: ev_length
        }

        assert {:in_frame, [], state2} == Framing.remove_framing(data2, state1)
      end
    end
  end
end
