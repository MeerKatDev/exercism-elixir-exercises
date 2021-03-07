defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    {thousands, hundreds_rem} = order_to_roman(number, 1000)
    {hundreds, tens_rem} = order_to_roman(hundreds_rem, 100)
    {tens, last_rem} = order_to_roman(tens_rem, 10)
    {last, _} = order_to_roman(last_rem, 1)
    thousands <> hundreds <> tens <> last
  end

  defp order_to_roman(num, div) when num >= div do
    {pres, re} = get_int_float("#{num/div}")
    str = build_number(div, "", pres)

    {str, re}
  end

  defp order_to_roman(num, div), do: {"", num}

  defp build_number(_mag, str, n) when n == 0, do: str

  defp build_number(mag, str, n) do
    res = arabic_to_roman(mag * n)
    if res != "" do
      build_number(mag, res <> str, 0)
    else
      # ex: 600 -> "C" -> "DC"
      build_number(mag, arabic_to_roman(mag) <> str, n - 1)
    end
  end

  defp get_int_float(float) when is_binary(float) do
    {int, "." <> fl} = Integer.parse(float) # need both parts, i.e. a tuple
    floating_part = String.to_integer(fl) # need only the integer
    {int, floating_part}
  end

  defp arabic_to_roman(num) when is_integer(num) do
    case num do
      4 -> "IV"
      9 -> "IX"
      40 -> "XL"
      400 -> "CD"
      900 -> "CM"
      90 -> "XC"
      1 -> "I"
      5 -> "V"
      10 -> "X"
      50 -> "L"
      100 -> "C"
      500 -> "D"
      1000 -> "M"
      _ -> ""
    end
  end
end
