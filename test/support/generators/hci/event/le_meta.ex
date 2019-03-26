defmodule Harald.Generators.HCI.Event.LEMeta do
  @moduledoc """
  StreamData generators for the LEMeta event.

  Reference: Version 5.0, Vol 2, Part E, 7.7.65
  """

  use ExUnitProperties
  alias Harald.{Generators, HCI.Event.LEMeta}

  @spec parameters :: no_return()
  def parameters do
    gen all subevent_module <- StreamData.member_of(LEMeta.subevent_modules()),
            parameters <- Generators.generator_for(subevent_module).parameters() do
      parameters
    end
  end
end
