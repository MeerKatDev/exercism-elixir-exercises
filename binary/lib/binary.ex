defmodule Binary do
  @allowed ["0", "1"]
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    string
    |> String.codepoints()
    |> Enum.reverse()
    |> calculate()
  end

  defp calculate(li, idx \\ 0, acc \\ 0)
  defp calculate([], _idx, acc), do: acc
  defp calculate([h | t], idx, acc) when h in @allowed do
    calculate(t, idx + 1, acc + dg_to_dec(h, idx))
  end
  defp calculate(_, _, _), do: 0

  defp dg_to_dec(n, idx), do: String.to_integer(n) * round(:math.pow(2, idx))
end
