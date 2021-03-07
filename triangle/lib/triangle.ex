defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  defguard are_valid_triangle_sides(a, b, c)
    when (a >= b and a >= c and (b + c >= a))
      or (b >= c and b >= a and (c + a >= b))
      or (c >= a and c >= b and (a + b >= c))

  defguard there_are_negative_sides(a, b, c) when a <= 0 or b <= 0 or c <= 0
  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when there_are_negative_sides(a, b, c), do: {:error, "all side lengths must be positive"}
  def kind(a, b, c) when not are_valid_triangle_sides(a, b, c), do: {:error, "side lengths violate triangle inequality"}
  def kind(a, a, a), do: {:ok, :equilateral}
  def kind(a, _b, a), do: {:ok, :isosceles}
  def kind(b, b, _a), do: {:ok, :isosceles}
  def kind(_a, b, b), do: {:ok, :isosceles}
  def kind(_a, _b, _c), do: {:ok, :scalene}

end
