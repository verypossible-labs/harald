defmodule Harald.Transport.Adapter do
  @moduledoc """
  A behaviour for transport adapters.
  """

  alias Harald.{HCI, Transport}

  @callback setup(parent_pid :: pid, args :: keyword) :: {:ok, Transport.adapter_state()}
  @callback send_binary(HCI.command(), Transport.adapter_state()) ::
              {:ok, Transport.adapter_state()} | {:error, any()}
end
