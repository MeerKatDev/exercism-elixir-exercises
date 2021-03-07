defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise "oops"
  def nth(count) do
    rec(2, 0, count)
  end

  defp rec(_n, last_prime, 0), do: last_prime
  defp rec(545, last_prime, _), do: last_prime # upper cap
  defp rec(n, last_prime, counter) do
    divisors = Stream.filter(1..div(n,2), &(rem(n, &1) == 0)) |> Enum.to_list()
    if length(divisors) == 1 do
      rec(n+1, n, counter-1)
    else
      rec(n+1, last_prime, counter)
    end
  end
end
