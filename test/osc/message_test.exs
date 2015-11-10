defmodule OSC.MessageTest do
  use ExUnit.Case

  test "padding" do
    assert <<"a", 0, 0, 0>> == OSC.Message.padding(<<"a">>)
    assert <<"a", 0, 0, 0>> == OSC.Message.padding(<<"a", 0>>)
    assert <<"a", 0, 0, 0>> == OSC.Message.padding(<<"a", 0, 0>>)
    assert <<"a", 0, 0, 0>> == OSC.Message.padding(<<"a", 0, 0, 0>>)
  end

  test "parse_value" do
    # Integer
    assert { "i", <<0, 0, 0, 1>> } == OSC.Message.parse_value(1)
    assert { "i", <<0, 0, 0x03, 0xe8>> } == OSC.Message.parse_value(1000)

    # Float
    assert { "f", <<0x3f, 0x9d, 0xf3, 0xb6>> } == OSC.Message.parse_value(1.234)
    assert { "f", <<0x40, 0xb5, 0xb2, 0x2d>> } == OSC.Message.parse_value(5.678)

    # String
    assert { "s", <<"a", 0, 0, 0>> } == OSC.Message.parse_value("a")
    assert { "s", <<"a", "b", "c", "d", 0, 0, 0, 0>> } == OSC.Message.parse_value("abcd")
  end

  test "parse_args" do
    assert <<",", "i", "i", 0, 0, 0, 0, 1, 0, 0, 0, 2>> == OSC.Message.parse_args([1, 2])

    assert <<",", "i", "i", "i", 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>> == OSC.Message.parse_args([1, 2, 3])
  end

  test "construct" do
    assert <<"/", "f", "o", "o", 0, 0, 0, 0, ",", "i", "i", 0, 0, 0, 0, 1, 0, 0, 0, 2>>== OSC.Message.construct("/foo", [1, 2])
  end
end
