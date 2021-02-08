# Architecture

Elixir module hierarchy.

- Harald: Top level interface.
  - AssignedNumbers
    - CompanyIdentifiers
    - GenericAccessProfile
  - HCI
    - ACLData
    - ArrayedData
    - Commands
    - ErrorCodes
    - Events
    - Packet
    - SynchronousData
  - Host
    - ATT
      - ExchangeMTUReq
      - ExecuteWriteReq
      - ExecuteWriteRsp
      - FindInformationReq
      - FindInformationRsp
      - PrepareWriteReq
      - PrepareWriteRsp
      - ReadBlobReq
      - ReadBlobRsp
      - ReadByGroupTypeReq
      - ReadByGroupTypeRsp
      - ReadByTypeReq
      - ReadByTypeRsp
      - ReadReq
      - ReadRsp
      - WriteCmd
      - WriteReq
      - WriteRsp
    - L2CAP
    - AdvertisingData
      - CompleteListOf128BitServiceClassUUIDs
      - CompleteLocalName
