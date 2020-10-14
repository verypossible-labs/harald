# Getting Started

## Hardware

If the Bluetooth controller is reachable and ready over UART, then Harald is ready to work.

Getting a controller to be reachable and ready over UART is not always straightforward.
Oftentimes controllers must have GPIOs toggled in precise sequences to be successfully awoken.
Following that, some controllers require custom manufacturer HCI commands to be sent before
anything else to initialize correctly.

## Software

Add the dependency:

```elixir
{:harald, "VERSION"}
```

List versions with `mix hex.info harald`.

See [Examples](examples.md).
