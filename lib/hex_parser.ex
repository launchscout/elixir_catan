defmodule HexParser do
  @resource_map %{
    "a" => :grain,  "b" => :lumber,  "e" => nil,
    "i" => :brick,  "o" => :wool,    "r" => :ore
  }

  @terrain_map %{
    "a" => :fields, "b" => :forest,  "e" => :desert,
    "i" => :hills,  "o" => :pasture, "r" => :mountains
  }

  def parse_hex(nil, _), do: nil
  def parse_hex(location = %AsciiLocation{}, map_lines) do
    water = String.at(Enum.at(map_lines, location.y + 1), location.x)
    resource = String.at(Enum.at(map_lines, location.y), location.x)
    cond do
      water == "~" ->
        %{
          resource: nil,
          terrain: :water,
          chit: nil,
          robber: false
        }
      true ->
        %{
          resource: @resource_map[resource],
          terrain: @terrain_map[resource],
          chit: parse_chit(map_lines, location),
          robber: contains_robber?(map_lines, location)
        }
    end
  end

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
  defp add_harbor(resource_type, direction, edges), do: Map.put_new(edges, direction, resource_type)

  defp contains_robber?(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y + 1) |> String.at(location.x) == "B"
  end

  defp parse_chit(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y - 1)
    |> String.slice(location.x - 1, 2)
    |> String.trim
    |> Integer.parse
    |> chit_value
  end

  defp chit_value({value, _}), do: value
  defp chit_value(:error), do: nil
end
