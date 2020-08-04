defmodule Harald.HCITest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Harald.Generators.HCI, as: HCIGen
  alias Harald.HCI
  require Harald.Serializable, as: Serializable

  doctest Harald.HCI, import: true

  test "opcode/2" do
    check all(
            ogf <- StreamData.integer(0..63),
            ocf <- StreamData.integer(0..1023)
          ) do
      <<opcode::size(16)-little>> = HCI.opcode(ogf, ocf)
      assert <<^ogf::size(6), ^ocf::size(10)>> = <<opcode::size(16)>>
    end
  end

  test "command/1" do
    check all(opcode <- StreamData.integer(0..65_535)) do
      assert <<^opcode::size(16), 0>> = HCI.command(<<opcode::size(16)>>)
    end
  end

  describe "command/2" do
    test "with binary opts" do
      check all(
              opcode <- StreamData.integer(0..65_535),
              opts <- StreamData.binary(min_length: 1)
            ) do
        s = byte_size(opts)

        assert <<opcode::size(16), s>> <> opts == HCI.command(<<opcode::size(16)>>, opts)
      end
    end

    test "with list opts" do
      check all(
              opcode <- StreamData.integer(0..65_535),
              opts <- StreamData.binary(min_length: 1),
              bool_opt <- StreamData.boolean()
            ) do
        s = byte_size(opts) + 1
        bool_int = if bool_opt, do: 1, else: 0

        assert <<opcode::size(16), s, bool_int>> <> opts ==
                 HCI.command(<<opcode::size(16)>>, [bool_opt, opts])
      end
    end
  end

  test "to_bin/1" do
    check all(bin <- StreamData.binary()) do
      assert bin == HCI.to_bin(bin)
    end
  end

  property "symmetric (de)serialization" do
    check all(
            bin <- HCIGen.packet(),
            rand_bin <- StreamData.binary()
          ) do
      Serializable.assert_symmetry(HCI, bin)
      Serializable.assert_symmetry(HCI, rand_bin)
    end
  end
end
