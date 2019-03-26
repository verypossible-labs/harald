defmodule Harald.LE do
  @moduledoc """
  A collection of high level functions for working with BLE (Bluetooth Low Energy) functionality.
  """

  use GenServer
  alias Harald.HCI.Event.{LEMeta, LEMeta.AdvertisingReport}
  alias Harald.HCI.LEController
  alias Harald.Transport
  alias Harald.Transport.Handler

  @behaviour Handler

  defmodule State do
    @moduledoc false
    defstruct devices: %{}
  end

  def scan(namespace, opts \\ []) do
    opts =
      [
        time: 5_000
      ]
      |> Keyword.merge(opts)

    GenServer.call(name(namespace), {:scan, namespace, opts[:time]}, opts[:time] + 1000)
  end

  def name(namespace), do: String.to_atom("#{namespace}.#{__MODULE__}")

  @impl Handler
  def setup(args) do
    GenServer.start_link(__MODULE__, args, name: name(args[:namespace]))
  end

  @impl GenServer
  def init(_args) do
    {:ok, %State{}}
  end

  @impl GenServer
  def handle_info(
        {:bluetooth_event, %LEMeta{subevent: %AdvertisingReport{devices: devices}}},
        state
      ) do
    state =
      Enum.reduce(devices, state, fn device, state ->
        put_device(device.address, device, state)
      end)

    {:noreply, state}
  end

  # Let other bluetooth events fall through.
  def handle_info({:bluetooth_event, _}, state) do
    {:noreply, state}
  end

  def handle_info({:stop_scan, ns, from}, %State{devices: devices}) do
    :ok = Transport.send_command(ns, LEController.set_enable_scan(false))
    GenServer.reply(from, devices)
    {:noreply, %State{}}
  end

  @impl GenServer
  def handle_call({:scan, ns, timeout}, from, state) do
    :ok = Transport.send_command(ns, LEController.set_enable_scan(true, true))
    Process.send_after(self(), {:stop_scan, ns, from}, timeout)
    {:noreply, state}
  end

  defp put_device(address, device_report, %State{devices: devices} = state) do
    %State{state | devices: Map.put(devices, address, device_report)}
  end
end
