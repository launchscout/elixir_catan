defmodule Location do
  defstruct q: nil, r: nil, d: nil

  def translate(l = %Location{}, q_delta, r_delta) do
    %Location{q: l.q + q_delta, r: l.r + r_delta}
  end
end
