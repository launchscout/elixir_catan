defmodule VertexParserTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map_lines = ~S"
        ~~~~~~~
       ~~~~~~~~~
     BB~~~~~~~~~~R
      \~~~~~~~~~/
       \~~~~~~~/
         -----
       "
    |> String.split("\n")

    {
      :ok,
      map_lines: map_lines,
      location: %AsciiLocation{x: 11, y: 3}
    }
  end

  describe "VertexParser.parse_vertices" do
    test "finds cities", %{map_lines: map_lines, location: location} do
      assert VertexParser.parse_vertices(location, map_lines).left == %{type: :city, player: :blue}
    end

    test "finds settlements", %{map_lines: map_lines, location: location} do
      assert VertexParser.parse_vertices(location, map_lines).right == %{type: :settlement, player: :red}
    end
  end
end
