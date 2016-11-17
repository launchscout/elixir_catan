defmodule RoundOneTest do
  use ExUnit.Case

  setup do
    map = ~S"
            <----->
           /~~~~~~~\
          /~~~~~~~~~\
   >-----<~~~~~~~~~~~>-----<
  /~~~~~~~\~~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----R~~~~~~~~~~~>
 \~~~~~~~~~/       r~~~~~~~~~/
  \~~~~~~~/   12    r~~~~~~~/
   >-----<  lumber   >-----<
  /~~~~~~~\   HOME  /~~~~~~~\
 /~~~~~~~~~\       /~~~~~~~~~\
<~~~~~~~~~~~>-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<
          \~~~~~~~~~/
           \~~~~~~~/
            >-----<
    "
    {:ok, manager} =  GameManager.start_link(%{
      board: CatanMapParser.parse(map)
    })
    {:ok, game_manager: manager}
  end

  test "successfully adding a settlement" do
    location = %Location{q: 0, r: 0, d: :left}
    {:ok, game_state} = GameManager.add_settlement(:blue, location)
    assert CatanMap.vertex_at(game_state.board, location) == %{player: :blue, type: :settlement}
  end

  test "settlement too close to another" do
    location = %Location{q: 0, r: 0, d: :right}
    assert {:error, "Another settlement is too close"} = GameManager.add_settlement(:blue, location)
  end

  test "settlement already at location" do
    location = %Location{q: 1, r: -1, d: :left}
    assert {:error, "A settlement already exists there"} = GameManager.add_settlement(:blue, location)
  end

  test "settlement on water" do
    location = %Location{q: 0, r: -1, d: :left}
    assert {:error, "A settlement cannot be placed on water"} = GameManager.add_settlement(:blue, location)
  end
end
