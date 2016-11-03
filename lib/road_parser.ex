defmodule RoadParser do
  @road_offsets %{
    se: { 5,  1}, s: {0,  3}, sw: {-5,  1}
  }
  def parse_roads(l = %AsciiLocation{}, map_lines) do
    Enum.reduce(@road_offsets, %{}, fn({direction, {delta_x, delta_y}}, edges) ->
      road_location = %AsciiLocation{x: l.x + delta_x, y: l.y + delta_y}
      Enum.at(map_lines, road_location.y)
      |> String.at(road_location.x)
      |> parse_road
      |> add_road(direction, edges)
    end)
  end

  defp parse_road("b"), do: :blue
  defp parse_road("o"), do: :orange
  defp parse_road("r"), do: :red
  defp parse_road("w"), do: :white
  defp parse_road(_), do: nil

  defp add_road(nil, _, edges), do: edges
  defp add_road(player, direction, edges) do
    Map.put_new(edges, direction, player)
  end
end
