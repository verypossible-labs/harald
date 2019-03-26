defmodule Harald.HCI.Event.LEMetaTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event.LEMeta, as: LEMetaGen
  alias Harald.HCI.Event.LEMeta

  doctest LEMeta, import: true

  property "symmetric (de)serialization" do
    check all parameters <- LEMetaGen.parameters() do
      case LEMeta.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == LEMeta.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
