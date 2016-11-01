defmodule VertexParser do
  @vertex_offsets %{
    left: -6, right: 5
  }
  def parse_vertices(l = %AsciiLocation{}, map_lines) do
    line = Enum.at(map_lines, l.y)

    Enum.reduce(@vertex_offsets, %{}, fn({direction, offset}, vertices) ->
      val = String.slice(line, l.x + offset, 2)
      |> parse_vertex
      |> add_vertex(direction, vertices)
    end)
  end

  defp parse_vertex("<" <> _), do: nil
  defp parse_vertex(<<_::utf8>> <> ">"), do: nil
  defp parse_vertex("  "), do: nil
  defp parse_vertex(""), do: nil
  defp parse_vertex(value) do
    value = hd(Regex.run(~r{\w+}, value))
    case String.length(value) do
      1 -> parse_vertex(:settlement, value)
      2 -> parse_vertex(:city, String.at(value, 0))
    end
  end

  defp parse_vertex(type, "B"), do: %{type: type, player: :blue}
  defp parse_vertex(type, "O"), do: %{type: type, player: :orange}
  defp parse_vertex(type, "R"), do: %{type: type, player: :red}
  defp parse_vertex(type, "W"), do: %{type: type, player: :white}

  defp add_vertex(nil, _, vertices), do: vertices
  defp add_vertex(vertex, direction, vertices), do: Map.put(vertices, direction, vertex)
end
