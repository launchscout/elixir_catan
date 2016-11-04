defmodule Vertex do
  # Neighbor translations look like the following:
  #            >--<
  #           /    \
  #       >--< 0,-1 >--<
  #      /    \    /    \
  #     < -1,0 >--< 1,-1 >
  #      \    /    \    /
  #       >--<  Me  >--<
  #      /    \    /    \
  #     < -1,1 >--<  1,0 >
  #      \    /    \    /
  #       >--< 0,1  >--<
  #           \    /
  #            >--<

  def adjacent_settlements(board, l = %Location{}) do
    Enum.filter(neighbors(l), fn(other_location) ->
      case board.vertices[other_location] do
        %{player: _} -> true
        _ -> false
      end
    end)
  end

  def neighbors(l = %Location{d: :right}) do
    [%{Hexagon.neighbor(l, :ne) | d: :left},
     %{Hexagon.neighbor(l, :se) | d: :left},
     %{Hexagon.neighbor(Hexagon.neighbor(l, :se), :ne) | d: :left}]
  end

  def neighbors(l = %Location{d: :left}) do
    [%{Hexagon.neighbor(l, :nw) | d: :right},
     %{Hexagon.neighbor(l, :sw) | d: :right},
     %{Hexagon.neighbor(Hexagon.neighbor(l, :sw), :nw) | d: :right}]
  end
end
