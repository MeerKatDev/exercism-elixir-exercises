defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""
  def transpose(input) do
    strings = String.split(input, "\n")

    max_length =
      strings
      |> Enum.max_by(&String.length/1)
      |> String.length()

    Enum.map(strings, fn s ->
      String.pad_trailing(s, max_length)
      |> to_charlist()
    end)
    |> rec()
    |> Enum.join("\n")
    |> String.trim()
  end

  defp rec(charlists, acc \\ [])
  defp rec([], acc), do: Enum.reverse(acc)

  defp rec(charlists, acc) do
    {hds, tls} = split_strings(charlists)
    rec(tls, [hds | acc])
  end

  def split_strings(charlists, acc_hd \\ [], acc_tl \\ [])
  def split_strings([], acc_hd, acc_tl), do: {Enum.reverse(acc_hd), Enum.reverse(acc_tl)}
  def split_strings([[] | _tl], acc_hd, acc_tl), do: {Enum.reverse(acc_hd), Enum.reverse(acc_tl)}
  def split_strings([[hd | tl] | cl_tl], acc_hd, acc_tl) do
    split_strings(cl_tl, [hd | acc_hd], [tl | acc_tl])
  end
end
