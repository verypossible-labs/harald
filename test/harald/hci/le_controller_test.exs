defmodule Harald.HCI.LEControllerTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.HCI.LEController

  doctest LEController, import: true

  test "set_enable_scan/2" do
    check all(
            enable <- StreamData.boolean(),
            filter_duplicates <- StreamData.boolean()
          ) do
      e_num = if enable, do: 1, else: 0
      f_num = if filter_duplicates, do: 1, else: 0

      assert <<12, 32, 2, e_num, f_num>> ==
               LEController.set_enable_scan(enable, filter_duplicates)
    end
  end
end
