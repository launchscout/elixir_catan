defmodule VertexRenderer do
  def render_vertex(map_lines, %{player: player, type: type}, direction, l = %AsciiLocation{}) do
    Enum.at(map_lines, l.y)
    |> StringUtil.replace_substring(vertex_text(player, type), l.x + position(direction, type))
    |> StringUtil.replace_line(l.y, map_lines)
  end

  defp position(:right, :settlement), do: 6
  defp position(:right, :city), do: 5
  defp position(:left, _), do: -6

  @player_text %{
    blue:   "B",
    orange: "O",
    red:    "R",
    white:  "W"
  }
  def vertex_text(player, :settlement), do: @player_text[player]
  def vertex_text(player, :city), do: "#{@player_text[player]}#{@player_text[player]}"
end
