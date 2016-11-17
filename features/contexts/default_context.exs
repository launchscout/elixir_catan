defmodule WhiteBread.DefaultContext do
  use WhiteBread.Context

  given_ ~r/^I have the rendered board:$/, fn(state, %{doc_string: text_board}) ->
    state = Map.put(state, :text_board, text_board)
    {:ok, state}
  end

  when_ ~r/^the map parser parses the board$/, fn state ->
    state = Map.put(state, :board, CatanMapParser.parse(state.text_board))
    {:ok, state}
  end

  then_ ~r/^the board has a robber at "(?<named_tile>[^"]+)"$/, fn state, %{named_tile: named_tile} ->
    assert CatanMap.robber_location(state.board) == CatanMap.named_location(state.board, named_tile)
    {:ok, state}
  end

  then_ ~r/^the board has a terrain count of (?<terrain_count>[\d]+)$/, fn (state, %{terrain_count: terrain_count}) ->
    {count, _} = Integer.parse(terrain_count)
    assert count == CatanMap.terrain_count(state.board)
    {:ok, state}
  end

  then_ ~r/^the board has a "(?<terrain_type>[^"]+)" terrain at "(?<location_name>[^"]+)"$/,
  fn(state, %{terrain_type: terrain_type, location_name: location_name}) ->
    terrain = CatanMap.terrain_at(state.board, location_name)
    assert String.to_atom(terrain_type) == terrain
    {:ok, state}
  end

  and_ ~r/^the board has no resource at "(?<named_tile>[^"]+)"$/,
  fn state, %{named_tile: named_tile} ->
    assert %{resource: nil} = CatanMap.tile_at(state.board, named_tile)
    {:ok, state}
  end

  then_ ~r/^the board has a "(?<resource_type>[^"]+)" resource at "(?<location_name>[^"]+)"$/,
  fn(state, %{resource_type: resource_type, location_name: location_name}) ->
    resource = CatanMap.resource_at(state.board, location_name)
    assert String.to_atom(resource_type) == resource
    {:ok, state}
  end

  then_ ~r/^the board has a (?<expected_chit>[\d]+) chit at "(?<location_name>[^"]+)"$/,
  fn(state, %{expected_chit: expected_chit, location_name: location_name}) ->
    {expected_chit, _} = Integer.parse(expected_chit)
    chit = CatanMap.chit_at(state.board, location_name)
    assert chit == expected_chit
    {:ok, state}
  end

  then_ ~r/^the "(?<player>[^"]+)" player has a (?<settlement_type>[\w]+) at the "(?<direction>[^"]+)" side of "(?<named_tile>[^"]+)"$/,
  fn state, %{player: player, settlement_type: settlement_type, direction: direction, named_tile: named_tile} ->
    direction_atom = direction |> String.downcase |> String.to_atom
    settlement_type_atom = String.to_atom(settlement_type)
    player_atom = String.to_atom(player)
    location = %{CatanMap.named_location(state.board, named_tile) | d: direction_atom}
    assert %{player: player_atom, type: settlement_type_atom} = CatanMap.vertex_at(state.board, location)
    {:ok, state}
  end

  then_ ~r/^the "(?<player>[^"]+)" player has a road at the "(?<direction>[^"]+)" edge of "(?<named_tile>[^"]+)"$/,
  fn state, %{player: player, direction: direction, named_tile: named_tile} ->
    direction_atom = direction |> String.downcase |> String.to_atom
    player_atom = String.to_atom(player)
    location = %{CatanMap.named_location(state.board, named_tile) | d: direction_atom}
    assert %{player: player_atom} = CatanMap.edge_at(state.board, location)
    {:ok, state}
  end

  then_ ~r/^the board has a harbor at the "(?<direction>[^"]+)" edge of "(?<named_tile>[^"]+)"$/,
  fn state, %{direction: direction, named_tile: named_tile} ->
    direction_atom = direction |> String.downcase |> String.to_atom
    location = %{CatanMap.named_location(state.board, named_tile) | d: direction_atom}
    assert %{harbor_resource: :any} = CatanMap.edge_at(state.board, location)
    {:ok, state}
  end
end
