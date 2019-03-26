defmodule Harald.HCI.Event.LEMeta.AdvertisingReportTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event.LEMeta.AdvertisingReport, as: AdvertisingReportGen
  alias Harald.HCI.Event.LEMeta.AdvertisingReport

  doctest AdvertisingReport, import: true

  property "symmetric (de)serialization" do
    check all parameters <- AdvertisingReportGen.parameters() do
      case AdvertisingReport.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == AdvertisingReport.serialize(data)
        {:error, _} -> :ok
      end
    end

    check all parameters <- StreamData.binary() do
      case AdvertisingReport.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == AdvertisingReport.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
