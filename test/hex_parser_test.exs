defmodule HexParserTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map_lines = ~S"
        b~~g~~l
       b~~12~~~l
     BB~lumber~~~R
      w3ROBBER~wr
       w3~~o~~wr
         -bbb-
       "
    |> String.split("\n")

    {
      :ok,
      map_lines: map_lines,
      location: %AsciiLocation{x: 11, y: 3}
    }
  end

  describe "HexParser.parse_roads/3" do
    test "finds :se roads", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_roads(location, map_lines).se == :red
    end

    test "finds :s roads", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_roads(location, map_lines).s == :blue
    end

    test "finds :sw roads", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_roads(location, map_lines).sw == :white
    end
  end

  describe "HexParser.parse_harbors/3" do
    test "finds a :nw harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).nw == :brick
    end

    test "finds a :n harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).n == :grain
    end

    test "finds a :ne harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).ne == :lumber
    end

    test "finds a :se harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).se == :wool
    end

    test "finds a :s harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).s == :ore
    end

    test "finds a :sw harbor", %{map_lines: map_lines, location: location} do
      assert HexParser.parse_harbors(location, map_lines).sw == :any
    end
  end
end
