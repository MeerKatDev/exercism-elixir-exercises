defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    rec(number, number)
    |> Enum.sort()
    |> Enum.map(fn
      3 -> "Pling"
      5 -> "Plang"
      7 -> "Plong"
      _n -> ""
    end)
    |> Enum.join("")
    |> case do
      "" -> "#{number}"
      str -> str
    end
  end

  defp rec(num, n, acc \\ [1])
  defp rec(_num, 1, acc), do: acc
  defp rec(num, n, acc) do
    case Integer.parse("#{num/n}") do
      {_, ".0"} ->
        rec(num, n-1, [n | acc])
      _ ->
        rec(num, n-1, acc)
    end
  end
end
