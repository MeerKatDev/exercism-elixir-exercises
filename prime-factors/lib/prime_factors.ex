defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    rec(number)
  end

  # finding prime factors by repeated (integer) division
  def rec(a, n \\ 2, acc \\ [])
  def rec(1, _, acc), do: Enum.reverse(acc)
  # found one
  def rec(num, n, acc) when rem(num, n) == 0 do
    rec(div(num, n), n, [n | acc])
  end
  # didn't find any, go up by one
  def rec(num, n, acc), do: rec(num, n + 1, acc)
end
