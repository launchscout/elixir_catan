defmodule RoadParserTest do
  use ExUnit.Case
  doctest RoadParser

  setup do
    map_lines = ~S"
        >-----<
       /~~~~~~~\
      /~~~~~~~~~\
     <~~~~~~~~~~~>
      w~~~~~~~~~r
       w~~~~~~~r
        >-bbb-<
       "
    |> String.split("\n")

    {
      :ok,
      map_lines: map_lines,
      location: %AsciiLocation{x: 11, y: 4}
    }
  end

  describe "RoadParser.parse_roads/3" do
    test "finds :se roads", %{map_lines: map_lines, location: location} do
      assert RoadParser.parse_roads(location, map_lines).se == :red
    end

    test "finds :s roads", %{map_lines: map_lines, location: location} do
      assert RoadParser.parse_roads(location, map_lines).s == :blue
    end

    test "finds :sw roads", %{map_lines: map_lines, location: location} do
      assert RoadParser.parse_roads(location, map_lines).sw == :white
    end
  end
end
