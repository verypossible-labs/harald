defmodule Harald.Generators.HCI do
  @moduledoc """
  StreamData generators for HCI.
  """

  use ExUnitProperties
  alias Harald.Generators.HCI.Event, as: EventGen
  alias Harald.HCI.Packet

  @spec packet :: no_return()
  def packet do
    gen all {type, indicator} <- StreamData.member_of(Packet.types()),
            binary <- packet(type) do
      <<indicator, binary::binary>>
    end
  end

  @spec packet(:event) :: no_return()
  def packet(:event), do: EventGen.binary()
end
