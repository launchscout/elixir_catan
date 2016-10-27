defmodule HexParser do
  @resource_map %{
    "a" => :grain,
    "b" => :lumber,
    "i" => :brick,
    "o" => :wool,
    "r" => :ore,
    "s" => nil
  }

  @terrain_map %{
    "a" => :fields,
    "b" => :forest,
    "i" => :hills,
    "o" => :pasture,
    "r" => :mountains,
    "s" => :desert
  }

  def parse_hex(map_lines, _ascii_position = %{x: x, y: y}) do
    new_y = y + 1
    water = String.at(Enum.at(map_lines, new_y), x)
    resource = String.at(Enum.at(map_lines, y), x)
    cond do
      water == "~" ->
        %{
          resource: nil,
          terrain: :water
        }
      true ->
        %{
          resource: @resource_map[resource],
          terrain: @terrain_map[resource]
        }
    end
  end
end
