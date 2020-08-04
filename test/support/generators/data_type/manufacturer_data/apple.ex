defmodule Harald.Generators.DataType.ManufacturerData.Apple do
  @moduledoc """
  StreamData generators for Apple manufacturer data.

  ## iBeacon

  Reference: https://en.wikipedia.org/wiki/IBeacon#Packet_Structure_Byte_Map
  """

  use ExUnitProperties
  alias Harald.DataType.ManufacturerData.Apple

  @spec binary :: no_return()
  def binary do
    gen all(bin <- StreamData.binary(length: 21)) do
      <<
        Apple.ibeacon_identifier(),
        Apple.ibeacon_length(),
        bin::binary
      >>
    end
  end
end
