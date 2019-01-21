defmodule Bluetooth.Transport.Handler do
  @moduledoc """
  A behaviour for transport handlers.
  """

  @callback setup(args :: keyword) :: GenServer.on_start()
end
