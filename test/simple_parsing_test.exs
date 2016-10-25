defmodule SimpleParsingTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    map = ~S"""
            <----->
           /~~~~~~~\
          /~~~~~~~~~\
   >-----<~~~~~~~~~~~>-----<
  /~~~~~~~\~~~~~~~~~/~~~~~~~\
 /~~~~~~~~~\~~~~~~~/~~~~~~~~~\
<~~~~~~~~~~~>-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \~~~~~~~~~/
  \~~~~~~~/    6    \~~~~~~~/
   >-----<   brick   >-----<
  /~~~~~~~\         /~~~~~~~\
 /~~~~~~~~~\       /~~~~~~~~~\
<~~~~~~~~~~~>-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<
          \~~~~~~~~~/
           \~~~~~~~/
            >-----<
    """
    {:ok, map: map}
  end

  test "parses correct tile count on a simple map", %{map: map} do
    assert CatanMap.parse(map) |> CatanMap.terrain_count == 1

  end

  test "assigns correct terrain on a simple map", %{map: map} do
    assert CatanMap.parse(map) |> CatanMap.terrain_at(0, 0) == :hills
  end

  test "assigned correct resource on a simple map", %{map: map} do
    assert CatanMap.parse(map) |> CatanMap.resource_at(0, 0) == :brick
  end
end
