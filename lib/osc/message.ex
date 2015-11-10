defmodule OSC.Message do
  def construct(path, args) do
    padding(path <> <<0>>) <> parse_args(args)
  end

  def parse_args(args) when is_list(args) do
    { tags, values } = args
    |> Enum.map(fn (x) -> parse_value(x) end)
    |> Enum.unzip

    t = [",", tags, <<0>>] |> List.flatten |> Enum.join |> padding
    v = values |> Enum.join
    t <> v
  end

  def parse_args(args), do: parse_value(args)

  def parse_value(value) when is_integer(value) do
    { "i", <<value :: big-signed-integer-size(32)>> }
  end

  def parse_value(value) when is_float(value) do
    { "f", <<value :: big-signed-float-size(32)>> }
  end

  def parse_value(value) when is_binary(value) do
    { "s", padding(value <> <<0>>) }
  end

  def padding(buf) when rem(byte_size(buf), 4) == 0, do: buf
  def padding(buf), do: buf <> <<0>> |> padding
end
