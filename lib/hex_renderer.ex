defmodule HexRenderer do
  def render_tile(%{resource: nil, terrain: nil}, _, map_lines), do: map_lines
  def render_tile(tile, l = %AsciiLocation{}, map_lines) do
    map_lines = render_template(tile, l, map_lines)

    resource_line = render_resource(tile, l.x, Enum.at(map_lines, l.y))
    map_lines = List.replace_at(map_lines, l.y, resource_line)

    chit_line = render_chit(tile, l.x, Enum.at(map_lines, l.y - 1))
    map_lines = List.replace_at(map_lines, l.y - 1, chit_line)

    robber_line = render_robber(tile, l.x, Enum.at(map_lines, l.y + 1))
    List.replace_at(map_lines, l.y + 1, robber_line)
  end

  defp render_resource(%{resource: nil, terrain: nil}, _, map_line), do: map_line
  defp render_resource(%{resource: nil, terrain: :water}, x, map_line), do: map_line
  defp render_resource(%{resource: nil, terrain: title}, x, map_line), do: Atom.to_string(title) |> render_centered(x, map_line)
  defp render_resource(%{resource: title}, x, map_line), do: Atom.to_string(title) |> render_centered(x, map_line)

  defp render_chit(%{chit: nil}, x, map_line), do: map_line
  defp render_chit(%{chit: chit}, x, map_line), do: Integer.to_string(chit) |> render_centered(x, map_line)

  defp render_robber(%{robber: false}, x, map_line), do: map_line
  defp render_robber(%{robber: true}, x, map_line), do: render_centered("ROBBER", x, map_line)

  defp render_centered(title, x, map_line) do
    start_position = x - trunc(String.length(title) / 2)
    replace_string(map_line, title, start_position)
  end

  @water_template [~S{>-----<},
                  ~s{/~~~~~~~\\},
                 ~s{/~~~~~~~~~\\},
                ~S{<~~~~~~~~~~~>},
                 ~S{\~~~~~~~~~/},
                  ~S{\~~~~~~~/},
                   ~S{>-----<}]
  defp render_template(%{terrain: :water}, l = %AsciiLocation{}, map_lines) do
    Enum.with_index(@water_template)
    |> Enum.reduce(map_lines, fn({template_line, index}, map_lines) ->
      y = l.y + index - 3
      x = l.x + round((String.length(template_line) - 1) / -2)
      map_line = Enum.at(map_lines, y)
                 |> replace_string(template_line, x)

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
  defp render_template(_, l = %AsciiLocation{}, map_lines) do
    Enum.with_index(@template)
    |> Enum.reduce(map_lines, fn({template_line, index}, map_lines) ->
      y = l.y + index - 3
      x = l.x + round((String.length(template_line) - 1) / -2)
      map_line = Enum.at(map_lines, y)
      |> replace_string(template_line, x)

      List.replace_at(map_lines, y, map_line)
    end)
  end

  defp replace_string(dest, replacement, position) do
    dest = String.pad_trailing(dest, String.length(replacement) + position)
    String.slice(dest, 0, position)
    <> replacement
    <> String.slice(dest, position + String.length(replacement), String.length(dest) - 1)
  end
end
