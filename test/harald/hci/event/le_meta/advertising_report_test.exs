defmodule Harald.HCI.Event.LEMeta.AdvertisingReportTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Event.LEMeta.AdvertisingReport

  doctest AdvertisingReport, import: true

  describe "parse_ad_datum/2" do
    test "Manufacturer data - Apple iBeacon" do
      uuid = 0x11111111111111111111111111111111

      data = <<
        0x4C,
        0x00,
        0x02,
        0x15,
        uuid::size(128),
        0x2222::size(16),
        0x3333::size(16),
        0x44
      >>

      ibeacon = %{
        uuid: AdvertisingReport.int_to_uuid(uuid),
        major: 0x2222,
        minor: 0x3333,
        tx_power: 0x44
      }

      assert AdvertisingReport.parse_ad_datum(0xFF, data) == {:ibeacon, ibeacon}
    end

    test "Service data" do
      uuid = 0x12345678

      data = <<1, 2, 3>>

      raw_service_data_32 = <<
        uuid::little-size(32),
        data::binary
      >>

      service_data_32 = %{
        uuid: uuid,
        data: data
      }

      assert AdvertisingReport.parse_ad_datum(0x20, raw_service_data_32) ==
               {:service_data_32, service_data_32}
    end
  end
end
