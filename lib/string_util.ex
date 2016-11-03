defmodule StringUtil do
  def replace_line(line, position, lines) do
    List.replace_at(lines, position, line)
  end

  def replace_substring(dest, replacement, position) do
    dest = String.pad_trailing(dest, String.length(replacement) + position)
    String.slice(dest, 0, position)
    <> replacement
    <> String.slice(dest, position + String.length(replacement), String.length(dest) - 1)
  end
end
