defmodule CatanMap do
  def resource_at(board, q, r), do: resource_at(board, %Location{q: q, r: r})
  def resource_at(board, name) when is_binary(name), do: resource_at(board, named_location(board, name))
  def resource_at(%{tiles: tiles}, location), do: tiles[location][:resource]

  def terrain_at(board, q, r), do: terrain_at(board, %Location{q: q, r: r})
  def terrain_at(board, name) when is_binary(name), do: terrain_at(board, named_location(board, name))
  def terrain_at(%{tiles: tiles}, location), do: tiles[location][:terrain]

  def chit_at(board, q, r), do: chit_at(board, %Location{q: q, r: r})
  def chit_at(board, name) when is_binary(name), do: chit_at(board, named_location(board, name))
  def chit_at(%{tiles: tiles}, location), do: tiles[location][:chit]

  def edge_at(board, q, r, d), do: edge_at(board, %Location{q: q, r: r, d: d})
  def edge_at(board, name, d), do: edge_at(board, %{named_location(board, name) | d: d})
  def edge_at(%{edges: edges}, location), do: edges[location]

  def vertex_at(board, q, r, d), do: vertex_at(board, %Location{q: q, r: r, d: d})
  def vertex_at(board, name, d), do: vertex_at(board, %{named_location(board, name) | d: d})
  def vertex_at(%{vertices: vertices}, location), do: vertices[location]

  def tile_at(board, q, r), do: tile_at(board, %Location{q: q, r: r})
  def tile_at(board, name) when is_binary(name), do: tile_at(board, named_location(board, name))
  def tile_at(%{tiles: tiles}, location), do: tiles[location]


  def terrain_count(%{tiles: tiles}) do
    Enum.count(tiles, fn({_, tile}) ->
      tile.terrain != nil && tile.terrain != :water
    end)
  end

  def robber_location(%{tiles: tiles}) do
    Enum.find_value(tiles, nil, fn({location, tile}) ->
      case tile[:robber] do
        false -> false
        true  -> location
      end
    end)
  end

  def named_location(%{tiles: tiles}, name) do
    Enum.find_value(tiles, nil, fn({location, tile}) ->
      case tile[:name] do
        ^name  -> location
        _      -> false
      end
    end)
  end
end
