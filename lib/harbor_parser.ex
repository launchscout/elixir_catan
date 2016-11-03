defmodule HarborParser do
  @harbor_offsets %{
    nw: {-4, -1}, n: {0, -2}, ne: { 4, -1},
    se: { 4,  1}, s: {0,  2}, sw: {-4,  1}
  }
  def parse_harbors(l = %AsciiLocation{}, map_lines) do
    Enum.reduce(@harbor_offsets, %{}, fn({direction, {delta_x, delta_y}}, edges) ->
      harbor_location = %AsciiLocation{x: l.x + delta_x, y: l.y + delta_y}
      Enum.at(map_lines, harbor_location.y)
      |> String.at(harbor_location.x)
      |> parse_harbor
      |> add_harbor(direction, edges)
    end)
  end

  defp parse_harbor("3"), do: :any
  defp parse_harbor("b"), do: :brick
  defp parse_harbor("g"), do: :grain
  defp parse_harbor("l"), do: :lumber
  defp parse_harbor("o"), do: :ore
  defp parse_harbor("w"), do: :wool
  defp parse_harbor(_), do: nil

  defp add_harbor(nil, _, edges), do: edges
  defp add_harbor(resource_type, direction, edges) do
    Map.put_new(edges, direction, resource_type)
  end
end
