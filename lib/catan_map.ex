defmodule CatanMap do
  def parse(raw_map) do
    map_lines = raw_map
    |> String.split("\n")
    |> Enum.slice(0..-2)

    # IO.puts Enum.join(map_lines, "\n")
    %{
      count: count_tiles(map_lines),
      terrain: map_tiles(map_lines)
    }
  end

  def terrain_count(%{count: count}), do: count
  def terrain_count(_), do: nil

  @resource_map %{
    "i" => :brick
  }
  def resource_at(%{terrain: terrain}, q, r), do: @resource_map[terrain[q][r]]
  def resource_at(_, _, _), do: nil

  @terrain_map %{
    "i" => :hills
  }
  def terrain_at(%{terrain: terrain}, q, r), do: @terrain_map[terrain[q][r]]
  def terrain_at(_, _, _), do: nil

  defp count_tiles(map_lines) do
    tiles_high = (length(map_lines) - 1) / 6 #7
    rings_around_center = round((tiles_high - 3) / 2) #3
    _count_tiles(rings_around_center, 0)
  end

  defp _count_tiles(0, acc), do: acc + 1
  defp _count_tiles(rem, acc), do: _count_tiles(rem - 1, acc + (rem * 6))

  def map_tiles(map_lines) do
    line_pos = round((length(map_lines) - 1) / 2)
    origin_row = Enum.at(map_lines, line_pos)
    col_pos = round((String.length(origin_row) - 1) / 2)
    resource = String.at(origin_row, col_pos + 1)
    %{0 => %{0 => resource}}
  end
end
