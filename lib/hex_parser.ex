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
end
