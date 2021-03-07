defmodule Say do
  @trillion 1_000_000_000_000

  # the index is the magnitude of the order "before"
  # (e.g. 10^3 = 1000 -> 10^2 = 100)
  # useful shortcut
  @magnitudes %{
    3 => {2, "hundred"},
    6 => {3, "thousand"},
    9 => {6, "million"},
    12 => {9, "billion"}
  }

  @basic %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number >= @trillion,
    do: {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}
  def in_english(number), do: {:ok, in_word(number)}

  defp in_word(number) when number < 10, do: @basic[number]
  defp in_word(11), do: "eleven"
  defp in_word(12), do: "twelve"
  # foUrteen  <<>> fOrty
  defp in_word(14), do: "fourteen"
  defp in_word(number) when number in 15..19, do: get_basic(number - 10) <> "teen"

  defp in_word(number) when number in 20..99 do
    r = rem(number, 10)
    ~s(#{get_basic(div(number - r, 10))}ty#{(r > 0 && "-" <> @basic[r]) || ""})
  end

  defp in_word(number) do
    Enum.find_value(@magnitudes, fn {k, {pmag, plabel}} ->
      if order(number) < k, do: big(number, power10(pmag), plabel)
    end)
  end

  defp big(number, base, the_rest) do
    units = div(number, base)
    words = in_word(units) <> " " <> the_rest

    words <>
      case rem(number, base) do
        0 -> ""
        rem -> " " <> in_word(rem)
      end
  end

  defp order(n), do: n |> :math.log10() |> floor()
  defp power10(n), do: :math.pow(10, n) |> round()

  # used for > 10
  defp get_basic(2), do: "twen"
  defp get_basic(3), do: "thir"
  defp get_basic(4), do: "for"
  defp get_basic(5), do: "fif"
  defp get_basic(8), do: "eigh"
  defp get_basic(num), do: @basic[num]
end
