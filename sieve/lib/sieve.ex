defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    Enum.reduce(2..limit, {[],[]}, fn x, {primes, notprimes} ->
        if x not in notprimes do
          {[x | primes], Enum.uniq(iterate(x, x, limit) ++ notprimes)}
        else
          {primes, notprimes}
        end
    end)
    |> elem(0)
    |> Enum.sort()
  end

  defp iterate(from, every, until) do
    Stream.iterate(from + every, &(&1 + every))
    |> Enum.take(div(until-from, every))
  end
end
