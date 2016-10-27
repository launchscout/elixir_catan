defmodule CatanMap do
  def parse(raw_map) do
    map_lines = raw_map
    |> String.split("\n")
    |> Enum.slice(0..-2)

    # IO.puts Enum.join(map_lines, "\n")
    %{
      count: count_tiles(map_lines),
      tiles: map_tiles(map_lines)
    }
  end

  def terrain_count(%{count: count}), do: count
  def terrain_count(_), do: nil

  def resource_at(%{tiles: tiles}, q, r), do: tiles[q][r][:resource]
  def resource_at(_, _, _), do: nil

  def terrain_at(%{tiles: tiles}, q, r), do: tiles[q][r][:terrain]
  def terrain_at(_, _, _), do: nil

  defp count_tiles(map_lines) do
    tiles_high = (length(map_lines) - 1) / 6 #7
    rings_around_center = round((tiles_high - 3) / 2) #3
    _count_tiles(rings_around_center, 0)
  end

  defp _count_tiles(0, acc), do: acc + 1
  defp _count_tiles(rem, acc), do: _count_tiles(rem - 1, acc + (rem * 6))

  defp origin_and_boundaries(map_lines) do
    line_pos = round((length(map_lines) - 1) / 2)
    origin_row = Enum.at(map_lines, line_pos)
    col_pos = round((String.length(origin_row) - 1) / 2) + 1
    %{x: col_pos, y: line_pos, width: String.length(origin_row), height: length(map_lines)}
  end

  defp map_tiles(map_lines) do
    origin = origin_and_boundaries(map_lines)
    range = Enum.to_list(-100..100)

    Enum.reduce(range, %{}, fn(q, q_acc) ->
      parsed_q = Enum.reduce(range, %{}, fn(r, r_acc) ->
        case hex_to_ascii(%{q: q, r: r}, origin) do
          position = %{x: _, y: _} ->
            parsed_r = HexParser.parse_hex(map_lines, position)
            Map.put_new(r_acc, r, parsed_r)
          nil -> r_acc
        end
      end)
      cond do
        map_size(parsed_q) > 0 -> Map.put_new(q_acc, q, parsed_q)
        true -> q_acc
      end
    end)
  end

  # Gives the ascii coordinates of the center of the hex at the given point, relative to origin ascii coordinate
  defp hex_to_ascii(%{q: q, r: r}, _origin = %{x: x, y: y, width: width, height: height}) do
    ascii_x = round(9 * q) + x
    ascii_y = round(6 * (r + q / 2)) + y

    cond do
      ascii_x - 6 < 0 -> nil
      ascii_x + 6 >= width -> nil
      ascii_y - 3 < 0 -> nil
      ascii_y + 3 >= height -> nil
      true ->
        %{x: ascii_x, y: ascii_y}
    end
  end
end
