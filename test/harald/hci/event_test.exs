defmodule Harald.HCI.EventTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event, as: EventGen
  alias Harald.HCI.Event

  doctest Event, import: true

  property "symmetric (de)serialization" do
    check all parameters <- EventGen.binary() do
      case Event.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == Event.serialize(data)
        {:error, _} -> :ok
      end
    end

    check all parameters <- StreamData.binary() do
      case Event.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == Event.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
