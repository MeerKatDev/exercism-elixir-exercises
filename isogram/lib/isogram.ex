defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.replace(["-"," "], "")
    |> String.to_charlist()
    |> rec()
  end

  defp rec(a, acc \\ [], res \\ true)
  defp rec(_a, _acc, false), do: false
  defp rec([], _acc, res), do: res
  defp rec([h | t], acc, _res), do: rec(t, [h | acc], !(h in acc))

end
