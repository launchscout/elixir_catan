defmodule HarborParser do
  # Because it's nicer to put the harbor on the water side,
  # harbors can be on either side of the edge.
  # These offsets represent both sides of each edge.
  @harbor_offsets %{se: [{ 4, 1}, { 6, 1}],
                    s:  [{ 0, 2}, { 0, 4}],
                    sw: [{-4, 1}, {-6, 1}]}
  def parse_harbors(l = %AsciiLocation{}, map_lines) do
    Enum.reduce(@harbor_offsets, %{}, fn({direction, offsets}, edges) ->
      parse_and_add_harbor(edges, l, direction, offsets, map_lines)
    end)
  end

  defp parse_and_add_harbor(edges, _, _, [], _), do: edges

  defp parse_and_add_harbor(edges, l = %AsciiLocation{}, direction, [{delta_x, delta_y} | tail], map_lines) do
    harbor_location = %AsciiLocation{x: l.x + delta_x, y: l.y + delta_y}

    map_lines
    |> Enum.at(harbor_location.y, "")
    |> String.at(harbor_location.x)
    |> parse_harbor_resource
    |> add_harbor(direction, edges)
    |> parse_and_add_harbor(l, direction, tail, map_lines)
  end

  defp parse_harbor_resource("3"), do: :any
  defp parse_harbor_resource("b"), do: :brick
  defp parse_harbor_resource("g"), do: :grain
  defp parse_harbor_resource("l"), do: :lumber
  defp parse_harbor_resource("o"), do: :ore
  defp parse_harbor_resource("w"), do: :wool
  defp parse_harbor_resource(_), do: nil

  defp add_harbor(nil, _, edges), do: edges
  defp add_harbor(resource_type, direction, edges) do
    Map.put_new(edges, direction, resource_type)
  end
end
