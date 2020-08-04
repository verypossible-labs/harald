defmodule Harald.HCI.EventTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event, as: EventGen
  alias Harald.HCI.Event
  require Harald.Serializable, as: Serializable

  doctest Event, import: true

  property "symmetric (de)serialization" do
    check all(
            bin <- EventGen.binary(),
            rand_bin <- StreamData.binary()
          ) do
      Serializable.assert_symmetry(Event, bin)
      Serializable.assert_symmetry(Event, rand_bin)
    end
  end
end
