defmodule CatanMap do
  def resource_at(tiles = %{}, q, r), do: resource_at(tiles, %Location{q: q, r: r})
  def resource_at(%{tiles: tiles}, location), do: tiles[location][:resource]
  def resource_at(_, _), do: nil

  def terrain_at(tiles = %{}, q, r), do: terrain_at(tiles, %Location{q: q, r: r})
  def terrain_at(%{tiles: tiles}, location), do: tiles[location][:terrain]
  def terrain_at(_, _), do: nil

  def chit_at(tiles = %{}, q, r), do: chit_at(tiles, %Location{q: q, r: r})
  def chit_at(%{tiles: tiles}, location), do: tiles[location][:chit]
  def chit_at(_, _), do: nil

  def terrain_count(%{tiles: tiles}) do
    Enum.count(tiles, fn({_, tile}) ->
      tile.terrain != nil && tile.terrain != :water
    end)
  end

  def robber_location(%{tiles: tiles}) do
    Enum.find(tiles, nil, fn({location, tile}) ->
      case tile[:robber] do
        false -> false
        true -> location
      end
    end)
  end
end
