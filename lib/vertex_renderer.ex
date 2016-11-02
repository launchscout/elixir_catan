defmodule VertexRenderer do
  def render_vertex(vertex = %{type: :city}, :right, hex_center = %AsciiLocation{}, map_line), do: render_vertex(vertex, 5, map_line)
  def render_vertex(vertex = %{type: :settlement}, :right, hex_center = %AsciiLocation{}, map_line), do: render_vertex(vertex, 6, map_line)
  def render_vertex(vertex, _, hex_center = %AsciiLocation{}, map_line), do: render_vertex(vertex, -6, map_line)

  def render_vertex(%{player: player, type: type}, position, map_line) do
    replace_string(map_line, vertex_text(player, type), position)
  end

  @player_text %{
    blue: "B",
    orange: "O",
    red: "R",
    white: "W"
  }
  def vertex_text(player, :settlement) do
    @player_text[player]
  end

  def vertex_text(player, :city) do
    "#{@player_text[player]}#{@player_text[player]}"
  end

  defp replace_string(dest, replacement, position) do
    dest = String.pad_trailing(dest, String.length(replacement) + position)
    String.slice(dest, 0, position)
    <> replacement
    <> String.slice(dest, position + String.length(replacement), String.length(dest) - 1)
  end
end
