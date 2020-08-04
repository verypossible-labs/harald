defmodule Harald.DataType.ManufacturerData.AppleTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.DataType.ManufacturerData.Apple, as: AppleGen
  alias Harald.DataType.ManufacturerData.Apple
  require Harald.Serializable, as: Serializable

  doctest Apple, import: true

  property "symmetric (de)serialization" do
    check all(
            bin <- AppleGen.binary(),
            rand_bin <- StreamData.binary()
          ) do
      Serializable.assert_symmetry(Apple, bin)
      Serializable.assert_symmetry(Apple, rand_bin)
    end
  end
end
