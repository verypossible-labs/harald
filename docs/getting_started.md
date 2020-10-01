# Getting Started

## Usage

Add the dependency:

```elixir
{:harald, "0.2.0"}
```

Start a transport:

```elixir
{Harald.Transport,
 namespace: :bt,
 adapter: {Harald.Transport.UART, device: "/dev/ttyAMA0", uart_opts: [speed: 115_200]}}
```

The namespace will be used when issuing commands (like scan):

```elixir
Harald.LE.scan(:bt)
```

## Setup with Nerves

### Raspberry Pi 0W, 3B

1. add a custom `fwup.conf` based on the Nerves Rpi3's so you may point to a
   custom `config.txt`
2. add a custom `config.txt` based on the Nerves Rpi3's so you may comment out
   `dtoverlay=pi3-miniuart-bt`

See:

  - [harald_example_rpi3](https://github.com/verypossible/harald_example_rpi3)
  - [harald_example_rpi0](https://github.com/verypossible/harald_example_rpi0)
