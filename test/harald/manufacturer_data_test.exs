defmodule Harald.ManufacturerDataTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.ManufacturerData, as: ManufacturerDataGen
  alias Harald.ManufacturerData

  doctest ManufacturerData, import: true

  property "symmetric (de)serialization" do
    check all bin <- ManufacturerDataGen.binary() do
      case ManufacturerData.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == ManufacturerData.serialize(data)
        {:error, _} -> :ok
      end
    end

    check all bin <- StreamData.binary() do
      case ManufacturerData.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == ManufacturerData.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
