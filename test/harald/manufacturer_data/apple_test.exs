defmodule Harald.ManufacturerData.AppleTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.ManufacturerData.Apple, as: AppleGen
  alias Harald.ManufacturerData.Apple

  doctest Apple, import: true

  property "symmetric (de)serialization" do
    check all binary <- AppleGen.binary() do
      assert {:ok, binary} ==
               binary
               |> Apple.deserialize()
               |> elem(1)
               |> Apple.serialize()
    end
  end
end
