# Usage

If the Bluetooth controller is reachable and ready over UART, then Harald is ready to work.

Getting a controller to be reachable and ready over UART is not always straightforward. Oftentimes controllers must have GPIOs toggled in precise sequences to be successfully awoken. Following that, some controllers require custom manufacturer HCI commands to be sent before anything else to initialize correctly.

```bash
# lookup the latest version to add to your Mix file
mix hex.info harald
> An Elixir Bluetooth Host library.
>
> Config: {:harald, "~> 0.3.0"}
> Releases: 0.3.0, 0.2.0, 0.1.1
>
> Licenses: MIT
> Links:
>   GitHub: https://github.com/verypossible-labs/harald
```

## Beaglebone Black Wireless

TODO

## Raspberry Pi 0W, 3B

1. add a custom `fwup.conf` based on the Nerves Rpi3's so you may point to a custom `config.txt`
2. add a custom `config.txt` based on the Nerves Rpi3's so you may comment out `dtoverlay=pi3-miniuart-bt`

See:

  - [harald_example_rpi3](https://github.com/verypossible/harald_example_rpi3)
  - [harald_example_rpi0](https://github.com/verypossible/harald_example_rpi0)

## Read and Write Local Name

```elixir
{:ok, pid} = Harald.start_link(id: :bt, adapter: Harald.Transport.UART)
:ok = Harald.subscribe(:bt)
{:ok, bin_read} = Harald.encode_command(ControllerAndBaseband, ReadLocalName)
:ok = Harald.write(:bt, bin_read)
# wait a second
flush()
# command complete
params_write = %{local_name: "new-name"}
{:ok, bin_write} = Harald.encode_command(ControllerAndBaseband, WriteLocalName, params_write)
:ok = Harald.write(:bt, bin_write)
# wait a second
flush()
# command complete
:ok = Harald.write(:bt, bin_read)
# wait a second
flush()
# command complete
```
