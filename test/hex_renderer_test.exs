defmodule HexRendererTest do
  use ExUnit.Case
  doctest HexRenderer

  setup do
    map_lines = ~S"
        ~~~~~~~
       ~~~~~~~~~
     <~~~~~~~~~~~>
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

  describe "HexRenderer.render_tile/3" do
    test "renders a normal tile" do
      location = %AsciiLocation{x: 12, y: 4}
      tile = %{chit: nil, resource: :brick, robber: false, terrain: :hills}

      expected_map = ~S"
         >-----<
        /       \
       /         \
      <   brick   >
       \         /
        \       /
         >-----<"

      map_lines = Enum.to_list(0..7) |> Enum.map(fn(_) -> "" end)
      assert HexRenderer.render_tile(map_lines, tile, location) |> Enum.join("\n") == expected_map
    end

    test "renders a water tile" do
      location = %AsciiLocation{x: 12, y: 4}
      tile = %{chit: nil, resource: nil, robber: false, terrain: :water}

      expected_map = ~S"
         >-----<
        /~~~~~~~\
       /~~~~~~~~~\
      <~~~~~~~~~~~>
       \~~~~~~~~~/
        \~~~~~~~/
         >-----<"

      map_lines = Enum.to_list(0..7) |> Enum.map(fn(_) -> "" end)
      assert HexRenderer.render_tile(map_lines, tile, location) |> Enum.join("\n") == expected_map
    end
  end
end
