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
  defp add_harbor(resource_type, direction, edges) do
    Map.put_new(edges, direction, resource_type)
  end

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

  @intersection_offsets %{
    left: -6, right: 5
  }
  def parse_intersections(l = %AsciiLocation{}, map_lines) do
    line = Enum.at(map_lines, l.y)

    Enum.reduce(@intersection_offsets, %{}, fn({direction, offset}, intersections) ->
      val = String.slice(line, l.x + offset, 2)
      |> parse_intersection
      |> add_intersection(direction, intersections)
    end)
  end

  defp parse_intersection("<" <> _), do: nil
  defp parse_intersection(<<_::utf8>> <> ">"), do: nil
  defp parse_intersection("  "), do: nil
  defp parse_intersection(""), do: nil
  defp parse_intersection(value) do
    value = hd(Regex.run(~r{\w+}, value))
    case String.length(value) do
      1 -> parse_intersection(:settlement, value)
      2 -> parse_intersection(:city, String.at(value, 0))
    end
  end

  defp parse_intersection(type, "B"), do: %{type: type, player: :blue}
  defp parse_intersection(type, "O"), do: %{type: type, player: :orange}
  defp parse_intersection(type, "R"), do: %{type: type, player: :red}
  defp parse_intersection(type, "W"), do: %{type: type, player: :white}

  defp add_intersection(nil, _, intersections), do: intersections
  defp add_intersection(intersection, direction, intersections), do: Map.put(intersections, direction, intersection)

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
