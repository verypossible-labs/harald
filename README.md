# Harald

[![Hex version badge](https://img.shields.io/hexpm/v/harald.svg)](https://hex.pm/packages/harald)
[![CircleCI](https://circleci.com/gh/verypossible-labs/harald.svg?style=svg)](https://circleci.com/gh/verypossible-labs/harald)
[![Coverage Status](https://coveralls.io/repos/github/verypossible/harald/badge.svg)](https://coveralls.io/github/verypossible/harald)

This project is part of
[Very Labs](https://github.com/verypossible-labs/docs/blob/master/README.md). Maintenance of this
project is subject to contributor availability.

---

Harald is a Bluetooth HCI host that supports the UART transport.

- [Getting Started](docs/getting-started.md) - Quick start.
- [Docs](docs) - Harald documentation.

## Features

- Decode/encode binary HCI packets/Elixir maps.
- Send HCI packets over UART.
- Receive HCI packets over UART and fan them out to all subscribed pids.

## Example

The following is sampled from [Examples](docs/examples.md).

### Read and Write Local Name

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
