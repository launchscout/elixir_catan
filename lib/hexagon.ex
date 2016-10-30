defmodule Hexagon do
  # Neighbor translations look like the following:
  #            >--<
  #           /    \
  #       >--< -1,0 >--<
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

  def neighbor(l = %Location{}, :nw), do: Location.translate(l, -1,  0)
  def neighbor(l = %Location{}, :n ), do: Location.translate(l, -1,  0)
  def neighbor(l = %Location{}, :ne), do: Location.translate(l,  1, -1)
  def neighbor(l = %Location{}, :se), do: Location.translate(l,  1,  0)
  def neighbor(l = %Location{}, :s ), do: Location.translate(l,  0,  1)
  def neighbor(l = %Location{}, :sw), do: Location.translate(l, -1,  1)

  def edge(l = %Location{}, :nw), do: %{neighbor(l, :nw) | d: :se} #NW neighbor's SE edge
  def edge(l = %Location{}, :n ), do: %{neighbor(l, :n ) | d: :s } #N  neighbor's S edge
  def edge(l = %Location{}, :ne), do: %{neighbor(l, :ne) | d: :sw} #NE neighbor's SW edge
  def edge(l = %Location{}, :se), do: %{l | d: :se}
  def edge(l = %Location{}, :s ), do: %{l | d: :s }
  def edge(l = %Location{}, :sw), do: %{l | d: :sw}
end
