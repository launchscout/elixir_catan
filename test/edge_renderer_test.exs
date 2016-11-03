defmodule EdgeRendererTest do
  use ExUnit.Case
  doctest EdgeRenderer

  setup do
    map_lines = ~S"
        >-----<
       /~~~~~~~\
      /~~~~~~~~~\
     <~~~~~~~~~~~>
      \~~~~~~~~~/
       \~~~~~~~/
        >-----<
       "
    |> String.split("\n")

    {
      :ok,
      map_lines: map_lines,
      location: %AsciiLocation{x: 11, y: 4}
    }
  end

  describe "EdgeRenderer.render_road/3" do
    test "renders a sw road", %{map_lines: map_lines, location: location} do
      expected_map = ~S"
        >-----<
       /~~~~~~~\
      /~~~~~~~~~\
     <~~~~~~~~~~~>
      r~~~~~~~~~/
       r~~~~~~~/
        >-----<
       "

      edge = %{player: :red}
      assert EdgeRenderer.render_road(map_lines, edge, :sw, location) |> Enum.join("\n") == expected_map
    end

    test "renders a s road", %{map_lines: map_lines, location: location} do
      expected_map = ~S"
        >-----<
       /~~~~~~~\
      /~~~~~~~~~\
     <~~~~~~~~~~~>
      \~~~~~~~~~/
       \~~~~~~~/
        >-bbb-<
       "
      edge = %{player: :blue}
      assert EdgeRenderer.render_road(map_lines, edge, :s, location) |> Enum.join("\n") == expected_map
    end

    test "renders a se road", %{map_lines: map_lines, location: location} do
      expected_map = ~S"
        >-----<
       /~~~~~~~\
      /~~~~~~~~~\
     <~~~~~~~~~~~>
      \~~~~~~~~~o
       \~~~~~~~o
        >-----<
       "

      edge = %{player: :orange}
      assert EdgeRenderer.render_road(map_lines, edge, :se, location) |> Enum.join("\n") == expected_map
    end
  end
end
