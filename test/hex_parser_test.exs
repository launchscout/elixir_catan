defmodule HexParserTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map_lines = ~S"
        b~~g~~l
       b~~12~~~l
     BB~lumber~~RR
      b3ROBBER~wr
       b3~~o~~wr
         -bbb-
       "
    |> String.split("\n")

    {
      :ok,
      map_lines: map_lines,
      location: %AsciiLocation{x: 11, y: 3}
    }
  end

  describe "HexParser.parse_harbors/3" do
    test "finds a :nw harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:nw) == :brick
    end

    test "finds a :n harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:n) == :grain
    end

    test "finds a :ne harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:ne) == :lumber
    end

    test "finds a :se harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:se) == :wool
    end

    test "finds a :s harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:s) == :ore
    end

    test "finds a :sw harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines) |> Map.get(:sw) == :any
    end
  end
end
