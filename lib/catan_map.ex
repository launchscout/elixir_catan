defmodule CatanMap do
  def terrain_count(%{count: count}), do: count
  def terrain_count(_), do: nil

  def resource_at(%{tiles: tiles}, q, r), do: tiles[q][r][:resource]
  def resource_at(_, _, _), do: nil

  def terrain_at(%{tiles: tiles}, q, r), do: tiles[q][r][:terrain]
  def terrain_at(_, _, _), do: nil

  def chit_at(%{tiles: tiles}, q, r), do: tiles[q][r][:chit]
  def chit_at(_, _, _), do: nil

  def robber_location(%{tiles: tiles}) do
    Enum.find(tiles, nil, fn({q, q_map}) ->
      r_value = Enum.find(q_map, nil, fn({r, tile}) ->
        case tile[:robber] do
          false -> false
          true -> r
        end
      end)

      case r_value do
        false -> false
        r -> %{q: q, r: r}
      end
    end)
  end
end
