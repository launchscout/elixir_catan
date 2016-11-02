defmodule CatanMapRenderer do
  def render(board) do
    map_lines = empty_map_lines(board)
    y_center = round((length(map_lines) - 1) / 2)
    ascii_origin = %AsciiOrigin{x: 33, y: y_center, width: 70, height: length(map_lines)}

    map_lines = Enum.reduce(board.tiles, map_lines, fn({location, tile}, map_lines) ->
      ascii_location = hex_to_ascii(location, ascii_origin)
      HexRenderer.render_tile(tile, ascii_location, map_lines)
    end)

    map_lines = Enum.reduce(board.vertices, map_lines, fn({location, vertex}, map_lines) ->
      ascii_location = hex_to_ascii(location, ascii_origin)
      map_line = Enum.at(map_lines, ascii_location.y)
      map_line = VertexRenderer.render_vertex(vertex, location.d, ascii_location, map_line)
      List.replace_at(map_lines, ascii_location.y, map_line)
    end)

    IO.puts Enum.join(map_lines, "\n")
    map_lines |> Enum.join("\n")
  end

  defp empty_map_lines(board) do
    origin = %AsciiOrigin{x: 500, y: 500, width: 1000, height: 1000}

    {min, max} = Enum.map(board.tiles, fn({location, _}) ->
      500 - hex_to_ascii(location, origin).y
    end)
    |> Enum.min_max

    map_lines = Enum.to_list((min - 4)..(max + 4))
    |> Enum.map(fn(_) -> "" end)

    IO.inspect map_lines

    map_lines
  end

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
