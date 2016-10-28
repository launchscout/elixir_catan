defmodule CatanMapParser do
  def parse(raw_map) do
    map_lines = map_lines(raw_map)
    %{
      tiles: map_tiles(map_lines)
    }
  end

  defp map_lines(raw_map) do
    raw_map
    |> String.split("\n")
    |> Enum.slice(0..-2)
  end

  defp origin_and_boundaries(map_lines) do
    line_pos = round((length(map_lines) - 1) / 2)
    max_row_length = Enum.reduce(map_lines, 0, fn(row, acc) -> max(String.length(row), acc) end)
    col_pos = round((max_row_length - 1) / 2)
    %AsciiOrigin{x: col_pos, y: line_pos, width: max_row_length, height: length(map_lines)}
  end

  defp map_tiles(map_lines) do
    ascii_origin = origin_and_boundaries(map_lines)

    range = Enum.to_list(-100..100)
    Enum.reduce(range, %{}, fn(q, tiles) ->
      Enum.reduce(range, tiles, fn(r, tiles) ->
        location = %Location{q: q, r: r}
        location
        |> hex_to_ascii(ascii_origin)
        |> HexParser.parse_hex(map_lines)
        |> add_tile(location, tiles)
      end)
    end)
  end

  defp add_tile(nil, _, tiles), do: tiles
  defp add_tile(tile, location, tiles), do: Map.put_new(tiles, location, tile)

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
