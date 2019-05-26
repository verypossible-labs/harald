defmodule Harald.DataType.ServiceDataTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.DataType.ServiceData, as: ServiceDataGen
  alias Harald.DataType.ServiceData

  doctest ServiceData, import: true

  property "symmetric (de)serialization" do
    check all bin <- ServiceDataGen.binary() do
      case ServiceData.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == ServiceData.serialize(data)
        {:error, _} -> :ok
      end
    end

    check all bin <- StreamData.binary() do
      case ServiceData.deserialize(bin) do
        {:ok, data} -> assert {:ok, bin} == ServiceData.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
