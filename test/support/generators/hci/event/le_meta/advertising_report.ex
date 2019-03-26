defmodule Harald.Generators.HCI.Event.LEMeta.AdvertisingReport do
  @moduledoc """
  StreamData generators for LE Advertising Report event.

  Reference: Version 5.0, Vol 2, Part E, 7.7.65.2
  """

  use ExUnitProperties
  alias Harald.HCI.Event.LEMeta.AdvertisingReport

  defp calc_max_data_size(num_reports), do: 253 - 10 * num_reports

  @spec parameters :: no_return()
  def parameters do
    array_range = fn range, num_reports ->
      bind(
        list_of(map(integer(range), &<<&1>>), length: num_reports),
        fn list -> constant(Enum.join(list)) end
      )
    end

    gen_data = fn len, max ->
      gen all raw_list <- list_of(integer(0x00..0x1F), length: len),
              list = dampen_list(raw_list, max),
              length_datas = Enum.into(list, <<>>, &<<&1>>),
              datas = Enum.into(list, <<>>, &Enum.at(binary(length: &1), 0)) do
        {length_datas, datas}
      end
    end

    gen all num_reports <- integer(0x01..0x19),
            max_data_size = calc_max_data_size(num_reports),
            {length_datas, datas} <- gen_data.(num_reports, max_data_size),
            event_types <- array_range.(0x00..0x04, num_reports),
            address_types <- array_range.(0x00..0x03, num_reports),
            address_list <- list_of(binary(length: 6), length: num_reports),
            addresses = Enum.join(address_list),
            rss <- array_range.(-127..126, num_reports) do
      <<
        AdvertisingReport.subevent_code(),
        num_reports,
        event_types::binary,
        address_types::binary,
        addresses::binary,
        length_datas::binary,
        datas::binary,
        rss::binary
      >>
    end
  end

  defp dampen_list(list, max) do
    if Enum.sum(list) <= max do
      list
    else
      list
      |> map_decrement()
      |> dampen_list(max)
    end
  end

  defp map_decrement(list) do
    Enum.map(list, fn
      0 -> 0
      x -> x - 1
    end)
  end
end
