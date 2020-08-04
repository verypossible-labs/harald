defmodule Harald.DataType.ServiceDataTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.DataType.ServiceData, as: ServiceDataGen
  alias Harald.DataType.ServiceData
  require Harald.Serializable, as: Serializable

  doctest ServiceData, import: true

  property "symmetric (de)serialization" do
    check all(
            bin <- ServiceDataGen.binary(),
            rand_bin <- StreamData.binary()
          ) do
      Serializable.assert_symmetry(ServiceData, bin)
      Serializable.assert_symmetry(ServiceData, rand_bin)
    end
  end
end
