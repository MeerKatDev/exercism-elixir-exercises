defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Enum.reduce(0..(num-1), [], fn row, acc ->
      pv = Enum.at(acc, 0, [1])
      next_list = Enum.map(0..row, &(at(pv, &1-1) + at(pv, &1)))
      [next_list | acc]
    end)
    |> Enum.reverse()
  end

  defp at(_arr, -1), do: 0
  defp at(arr, n), do: Enum.at(arr, n, 0)
end
