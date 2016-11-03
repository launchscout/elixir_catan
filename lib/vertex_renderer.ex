defmodule VertexRenderer do
  def render_vertex(map_lines, %{player: player, type: type}, direction, l = %AsciiLocation{}) do
    map_line = Enum.at(map_lines, l.y)
               |> replace_string(vertex_text(player, type), l.x + position(direction, type))

    List.replace_at(map_lines, l.y, map_line)
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

  defp replace_string(dest, replacement, position) do
    dest = String.pad_trailing(dest, String.length(replacement) + position)
    String.slice(dest, 0, position)
    <> replacement
    <> String.slice(dest, position + String.length(replacement), String.length(dest) - 1)
  end
end
