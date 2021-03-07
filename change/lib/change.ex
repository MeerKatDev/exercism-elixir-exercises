defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_, 0), do: {:ok, []}
  def generate(coins, target) do
    initial = coins
    |> Enum.filter(&(target >= &1))
    |> Enum.reverse()

    Enum.map(0..(length(initial)-1), fn x ->
      initial
      |> Enum.drop(x)
      |> rec(target)
    end)
    |> Enum.min_by(&(length(&1)))
    |> case do
      [] -> {:error, "cannot change"}
      a ->
        if Enum.sum(a) == target do
          {:ok, Enum.sort(a)}
        else
          {:error, "cannot change"}
        end
    end
  end

  defp replicate(x, n), do: Enum.map(List.duplicate(1,n), &(&1 * x))

  defp rec(li, n, acc \\ [])
  defp rec([], _n, acc), do: acc
  defp rec([h | t], n, acc) when rem(n, h) == n, do: rec(t, n, acc)
  defp rec([h | t], n, acc), do: rec(t, rem(n, h), acc ++ replicate(h, div(n, h)))
end
