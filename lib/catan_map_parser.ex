defmodule CatanMapParser do
  def parse(raw_map) do
    map_lines = map_lines(raw_map)

    map_tiles(map_lines)
    |> map_edges(map_lines)
    |> map_vertices(map_lines)
  end

  defp map_lines(raw_map) do
    raw_map
    |> String.split("\n")
    |> Enum.slice(0..-2)
  end

  defp origin_and_boundaries(map_lines) do
    %AsciiOrigin{
      x: origin_x(map_lines),
      y: origin_y(map_lines),
      width: ascii_width(map_lines),
      height: ascii_height(map_lines)
    }
  end

  defp origin_x(map_lines), do: round((ascii_width(map_lines) - 1) / 2)
  defp origin_y(map_lines), do: round((ascii_height(map_lines) - 1) / 2)
  defp ascii_width(map_lines), do: Enum.reduce(map_lines, 0, fn(row, acc) -> max(String.length(row), acc) end)
  defp ascii_height(map_lines), do: length(map_lines)

  defp map_tiles(map_lines) do
    ascii_origin = origin_and_boundaries(map_lines)

    range = Enum.to_list(-100..100)
    tiles = Enum.reduce(range, %{}, fn(q, tiles) ->
      Enum.reduce(range, tiles, fn(r, tiles) ->
        location = %Location{q: q, r: r}
        location
        |> hex_to_ascii(ascii_origin)
        |> HexParser.parse_hex(map_lines)
        |> add_tile(location, tiles)
      end)
    end)
    %{tiles: tiles}
  end

  defp add_tile(nil, _, tiles), do: tiles
  defp add_tile(tile, location, tiles), do: Map.put_new(tiles, location, tile)

  defp map_edges(board, map_lines) do
    edges = Enum.reduce(board.tiles, %{}, fn({location, _}, edges) ->
      hex_ascii_center = hex_to_ascii(location, origin_and_boundaries(map_lines))

      edges = hex_ascii_center
      |> EdgeParser.parse_harbors(map_lines)
      |> merge_harbors(location, edges)

      hex_ascii_center
      |> EdgeParser.parse_roads(map_lines)
      |> merge_roads(location, edges)
    end)
    Map.put_new(board, :edges, edges)
  end

  defp merge_harbors(hex_harbors, location, board_edges) do
    Enum.reduce(hex_harbors, board_edges, fn({direction, harbor_resource}, board_edges) ->
      update_edge(board_edges, Hexagon.edge(location, direction), %{harbor_resource: harbor_resource})
    end)
  end

  defp merge_roads(roads, location, board_edges) do
    Enum.reduce(roads, board_edges, fn({direction, player_road}, _board_edges) ->
      update_edge(board_edges, Hexagon.edge(location, direction), %{player: player_road})
    end)
  end

  defp update_edge(board_edges, location, information) do
    new_value = case board_edges[location] do
                  nil -> information
                  value = %{} -> Map.merge(value, information)
                end
    Map.put(board_edges, location, new_value)
  end

  defp map_vertices(board, map_lines) do
    vertices = Enum.reduce(board.tiles, %{}, fn({location, _}, vertices) ->
      hex_to_ascii(location, origin_and_boundaries(map_lines))
      |> VertexParser.parse_vertices(map_lines)
      |> merge_vertices(location, vertices)
    end)
    Map.put_new(board, :vertices, vertices)
  end

  defp merge_vertices(hex_vertices, location, board_vertices) do
    Enum.reduce(hex_vertices, board_vertices, fn({direction, value}, board_vertices) ->
      add_vertex(value, %{location | d: direction}, board_vertices)
    end)
  end

  defp add_vertex(nil, _, board_vertices), do: board_vertices
  defp add_vertex(vertex, location, board_vertices), do: Map.put(board_vertices, location, vertex)

  # Gives the ascii coordinates of the center of the hex at the given point, relative to origin ascii coordinate
  defp hex_to_ascii(location = %Location{}, origin = %AsciiOrigin{}) do
    x = round(9 * location.q) + origin.x
    y = round(6 * (location.r + location.q / 2)) + origin.y

    cond do
      x - 6 < 0 || x + 6 >= origin.width -> nil
      y - 3 < 0 || y + 3 >= origin.height -> nil
      true -> %AsciiLocation{x: x, y: y}
    end
  end
end
