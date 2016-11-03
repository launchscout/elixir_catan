defmodule EdgeRenderer do
  @player_text %{
    blue:   "b",
    orange: "o",
    red:    "r",
    white:  "w"
  }

  @road_map %{
    sw: [{-5, 1}, {-4, 2}],
    se: [{ 5, 1}, { 4, 2}],
    s:  [{-1, 3}, { 0, 3}, {1, 3}]
  }

  def render_road(map_lines, %{player: nil}, _, _), do: map_lines

  def render_road(map_lines, t = %{player: player}, direction, l = %AsciiLocation{}) do
    Enum.reduce(@road_map[direction], map_lines, fn({x, y}, map_lines) ->
      map_lines
      |> Enum.at(l.y + y)
      |> replace_string(@player_text[player], l.x + x)
      |> replace_line(l.y + y, map_lines)
    end)
  end

  def render_road(map_lines, _, _, _), do: map_lines

  defp replace_line(map_line, position, map_lines) do
    List.replace_at(map_lines, position, map_line)
  end

  defp replace_string(dest, replacement, position) do
    dest = String.pad_trailing(dest, String.length(replacement) + position)
    String.slice(dest, 0, position)
    <> replacement
    <> String.slice(dest, position + String.length(replacement), String.length(dest) - 1)
  end
end
