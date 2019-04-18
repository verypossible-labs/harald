defmodule Harald.LE do
  @moduledoc """
  A collection of high level functions for working with BLE (Bluetooth Low Energy) functionality.
  """

  use GenServer
  alias Harald.HCI.Event.{LEMeta, LEMeta.AdvertisingReport}
  alias Harald.HCI.{ControllerAndBaseband, LEController}
  alias Harald.{ErrorCode, Transport, Transport.Handler}
  require Logger

  @behaviour Handler

  defmodule State do
    @moduledoc false
    defstruct from: nil, devices: %{}
  end

  @doc """
  HCI_Read_Local_Name

  - `OGF` - `0x03`
  - `OCF` - `0x0014`
  """
  @spec read_local_name(atom()) :: {:ok, String.t()}
  def read_local_name(namespace) do
    GenServer.call(name(namespace), {:read_local_name, namespace})
  end

  def scan(namespace, opts \\ []) do
    opts = Keyword.merge([time: 5_000], opts)
    ret = GenServer.call(name(namespace), {:scan, namespace, opts[:time]}, opts[:time] + 1000)
    {:ok, ret}
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
  def handle_call({:scan, ns, timeout}, from, state) do
    try do
      :ok = Transport.call(ns, LEController.set_enable_scan(true, true))
      Process.send_after(self(), {:stop_scan, ns, from}, timeout)
      {:noreply, state}
    catch
      :exit, {:timeout, _} -> {:reply, {:error, :timeout}, state}
    end
  end

  def handle_call({:read_local_name, ns}, from, state) do
    try do
      :ok = Transport.call(ns, ControllerAndBaseband.read_local_name())
      {:noreply, %{state | from: from}}
    catch
      :exit, {:timeout, _} -> {:reply, {:error, :timeout}, state}
    end
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

  def handle_info(
        {:bluetooth_event,
         {:error, {:unhandled_event_code, <<14, 252, 1, 20, error_code, _::bits>>}}},
        %{from: from} = state
      )
      when not is_nil(from) do
    GenServer.reply(from, {:error, ErrorCode.name(error_code)})
    {:noreply, %{state | from: nil}}
  end

  # Let other bluetooth events fall through.
  def handle_info({:bluetooth_event, _event}, state) do
    {:noreply, state}
  end

  def handle_info({:stop_scan, ns, from}, %State{devices: devices}) do
    :ok = Transport.call(ns, LEController.set_enable_scan(false))
    GenServer.reply(from, devices)
    {:noreply, %State{}}
  end

  # this catchs the reply from the transport if the try/catch above for a :scan was triggered
  # by a timeout
  def handle_info({ref, :ok}, state) when is_reference(ref), do: {:noreply, state}

  defp put_device(address, device_report, %State{devices: devices} = state) do
    %State{state | devices: Map.put(devices, address, device_report)}
  end
end
