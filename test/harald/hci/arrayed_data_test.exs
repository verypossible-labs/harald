defmodule Harald.HCI.ArrayedDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{ArrayedData, Event.LEMeta.AdvertisingReport.Device}

  doctest ArrayedData, import: true

  describe "deserialize/4" do
    test "an empty binary results in an error" do
      assert {:error, :incomplete} == ArrayedData.deserialize([], 1, Device, <<>>)
    end
  end
end
