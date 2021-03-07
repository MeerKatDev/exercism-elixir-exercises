defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Enum.filter(&(&1 < limit))
    |> rec(limit)
    |> Enum.uniq()
    |> Enum.sum()
  end

  defp rec(li, n, acc \\ [])
  defp rec([], _, acc), do: acc
  defp rec([h | t], n, acc) do
    gen = Enum.map(1..div(n-1,h), &(&1 * h))
    rec(t, n, acc ++ gen)
  end
end
