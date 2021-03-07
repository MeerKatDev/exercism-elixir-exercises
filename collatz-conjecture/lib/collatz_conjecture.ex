defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when (not is_integer(input)) or (input <= 0), do: raise FunctionClauseError
  def calc(input) do
    rec(input)
  end

  defp rec(n, counter \\ 0)
  defp rec(1, counter), do: counter
  defp rec(n, counter) when rem(n,2) == 0, do: rec(div(n,2), counter + 1)
  defp rec(n, counter), do: rec(3*n+1, counter + 1)
end
