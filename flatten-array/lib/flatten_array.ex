defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    rec(list)
  end

  defp rec(a, acc \\ [])
  defp rec([], acc), do: Enum.reverse(acc)
  defp rec([nil | t], acc), do: rec(t, acc)
  defp rec([h | t], acc) when is_integer(h), do: rec(t, [h | acc])
  defp rec([h | t], acc), do: rec(h ++ t, acc)

end
