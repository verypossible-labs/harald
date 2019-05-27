# Serialization

## Function Return Values

With respect to Harald's serialization functions: when they return an ok tuple,
the serialization was completely successful. However, if the return is an error
tuple, some portion of the data was unable to be serialized.

### Success

```elixir
> deserialize(bin)
[
  ok: [
    %Harald.HCI.Event.LEMeta.AdvertisingReport.Device{
      address: 88176609989347,
      address_type: 0,
      data: [
        {"Manufacturer Specific Data",
         {"Apple, Inc.", {"iBeacon", %{major: 1, minor: 2, tx_power: 3, uuid: 4}}}}
      ],
      event_type: 0,
      rss: 193
    }
  ]
]

```

### Partial success

Notice the binaries in the value of the `:data` keys, that is because they were
unable to be deserialized.

```elixir
> deserialize(advertising_report_binary)
{:error, [
  %Harald.HCI.Event.LEMeta.AdvertisingReport.Device{
    address: 88176609989347,
    address_type: 0,
    data: [
      <<1, 26>>,
      {"Manufacturer Specific Data", <<76, 0, 16, 5, 1, 20, 108, 251, 123>>}
    ],
    event_type: 0,
    rss: 193
  },
  %Harald.HCI.Event.LEMeta.AdvertisingReport.Device{
    address: 110245537630179,
    address_type: 1,
    data: [
      <<1, 6>>,
      {"Manufacturer Specific Data",
       <<76, 0, 12, 14, 8, 54, 29, 83, 39, 226, 245, 175, 176, 60, 32, 58, 172,
         231>>}
    ],
    event_type: 0,
    rss: 223
  }
]}
```

In this case not even the top-level structure of a device could be successfully
deserialized.

```elixir
> deserialize(advertising_report_binary)
{:error, [<<3, 4, 12, 67, 75, 1>>]}
```
