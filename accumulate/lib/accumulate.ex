defmodule Accumulate do
  @doc """
    Given a list and a function, apply the function to each list item and
    replace it with the function's return value.

    Returns a list.

    ## Examples

      iex> Accumulate.accumulate([], fn(x) -> x * 2 end)
      []

      iex> Accumulate.accumulate([1, 2, 3], fn(x) -> x * 2 end)
      [2, 4, 6]

  """

  @spec accumulate(list, (any -> any)) :: list
  def accumulate(list, fun) do
    rec_map(list, fun)
  end

  defp rec_map(list, fun, acc \\ [])
  defp rec_map([], _f, acc), do: Enum.reverse(acc)
  defp rec_map([h | t], f, acc), do: rec_map(t, f, [f.(h) | acc])
end
