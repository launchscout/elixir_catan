defmodule StandardParsingTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map = ~S"
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
  /~~~~~~~\~~~~~~~~l/       \         /       \w~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~l/   11    \       /    4    \w~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----<   brick   >-----<   brick   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
  \~~~~~~~/    3    \       /    9    \       /    9    \~~~~~~~/
   >-----<   grain   >-----<  lumber   >-----<    ore    >-----<
  /~~~~~~~\         /       \         /       \         /~~~~~~~\
 /~~~~~~~~~\       /    8    \       /         \       /~~~~~~~~~\
<~~~~~~~~~~~>-----<   wool    >-----<  desert   >-----<~~~~~~~~~~~>
 \~~~~~~~~b/       \         /       \ ROBBER  /       \o~~~~~~~~/
  \~~~~~~b/   10    \       /    6    \       /   10    \o~~~~~~/
   >-----<  lumber   >-----<   brick   >-----<   wool    >-----<
  /~~~~~~~\         /       \         /       \         /~~~~~~~\
 /~~~~~~~~~\       /   12    \       /    2    \       /~~~~~~~~~\
<~~~~~~~~~~~>-----<   grain   >-----<    ore    >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
  \~~~~~~~/    6    \       /    4    \       /   12    \~~~~~~~/
   >-----<   grain   >-----<   wool    >-----<   brick   >-----<
  /~~~~~~3\         /       \         /       \         /3~~~~~~\
 /~~~~~~~~3\       /   11    \       /    5    \       /3~~~~~~~~\
<~~~~~~~~~~~>-----<  lumber   >-----<   grain   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\         /       \         /~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\       /    5    \       /~~~~~~~~~\~~~~~~~/
   >-----< ~~~~~~~~~~>-----<   wool    >-----<~~~~~~~~~~~>-----<
          \~~~~~~~~~/~~333~~\         /~~ggg~~\~~~~~~~~~/
           \~~~~~~~/~~~~~~~~~\       /~~~~~~~~~\~~~~~~~/
            >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
                   \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
                    \~~~~~~~/~~~~~~~~~\~~~~~~~/
                     >-----<~~~~~~~~~~~>-----<
                            \~~~~~~~~~/
                             \~~~~~~~/
                              >-----<
    "

  {:ok, map: map}
  end

  test "parses correct tile count on a standard map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_count == 19
  end

  test "assigns correct terrain at the origin on a standard map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_at(0, 0) == :hills
    assert CatanMapParser.parse(map) |> CatanMap.resource_at(0, 0) == :brick
  end

  test "parses correct chit value on origin hex", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.chit_at(0, 0) == 6
  end

  test "assigned correct resource on the q axis on a standard map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_at(-2, 0) == :fields
    assert CatanMapParser.parse(map) |> CatanMap.resource_at(-2, 0) == :grain
  end

  test "parses robber correctly", %{map: map} do
    _robber_location = CatanMapParser.parse(map) |> CatanMap.robber_location
    assert _robber_location = %{q: 1, r: -1}
  end

  test "detects water hexes correctly", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_at(3, 0) == :water
    assert CatanMapParser.parse(map) |> CatanMap.resource_at(3, 0) == nil
  end

  test "detects resource harbors and assigns them to the correct edge location", %{map: map} do
    edge = CatanMapParser.parse(map) |> CatanMap.edge_at(-2, 2, :sw)
    assert edge[:harbor_resource] == :any
  end
end
