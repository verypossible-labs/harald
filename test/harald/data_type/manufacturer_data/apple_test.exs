defmodule Harald.DataType.ManufacturerData.AppleTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.DataType.ManufacturerData.Apple, as: AppleGen
  alias Harald.DataType.ManufacturerData.Apple

  doctest Apple, import: true

  property "symmetric (de)serialization" do
    check all bin <- AppleGen.binary() do
      case Apple.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == Apple.serialize(data)
        {:error, _} -> :ok
      end
    end

    check all bin <- StreamData.binary() do
      case Apple.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == Apple.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
