defmodule Bluetooth.HCI.EventTest do
  use ExUnit.Case, async: true
  alias Bluetooth.HCI.Event

  doctest Event, import: true

  describe "parse/1" do
    test "Event.Unparsed" do
      # -1 will never be a event code that will one day be parsable.
      assert %Event.Unparsed{event_code: -1, event: <<0>>} == Event.parse({-1, <<0>>})
    end

    test "Event.LEMeta" do
      data =
        {0x3E,
         <<2, 1, 0, 1, 108, 8, 100, 238, 199, 229, 14, 2, 1, 6, 3, 2, 175, 254, 6, 9, 78, 48, 53,
           65, 81, 197>>}

      assert [%Event.LEMeta.AdvertisingReport{}] = Event.parse(data)
    end
  end
end
