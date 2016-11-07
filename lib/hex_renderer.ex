defmodule HexRenderer do
  def render_tile(map_lines, %{resource: nil, terrain: nil}, _), do: map_lines
  def render_tile(map_lines, tile, l = %AsciiLocation{}) do
    map_lines
    |> render_template(tile, l)
    |> render_resource(tile, l)
    |> render_chit(tile, l)
    |> render_robber(tile, l)
  end

  defp render_resource(map_lines, tile, l = %AsciiLocation{}) do
    _render_resource(tile, l.x, Enum.at(map_lines, l.y))
    |> StringUtil.replace_line(l.y, map_lines)
  end

  defp _render_resource(%{resource: nil, terrain: nil}, _, map_line), do: map_line
  defp _render_resource(%{resource: nil, terrain: :water}, _, map_line), do: map_line
  defp _render_resource(%{resource: nil, terrain: title}, x, map_line), do: Atom.to_string(title) |> render_centered(x, map_line)
  defp _render_resource(%{resource: title}, x, map_line), do: Atom.to_string(title) |> render_centered(x, map_line)

  defp render_chit(map_lines, tile, l = %AsciiLocation{}) do
    _render_chit(tile, l.x, Enum.at(map_lines, l.y - 1))
    |> StringUtil.replace_line(l.y - 1, map_lines)
  end

  defp _render_chit(%{chit: nil}, _, map_line), do: map_line
  defp _render_chit(%{chit: chit}, x, map_line), do: Integer.to_string(chit) |> render_centered(x, map_line)

  defp render_robber(map_lines, tile, l = %AsciiLocation{}) do
    _render_robber(tile, l.x + 1, Enum.at(map_lines, l.y - 1))
    |> StringUtil.replace_line(l.y - 1, map_lines)
  end

  defp _render_robber(%{robber: false}, _, map_line), do: map_line
  defp _render_robber(%{robber: true}, x, map_line), do: render_centered("R", x, map_line)

  defp render_centered(title, x, map_line) do
    start_position = x - trunc(String.length(title) / 2)
    StringUtil.replace_substring(map_line, title, start_position)
  end

  @water_template [~S{>-----<},
                  ~s{/~~~~~~~\\},
                 ~s{/~~~~~~~~~\\},
                ~S{<~~~~~~~~~~~>},
                 ~S{\~~~~~~~~~/},
                  ~S{\~~~~~~~/},
                   ~S{>-----<}]
  defp render_template(map_lines, %{terrain: :water}, l = %AsciiLocation{}) do
    Enum.with_index(@water_template)
    |> Enum.reduce(map_lines, fn({template_line, index}, map_lines) ->
      y = l.y + index - 3
      x = l.x + round((String.length(template_line) - 1) / -2)
      map_line = Enum.at(map_lines, y)
                 |> StringUtil.replace_substring(template_line, x)

      List.replace_at(map_lines, y, map_line)
    end)
  end

  @template [~S{>-----<},
            ~s{/       \\},
           ~s{/         \\},
          ~S{<           >},
           ~S{\         /},
            ~S{\       /},
             ~S{>-----<}]
  defp render_template(map_lines, _, l = %AsciiLocation{}) do
    Enum.with_index(@template)
    |> Enum.reduce(map_lines, fn({template_line, index}, map_lines) ->
      y = l.y + index - 3
      x = l.x + round((String.length(template_line) - 1) / -2)
      map_line = Enum.at(map_lines, y)
      |> StringUtil.replace_substring(template_line, x)

      List.replace_at(map_lines, y, map_line)
    end)
  end
end
