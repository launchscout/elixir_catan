defmodule WhiteBread.DefaultContext do
  use WhiteBread.Context

  when_ ~r/^the map parser parses a rendered board that looks like:$/, fn(state, %{doc_string: rendered_board}) ->
    state = Map.put(state, :board, CatanMapParser.parse(rendered_board))
    {:ok, state}
  end

  then_ ~r/^the board has a terrain count of (?<terrain_count>[\d]+)$/, fn (state, %{terrain_count: terrain_count}) ->
    {count, _} = Integer.parse(terrain_count)
    assert count == CatanMap.terrain_count(state.board)
    {:ok, state}
  end

  then_ ~r/^the board has a "(?<terrain_type>[^"]+)" terrain at "(?<location_name>[^"]+)"$/,
  fn(state, %{terrain_type: terrain_type, location_name: location_name}) ->
    terrain = CatanMap.terrain_at(state.board, 0, 0)
    assert String.to_atom(terrain_type) == terrain
    {:ok, state}
  end

  then_ ~r/^the board has a "(?<resource_type>[^"]+)" resource at "(?<location_name>[^"]+)"$/,
  fn(state, %{resource_type: resource_type, location_name: location_name}) ->
    resource = CatanMap.resource_at(state.board, 0, 0)
    assert String.to_atom(resource_type) == resource
    {:ok, state}
  end

  then_ ~r/^the board has a (?<expected_chit>[\d]+) chit at "(?<location_name>[^"]+)"$/,
  fn(state, %{expected_chit: expected_chit, location_name: location_name}) ->
    {expected_chit, _} = Integer.parse(expected_chit)
    chit = CatanMap.chit_at(state.board, 0, 0)
    assert chit == expected_chit
    {:ok, state}
  end
end
