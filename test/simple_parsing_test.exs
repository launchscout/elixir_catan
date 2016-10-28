defmodule SimpleParsingTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map = ~S"
            <----->
           /~~~~~~~\
          /~~~~~~~~~\
   >-----<~~~~~~~~~~~>-----<
  /~~~~~~~\~~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \~~~~~~~~~/
  \~~~~~~~/   12    \~~~~~~~/
   >-----<  lumber   >-----<
  /~~~~~~~\         /~~~~~~~\
 /~~~~~~~~~\       /~~~~~~~~~\
<~~~~~~~~~~~>-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<
          \~~~~~~~~~/
           \~~~~~~~/
            >-----<
    "
    {:ok, map: map}
  end

  test "parses correct tile count on a simple map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_count == 1

  end

  test "assigns correct terrain on a simple map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.terrain_at(0, 0) == :forest
  end

  test "assigned correct resource on a simple map", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.resource_at(0, 0) == :lumber
  end

  test "parses correct chit value on origin hex", %{map: map} do
    assert CatanMapParser.parse(map) |> CatanMap.chit_at(0, 0) == 12
  end
end
