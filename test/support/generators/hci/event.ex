defmodule Harald.Generators.HCI.Event do
  @moduledoc """
  StreamData generators for HCI Event Packets.

  Reference: Version 5.0, Vol 2, Part E, 5.4.4
  """

  use ExUnitProperties
  alias Harald.Generators
  alias Harald.HCI.Event

  @doc """
  Returns a partial HCI Event packet binary for a random event, everything besides the HCI packet
  indicator.
  """
  @spec binary :: no_return()
  def binary do
    gen all module <- StreamData.member_of(Event.event_modules()),
            parameters <- Generators.generator_for(module).parameters() do
      <<module.event_code(), byte_size(parameters), parameters::binary>>
    end
  end
end
