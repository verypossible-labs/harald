defmodule Harald.HCI.Event.LEMetaTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event.LEMeta, as: LEMetaGen
  alias Harald.HCI.Event.LEMeta
  require Harald.Serializable, as: Serializable

  doctest LEMeta, import: true

  property "symmetric (de)serialization" do
    check all bin <- LEMetaGen.parameters(),
              rand_bin <- StreamData.binary() do
      Serializable.assert_symmetry(LEMeta, bin)
      Serializable.assert_symmetry(LEMeta, rand_bin)
    end
  end
end
