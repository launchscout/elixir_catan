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
