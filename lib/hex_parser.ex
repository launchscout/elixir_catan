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
    water = String.at(Enum.at(map_lines, location.y - 1), location.x)
    resource = String.at(Enum.at(map_lines, location.y), location.x)
    name = parse_name(map_lines, location)
    build_tile(map_lines, location, water, resource, name)
  end

  defp build_tile(_, _, "~", _, name) do
    %{
      resource: nil,
      terrain: :water,
      chit: nil,
      robber: false,
      name: name
    }
  end

  defp build_tile(map_lines, location = %AsciiLocation{}, _, resource, name) do
    %{
      resource: @resource_map[resource],
      terrain: @terrain_map[resource],
      chit: parse_chit(map_lines, location),
      robber: contains_robber?(map_lines, location),
      name: name
    }
  end

  defp contains_robber?(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y - 1) |> String.at(location.x + 1) == "R"
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

  defp parse_name(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y + 1)
    |> String.slice(location.x - 3, 7)
    |> String.trim
    |> String.trim("~")
    |> normalize_name
  end

  defp normalize_name(""), do: nil
  defp normalize_name(name), do: name
end
