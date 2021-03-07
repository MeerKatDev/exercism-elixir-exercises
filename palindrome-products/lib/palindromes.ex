defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    find_products_in(min_factor, max_factor)
    |> Enum.filter(&is_palindrome/1)
    |> Enum.into(%{}, &({&1, factors_for(&1, min_factor, max_factor)}))
  end

  defp is_palindrome(n) do
    list = Integer.digits(n)
    list == Enum.reverse(list)
  end

  defp factors_for(number, min, max) do
    res0 = rec_fac(number, max) ++ rec_prime(number) |> Enum.uniq()
    res = Enum.map(res0, &(if [number] == &1, do: [1, number], else: &1))
    Enum.filter(res, &Enum.all?(&1, fn x -> x in min..max end))
  end

  defp find_products_in(min, max) do
    for(
      a <- min..max,
      b <- min..max,
      do: min(a, b) * max(a, b)
    )
    |> Enum.uniq()
  end

  # find general factors from above
  def rec_fac(a, n \\ 2, acc \\ [])
  def rec_fac(_a, 2, acc), do: [acc]
  # found one
  def rec_fac(num, n, acc) when rem(num, n) == 0 do
    rec_fac(div(num, n), n, [n | acc])
  end
  # didn't find any, go up by one
  def rec_fac(num, n, acc), do: rec_fac(num, n - 1, acc)

  # finding prime factors by repeated (integer) division
  def rec_prime(a, n \\ 2, acc \\ [])
  def rec_prime(1, _, acc), do: [acc]
  # found one
  def rec_prime(num, n, acc) when rem(num, n) == 0 do
    rec_prime(div(num, n), n, [n | acc])
  end
  # didn't find any, go up by one
  def rec_prime(num, n, acc), do: rec_prime(num, n + 1, acc)

end
