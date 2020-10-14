defmodule Harald.HCI.Transport.Adapter do
  @moduledoc """
  A behaviour for transport adapters.
  """

  alias Harald.Transport

  @type setup_opts() :: [{:transport_pid, pid()}]

  @callback setup(setup_opts()) :: {:ok, Transport.adapter_state()}
  @callback write(binary(), Transport.adapter_state()) ::
              {:ok, Transport.adapter_state()} | {:error, any()}
end
