defmodule Harald.Transport.Adapter do
  @moduledoc """
  A behaviour for transport adapters.
  """

  alias Harald.Transport

  @callback setup(parent_pid :: pid, args :: keyword) :: {:ok, Transport.adapter_state()}
  @callback call(binary(), Transport.adapter_state()) ::
              {:ok, Transport.adapter_state()} | {:error, any()}
end
