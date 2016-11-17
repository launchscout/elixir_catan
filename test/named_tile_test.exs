defmodule NamedTileTest do
  use ExUnit.Case

  setup do
    map_render = ~S"
                              >-----<
                             /~~~~~~~\
                            /~~~~~~~~~\
                     >-----<~~~~~~~~~~~>-----<
                    /~~~~~~~\~~~~~~~~~/~~~~~~~\
                   /~~~~~~~~~\~~333~~/~~~~~~~~~\
            >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
           /~~~~~~~\~~~~~~~~~/       \~~~~~~~~~/~~~~~~~\
          /~~~~~~~~~\~~~~~~~/    8    \~~~~~~~/~~~~~~~~~\
   >-----<~~~~~~~~~~~>-----<  lumber   >-----<~~~~~~~~~~~>-----<
  /~~~~~~~\~~~~~~~~l/       \    TOP  /       \w~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~l/   11    \       /    4    \w~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----<   brick   >-----<   brick   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
  \~~~~~~~/    3    \       /    9    \       /    9    \~~~~~~~/
   >-----<   grain   >-----<  lumber   >-----<    ore    >-----<
  /~~~~~~~\  LEFTY  /       \         /       \         /~~~~~~~\
 /~~~~~~~~~\       /    8    \       /     R   \       /~~~~~~~~~\
<~~~~~~~~~~~>-----<   wool    >-----<  desert   >-----<~~~~~~~~~~~>
 \~~~~~~~~b/       \         /       \         /       \o~~~~~~~~/
  \~~~~~~b/   10    \       /    6    \       /   10    \o~~~~~~/
   >-----<  lumber   >-----<   brick   >-----<   wool    >-----<
  /~~~~~~~\         /       \   HOME  /       \         /~~~~~~~\
 /~~~~~~~~~\       /   12    \       /    2    \       /~~~~~~~~~\
<~~~~~~~~~~~>-----R   grain   >-----<    ore    >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
  \~~~~~~~/    6    \       /    4    \       /   12    \~~~~~~~/
   >-----<   grain   >-----<   wool   WW-----<   brick   >-----<
  /~~~~~~3\         /       \   VERT  /       \   EDGE  r3~~~~~~\
 /~~~~~~~~3\       /   11    \       /    5    \       r3~~~~~~~~\
<~~~~~~~~~~~>-----<  lumber   >-----<   grain   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\         /       \         /~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\       /    5    \       /~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<   wool    >-----<~~~~~~~~~~~>-----<
          \~~WATER~~/~~333~~\         /~~ggg~~\~~~~~~~~~/
           \~~~~~~~/~~~~~~~~~\       /~~~~~~~~~\~~~~~~~/
            >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
                   \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
                    \~~~~~~~/~~~~~~~~~\~~~~~~~/
                     >-----<~~~~~~~~~~~>-----<
                            \~~~~~~~~~/
                             \~~~~~~~/
                              >-----<
"

    parsed_map = CatanMapParser.parse(map_render)
    {:ok, map: parsed_map, map_render: map_render}
  end

  # Parsing/rendering tests
  #
  # Ensure that valid names appearing on tiles are parsed, referenceable, and renderable.
  test "parses and renders the same map (with tile names)", %{map: map, map_render: original} do
    assert map |> CatanMapRenderer.render == original
  end


  test "returns a location from a tile name", %{map: map} do
    assert CatanMap.named_location(map, "HOME") == %Location{q: 0, r: 0}
  end

  test "understands names for water tiles", %{map: map} do
    assert CatanMap.named_location(map, "WATER") == %Location{q: -2, r: 3}
  end

  test "strips spaces from tile names", %{map: map} do
    assert CatanMap.tile_at(map, 0, 0)[:name] == "HOME"
  end


  # Property-access function head tests
  #
  # Check that each property-access function head has a named-tile complement to the raw location syntax
  test "can access tiles by tile name", %{map: map} do
    assert CatanMap.tile_at(map, "HOME")
  end

  test "can reference tile resources by name", %{map: map} do
    assert CatanMap.resource_at(map, "HOME") == :brick
  end

  test "can reference tile terrain by name", %{map: map} do
    assert CatanMap.terrain_at(map, "HOME") == :hills
  end

  test "can reference tile chit values by name", %{map: map} do
    assert CatanMap.chit_at(map, "HOME") == 6
  end

  test "can reference tile edges by name", %{map: map} do
    edge = CatanMap.edge_at(map, "EDGE", :se)
    assert edge[:harbor_resource] == :any
  end

  test "can reference tile vertices by name", %{map: map} do
    vertex = CatanMap.vertex_at(map, "VERT", :right)
    assert vertex.player == :white
    assert vertex.type == :city
  end
end
