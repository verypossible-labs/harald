defmodule Harald.HCI.Event.InquiryCompleteTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event.InquiryComplete, as: InquiryCompleteGen
  alias Harald.HCI.Event.InquiryComplete

  doctest InquiryComplete, import: true

  property "symmetric serialization" do
    check all parameters <- InquiryCompleteGen.parameters() do
      case InquiryComplete.deserialize(parameters) do
        {:ok, data} ->
          assert {:ok, bin} = InquiryComplete.serialize(data)
          assert :binary.bin_to_list(parameters) == :binary.bin_to_list(bin)

        {:error, _} ->
          :ok
      end
    end

    check all parameters <- StreamData.binary() do
      case InquiryComplete.deserialize(parameters) do
        {:ok, data} -> assert {:ok, parameters} == InquiryComplete.serialize(data)
        {:error, _} -> :ok
      end
    end
  end
end
