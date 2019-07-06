defmodule Harald.DataType.ManufacturerDataTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.DataType.ManufacturerData
  alias Harald.Generators.DataType.ManufacturerData, as: ManufacturerDataGen
  require Harald.Serializable, as: Serializable

  doctest ManufacturerData, import: true

  property "symmetric (de)serialization" do
    check all bin <- ManufacturerDataGen.binary(),
              rand_bin <- StreamData.binary() do
      Serializable.assert_symmetry(ManufacturerData, bin)
      Serializable.assert_symmetry(ManufacturerData, rand_bin)
    end
  end
end
