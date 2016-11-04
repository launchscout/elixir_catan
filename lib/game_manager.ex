defmodule GameManager do
  use GenServer

  def start_link(game_state) do
    GenServer.start_link(__MODULE__, game_state, name: __MODULE__)
  end

  def add_settlement(player, location) do
    GenServer.call(__MODULE__, {:add_settlement, player: player, location: location})
  end

  def handle_call({:add_settlement, player: player, location: location}, _from, state) do
    {status, response, state} = cond do
      CatanMap.vertex_at(state.board, location) ->
        {:error, "A settlement already exists there", state}
      !Enum.empty?(Vertex.adjacent_settlements(state.board, location)) ->
        {:error, "Another settlement is too close", state}
      true ->
        state = put_in(state, [:board, :vertices, location], %{player: player, type: :settlement})
        {:ok, state, state}
    end
    {:reply, {status, response}, state}
  end
end
