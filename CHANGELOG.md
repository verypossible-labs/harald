# [VERSION]

## Breaking Changes

- `Apple`
  - `deserialize/1` crashes on non-binary terms
- `ArrayedData`
  - `deserialize/1` returns `{:error, bin}` instead of crashing on invalid input
- `Device`
  - `deserialize/1`
    - when attempting to deserialize a non-binary term, crash
    - faults nested within a device discovered during deserialization will no
      longer be realized through tuples like `{:early_termination, 0}`, instead
      the violating binary will be returned as-is
- `ErrorCode`
  - `name/1` returns `{:ok, String.t()} | :error` instead of
    `String.t() | no_return()`
  - `error_code/1` returns `{:ok, non_neg_integer()} | :error` instead of
    `non_neg_integer() | no_return()`
- `Event`
  - `deserialize/1` returns `{:error, bin}` instead of
    `{:error, {:bad_event_code, bin}}`
- `HCI`
  - `deserialize/1` the binary returned in an error tuple like
    `{:error, binary()}` is now always the binary given to the function instead
    of a subbinary
- `InquiryComplete`
  - `serialize/1` may now return `{:error, InquiryComplete.t()}` instead of
    crashing when failing to serialize the event's status
- `ManufacturerData`
  - namespace changed from `Harald` to `Harald.DataType`, modules previously
    namespaced under `Harald.ManufacturerData` are impacted
  - `deserialize/1` returns `{:error, bin}` instead of
    `{:error, {:unhandled_company_id, bin}}`

## Bugfixes

- `Transport`
  - errors during deserialization no longer prevent a Bluetooth event from being
    dispatched to handlers

## Enhancements

- `DataType`
  - add module
- `Serializable`
  - add `assert_symmetry/2`
- `ServiceData`
  - add module
- `Transport`
  - `LE` is always included as a handler WRT `Transport`
