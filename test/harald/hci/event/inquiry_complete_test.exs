defmodule Harald.HCI.Event.InquiryCompleteTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI.Event.InquiryComplete, as: InquiryCompleteGen
  alias Harald.HCI.Event.InquiryComplete
  require Harald.Serializable, as: Serializable

  doctest InquiryComplete, import: true

  property "symmetric (de)serialization" do
    check all bin <- InquiryCompleteGen.parameters(),
              rand_bin <- StreamData.binary() do
      Serializable.assert_symmetry(InquiryComplete, bin)
      Serializable.assert_symmetry(InquiryComplete, rand_bin)
    end
  end
end
