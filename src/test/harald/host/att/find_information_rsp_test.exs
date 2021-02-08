defmodule Harald.Host.ATT.FindInformationRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.FindInformationRsp

  describe "encode/1" do
    test "16 bit uuid single" do
      format = :handle_and_16_bit_uuid
      handle = 1
      uuid = 0x03
      information_data = [%{handle: handle, uuid: uuid}]

      parameters = %{format: format, information_data: information_data}
      expected_bin = <<0x01, handle::little-size(16), uuid::little-size(16)>>
      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = FindInformationRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "128 bit uuid single" do
      format = :handle_and_128_bit_uuid
      handle = 1
      uuid = 10
      information_data = [%{handle: handle, uuid: uuid}]
      parameters = %{format: format, information_data: information_data}
      expected_bin = <<0x02, handle::little-size(16), uuid::little-size(128)>>
      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = FindInformationRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "16 bit uuid multi" do
      format = :handle_and_16_bit_uuid
      handle1 = 1
      uuid1 = 10
      handle2 = 2
      uuid2 = 20
      information_data = [%{handle: handle1, uuid: uuid1}, %{handle: handle2, uuid: uuid2}]
      parameters = %{format: format, information_data: information_data}

      expected_bin =
        <<0x01, handle1::little-size(16), uuid1::little-size(16), handle2::little-size(16),
          uuid2::little-size(16)>>

      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = FindInformationRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "128 bit uuid multi" do
      format = :handle_and_128_bit_uuid
      handle1 = 1
      uuid1 = 10
      handle2 = 2
      uuid2 = 20
      information_data = [%{handle: handle1, uuid: uuid1}, %{handle: handle2, uuid: uuid2}]
      parameters = %{format: format, information_data: information_data}

      expected_bin =
        <<0x02, handle1::little-size(16), uuid1::little-size(128), handle2::little-size(16),
          uuid2::little-size(128)>>

      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = FindInformationRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "incorrect format" do
      format = nil
      parameters = %{format: format, information_data: nil}
      assert {:error, _} = FindInformationRsp.encode(parameters)
    end
  end

  describe "decode/1" do
    test "16 bit uuid single" do
      format = :handle_and_16_bit_uuid
      handle = 1
      uuid = 10
      bin = <<0x01, handle::little-size(16), uuid::little-size(16)>>
      information_data = [%{handle: handle, uuid: uuid}]
      expected_parameters = %{format: format, information_data: information_data}

      assert {:ok, expected_parameters} == FindInformationRsp.decode(bin)
    end

    test "128 bit uuid single" do
      format = :handle_and_128_bit_uuid
      handle = 1
      uuid = 10
      bin = <<0x02, handle::little-size(16), uuid::little-size(128)>>
      information_data = [%{handle: handle, uuid: uuid}]
      expected_parameters = %{format: format, information_data: information_data}

      assert {:ok, expected_parameters} == FindInformationRsp.decode(bin)
    end

    test "16 bit uuid multi" do
      format = :handle_and_16_bit_uuid
      handle1 = 1
      uuid1 = 10
      handle2 = 2
      uuid2 = 2

      bin =
        <<0x01, handle1::little-size(16), uuid1::little-size(16), handle2::little-size(16),
          uuid2::little-size(16)>>

      information_data = [%{handle: handle1, uuid: uuid1}, %{handle: handle2, uuid: uuid2}]
      expected_parameters = %{format: format, information_data: information_data}

      assert {:ok, expected_parameters} == FindInformationRsp.decode(bin)
    end

    test "128 bit uuid multi" do
      format = :handle_and_128_bit_uuid
      handle1 = 1
      uuid1 = 10
      handle2 = 2
      uuid2 = 2

      bin =
        <<0x02, handle1::little-size(16), uuid1::little-size(128), handle2::little-size(16),
          uuid2::little-size(128)>>

      information_data = [%{handle: handle1, uuid: uuid1}, %{handle: handle2, uuid: uuid2}]
      expected_parameters = %{format: format, information_data: information_data}

      assert {:ok, expected_parameters} == FindInformationRsp.decode(bin)
    end

    test "16 bit uuid, incorrect data length" do
      bin = <<0x01, 0x02>>

      assert {:error, _} = FindInformationRsp.decode(bin)
    end

    test "128 bit uuid, incorrect data length" do
      bin = <<0x02, 0x01, 0x00, 0x03, 0x00>>
      assert {:error, _} = FindInformationRsp.decode(bin)
    end

    test "Invalid format" do
      bin = <<0x33, 0x01, 0x00, 0x02, 0x00>>
      assert {:error, _} = FindInformationRsp.decode(bin)
    end
  end

  test "opcode/0" do
    assert 0x05 == FindInformationRsp.opcode()
  end
end
