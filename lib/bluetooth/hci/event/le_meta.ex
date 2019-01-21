defmodule Bluetooth.HCI.Event.LEMeta do
  @moduledoc """
  > The LE Meta Event is used to encapsulate all LE Controller specific events. The Event Code of
  > all LE Meta Events shall be 0x3E. The Subevent_Code is the first octet of the event
  > parameters.  The Subevent_Code shall be set to one of the valid Subevent_Codes from an LE
  > specific event. All other Subevent_Parameters are defined in the LE Controller specific
  > events.
  Bluetooth Spec v5
  """

  @type t :: __MODULE__.AdvertisingReport.t()
  @type parsed :: [t]

  defmodule Unparsed do
    @moduledoc """
    Represents an unparsed LEMeta event.
    """

    defstruct [:subevent_code, :subevent_parameters]
  end

  def parse(<<0x02>> <> params), do: __MODULE__.AdvertisingReport.parse(params)

  def parse(<<subevent_code>> <> params) do
    %Unparsed{subevent_code: subevent_code, subevent_parameters: params}
  end
end
