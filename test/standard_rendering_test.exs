defmodule StandardRenderingTest do
  use ExUnit.Case
  doctest CatanMap

  setup do
    board = %{
      edges: %{
        %Location{d: :s, q: -1, r: 2} => %{harbor_resource: :any},
        %Location{d: :s, q: 0, r: -3} => %{harbor_resource: :any},
        %Location{d: :s, q: 1, r: 1} => %{harbor_resource: :grain},
        %Location{d: :se, q: -3, r: 1} => %{harbor_resource: :brick},
        %Location{d: :se, q: -2, r: -1} => %{harbor_resource: :lumber},
        %Location{d: :se, q: 2, r: 0} => %{harbor_resource: :any, player: :red},
        %Location{d: :sw, q: -2, r: 2} => %{harbor_resource: :any},
        %Location{d: :sw, q: 2, r: -3} => %{harbor_resource: :wool},
        %Location{d: :sw, q: 3, r: -2} => %{harbor_resource: :ore}
      },
      tiles: %{
        %Location{d: nil, q: -1, r: 0} => %{chit: 8, resource: :wool, robber: false, terrain: :pasture},
        %Location{d: nil, q: -1, r: 3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 1, r: 0} => %{chit: 2, resource: :ore, robber: false, terrain: :mountains},
        %Location{d: nil, q: 2, r: 0} => %{chit: 12, resource: :brick, robber: false, terrain: :hills},
        %Location{d: nil, q: 2, r: -4} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: 0, r: -3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: -3, r: -1} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: 1, r: 2} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 0, r: 0} => %{chit: 6, resource: :brick, robber: false, terrain: :hills},
        %Location{d: nil, q: -3, r: 3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: -3, r: 0} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 1, r: -1} => %{chit: nil, resource: nil, robber: true, terrain: :desert},
        %Location{d: nil, q: 2, r: -1} => %{chit: 10, resource: :wool, robber: false, terrain: :pasture},
        %Location{d: nil, q: 1, r: -3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 3, r: -3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 3, r: -4} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: 0, r: 3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 0, r: -2} => %{chit: 8, resource: :lumber, robber: false, terrain: :forest},
        %Location{d: nil, q: -1, r: 1} => %{chit: 12, resource: :grain, robber: false, terrain: :fields},
        %Location{d: nil, q: -2, r: 4} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: -2, r: 0} => %{chit: 3, resource: :grain, robber: false, terrain: :fields},
        %Location{d: nil, q: 3, r: -1} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 0, r: 1} => %{chit: 4, resource: :wool, robber: false, terrain: :pasture},
        %Location{d: nil, q: -2, r: 3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: -1, r: -1} => %{chit: 11, resource: :brick, robber: false, terrain: :hills},
        %Location{d: nil, q: 0, r: 2} => %{chit: 5, resource: :wool, robber: false, terrain: :pasture},
        %Location{d: nil, q: -2, r: 1} => %{chit: 10, resource: :lumber, robber: false, terrain: :forest},
        %Location{d: nil, q: -3, r: 1} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: -3, r: 4} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: -1, r: -2} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: -3, r: 2} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 2, r: 2} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: 3, r: 0} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 3, r: 1} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: -2, r: -2} => %{chit: nil, resource: nil, robber: false, terrain: nil},
        %Location{d: nil, q: 3, r: -2} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 2, r: -3} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 1, r: -2} => %{chit: 4, resource: :brick, robber: false, terrain: :hills},
        %Location{d: nil, q: 2, r: -2} => %{chit: 9, resource: :ore, robber: false, terrain: :mountains},
        %Location{d: nil, q: -1, r: 2} => %{chit: 11, resource: :lumber, robber: false, terrain: :forest},
        %Location{d: nil, q: -2, r: -1} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 2, r: 1} => %{chit: nil, resource: nil, robber: false, terrain: :water},
        %Location{d: nil, q: 0, r: -1} => %{chit: 9, resource: :lumber, robber: false, terrain: :forest},
        %Location{d: nil, q: 1, r: 1} => %{chit: 5, resource: :grain, robber: false, terrain: :fields},
        %Location{d: nil, q: -2, r: 2} => %{chit: 6, resource: :grain, robber: false, terrain: :fields}
      },
      vertices: %{
        %Location{d: :left, q: -1, r: 1} => %{player: :red, type: :settlement},
        %Location{d: :right, q: 0, r: 1} => %{player: :white, type: :city}
      }
    }

    %{board: board}
  end

  test "it renders the board", %{board: board} do
        expected_map = ~S"
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
<~~~~~~~~~~~>-----R   grain   >-----<    ore    >-----<~~~~~~~~~~~>
 \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
  \~~~~~~~/    6    \       /    4    \       /   12    \~~~~~~~/
   >-----<   grain   >-----<   wool   WW-----<   brick   >-----<
  /~~~~~~3\         /       \         /       \         r3~~~~~~\
 /~~~~~~~~3\       /   11    \       /    5    \       r3~~~~~~~~\
<~~~~~~~~~~~>-----<  lumber   >-----<   grain   >-----<~~~~~~~~~~~>
 \~~~~~~~~~/~~~~~~~\         /       \         /~~~~~~~\~~~~~~~~~/
  \~~~~~~~/~~~~~~~~~\       /    5    \       /~~~~~~~~~\~~~~~~~/
   >-----<~~~~~~~~~~~>-----<   wool    >-----<~~~~~~~~~~~>-----<
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

    assert CatanMapRenderer.render(board) == expected_map
  end
end
