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

  def parse_hex(map_lines, ascii_position = %{x: x, y: y}) do
    water = String.at(Enum.at(map_lines, y + 1), x)
    resource = String.at(Enum.at(map_lines, y), x)
    cond do
      water == "~" ->
        %{
          resource: nil,
          terrain: :water,
          chit: nil
        }
      true ->
        %{
          resource: @resource_map[resource],
          terrain: @terrain_map[resource],
          chit: parse_chit(map_lines, ascii_position)
        }
    end
  end

  def parse_chit(map_lines, _ascii_position = %{x: x, y: y}) do
    parsed_chit = Enum.at(map_lines, y - 1)
                  |> String.slice(x - 1, 2)
                  |> String.trim
                  |> Integer.parse
    case parsed_chit do
      {x, _} -> x
      :error -> nil
    end
  end
end
