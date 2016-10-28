defmodule CatanMapParser do
  def parse(raw_map) do
    map_lines = raw_map
    |> String.split("\n")
    |> Enum.slice(0..-2)

    %{
      count: count_tiles(map_lines),
      tiles: map_tiles(map_lines)
    }
  end

  defp count_tiles(map_lines) do
    tiles_high = (length(map_lines) - 1) / 6 #7
    rings_around_center = round((tiles_high - 3) / 2) #3
    _count_tiles(rings_around_center, 0)
  end

  defp _count_tiles(0, acc), do: acc + 1
  defp _count_tiles(rem, acc), do: _count_tiles(rem - 1, acc + (rem * 6))

  defp origin_and_boundaries(map_lines) do
    line_pos = round((length(map_lines) - 1) / 2)
    max_row_length = Enum.reduce(map_lines, 0, fn(row, acc) -> max(String.length(row), acc) end)
    col_pos = round((max_row_length - 1) / 2)
    %AsciiOrigin{x: col_pos, y: line_pos, width: max_row_length, height: length(map_lines)}
  end

  defp map_tiles(map_lines) do
    ascii_origin = origin_and_boundaries(map_lines)
    range = Enum.to_list(-100..100)

    Enum.reduce(range, %{}, fn(q, acc) ->
      Enum.reduce(range, acc, fn(r, acc) ->
        location = %Location{q: q, r: r}
        case map_tile(map_lines, location, ascii_origin) do
          hex = %{} -> Map.put_new(acc, location, hex)
          nil -> acc
        end
      end)
    end)
  end

  def map_tile(map_lines, location = %Location{}, origin = %AsciiOrigin{}) do
    case hex_to_ascii(location, origin) do
      ascii_location = %AsciiLocation{} ->
        HexParser.parse_hex(map_lines, ascii_location)
      nil -> nil
    end
  end

  # Gives the ascii coordinates of the center of the hex at the given point, relative to origin ascii coordinate
  defp hex_to_ascii(%Location{q: q, r: r}, %AsciiOrigin{x: x, y: y, width: width, height: height}) do
    ascii_x = round(9 * q) + x
    ascii_y = round(6 * (r + q / 2)) + y

    cond do
      ascii_x - 6 < 0 -> nil
      ascii_x + 6 >= width -> nil
      ascii_y - 3 < 0 -> nil
      ascii_y + 3 >= height -> nil
      true ->
        %AsciiLocation{x: ascii_x, y: ascii_y}
    end
  end
end
