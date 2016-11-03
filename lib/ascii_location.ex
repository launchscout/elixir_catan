defmodule AsciiLocation do
  defstruct x: nil, y: nil

  def qr_to_ascii(location = %Location{}, origin = %AsciiOrigin{}) do
    x = round(9 * location.q) + origin.x
    y = round(6 * (location.r + location.q / 2)) + origin.y

    cond do
      x - 6 < 0 || x + 6 >= origin.width -> nil
      y - 3 < 0 || y + 3 >= origin.height -> nil
      true -> %AsciiLocation{x: x, y: y}
    end
  end
end
