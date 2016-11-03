defmodule RoadRenderer do
  @player_text %{blue: "b", orange: "o", red: "r", white: "w"}
  @road_map %{sw: [{-5, 1}, {-4, 2}],
              se: [{ 5, 1}, { 4, 2}],
              s:  [{-1, 3}, { 0, 3}, {1, 3}]}
  def render_road(map_lines, %{player: player}, direction, l = %AsciiLocation{}) do
    Enum.reduce(@road_map[direction], map_lines, fn({x, y}, map_lines) ->
      map_lines
      |> Enum.at(l.y + y)
      |> StringUtil.replace_substring(@player_text[player], l.x + x)
      |> StringUtil.replace_line(l.y + y, map_lines)
    end)
  end

  def render_road(map_lines, _, _, _), do: map_lines
end
