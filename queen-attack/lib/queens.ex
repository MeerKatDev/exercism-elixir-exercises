defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @admitted_range 0..7

  defguard good_coords?(p) when elem(p, 0) in @admitted_range and elem(p, 1) in @admitted_range
  defguard good_coords?(p1, p2) when good_coords?(p1) and good_coords?(p2)

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  # same position
  def new(white: {x, y}, black: {x, y}), do: raise(ArgumentError)

  def new([white: {x1, y1}, black: {x2, y2}] = map) when good_coords?({x1, y1}, {x2, y2}),
    do: Map.new(map)

  def new([white: p] = map) when good_coords?(p), do: Map.new(map)
  def new([black: p] = map) when good_coords?(p), do: Map.new(map)
  def new(_), do: raise(ArgumentError)

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    bpos = Map.get(queens, :black, {-1, -1})
    wpos = Map.get(queens, :white, {-1, -1})

    Enum.map(@admitted_range, fn row ->
      Enum.map(@admitted_range, fn
        col when {row, col} == bpos -> "B"
        col when {row, col} == wpos -> "W"
        _ -> "_"
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{white: {x1, y1}, black: {x2, y2}})
      when x1 == x2 or y1 == y2 or abs(x1 - x2) == abs(y1 - y2),
      do: true

  def can_attack?(_), do: false
end
