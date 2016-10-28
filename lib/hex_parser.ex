defmodule HexParser do
  @resource_map %{
    "a" => :grain,  "b" => :lumber,  "e" => nil,
    "i" => :brick,  "o" => :wool,    "r" => :ore
  }

  @terrain_map %{
    "a" => :fields, "b" => :forest,  "e" => :desert,
    "i" => :hills,  "o" => :pasture, "r" => :mountains
  }

  def parse_hex(map_lines, location = %AsciiLocation{}) do
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

  def contains_robber?(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y + 1) |> String.at(location.x) == "B"
  end

  def parse_chit(map_lines, location = %AsciiLocation{}) do
    Enum.at(map_lines, location.y - 1)
    |> String.slice(location.x - 1, 2)
    |> String.trim
    |> Integer.parse
    |> chit_value
  end

  def chit_value({value, _}), do: value
  def chit_value(:error), do: nil
end
