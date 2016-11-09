defmodule NamedHexTest do
  use ExUnit.Case

  setup do
    map_render = ~S"
                     >-----<
                    /~~~~~~~\
                   /~~~~~~~~~\
            >-----<~~~~~~~~~~~>-----<
           /~~~~~~~\~~~~~~~~~/~~~~~~~\
          /~~~~~~~~~\~~~~~~~/~~~~~~~~~\
   >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
  /~~~~~~~\~~~~~~~~~/       \~~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~~/    8    \~~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----<  lumber   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \    TOP  /       \~~~~~~~~~/
  \~~~~~~~/   11    \       /    4    \~~~~~~~/
   >-----<   brick   >-----<   brick   >-----<
  /~~~~~~~\         /       \         /~~~~~~~\
 /~~~~~~~~~\       /    9    \       /~~~~~~~~~\
<~~~~~~~~~~~>-----<  lumber   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \   HOME  /       \~~~~~~~~~/
  \~~~~~~~/    8    \       /     R   \~~~~~~~/
   >-----<   wool    >-----<  desert   >-----<
  /~~~~~~~\         /       \         /~~~~~~~\
 /~~~~~~~~~\       /    6    \       /~~~~~~~~~\
<~~~~~~~~~~~>-----<   brick   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\    BOT  /~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\       /~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
          \~~WATER~~/~~~~~~~\~~~~~~~~~/
           \~~~~~~~/~~~~~~~~~\~~~~~~~/
            >-----<~~~~~~~~~~~>-----<
                   \~~~~~~~~~/
                    \~~~~~~~/
                     >-----<
"

    parsed_map = CatanMapParser.parse(map_render)
    {:ok, map: parsed_map, map_render: map_render}
  end

  test "parses and renders the same map (with tile names)", %{map: map, map_render: original} do
    assert map |> CatanMapRenderer.render == original
  end


  test "returns a location from a tile name", %{map: map} do
    assert map |> CatanMap.named_location("HOME") == %Location{q: 0, r: 0}
  end

  test "understands names for water tiles", %{map: map} do
    assert map |> CatanMap.named_location("WATER") == %Location{q: -1, r: 2}
  end

  test "strips spaces from tile names", %{map: map} do
    assert map |> CatanMap.tile_at(0, 0)[:name] == "HOME"
  end
end
