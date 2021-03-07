defmodule TwelveDays do

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{ordinal(number)} day of Christmas my true love gave to me: #{generate_things_list(number)}."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Enum.map(starting_verse..ending_verse, &verse/1) |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end

  defp generate_things_list(n, acc \\ [])
  defp generate_things_list(0, []), do: "" # not in the tests but good for completeness
  defp generate_things_list(1, []), do: element(1)
  defp generate_things_list(1, acc) do
    acc
    |> Enum.reverse()
    |> Enum.join(", ")
    |> (&(&1 <> ", and " <> element(1) )).()
  end
  defp generate_things_list(n, acc) do
    generate_things_list(n-1, [element(n) | acc])
  end

  defp ordinal(1), do: "first"
  defp ordinal(2), do: "second"
  defp ordinal(3), do: "third"
  defp ordinal(4), do: "fourth"
  defp ordinal(5), do: "fifth"
  defp ordinal(6), do: "sixth"
  defp ordinal(7), do: "seventh"
  defp ordinal(8), do: "eighth"
  defp ordinal(9), do: "ninth"
  defp ordinal(10), do: "tenth"
  defp ordinal(11), do: "eleventh"
  defp ordinal(12), do: "twelfth"

  defp element(1), do: "a Partridge in a Pear Tree"
  defp element(2), do: "two Turtle Doves"
  defp element(3), do: "three French Hens"
  defp element(4), do: "four Calling Birds"
  defp element(5), do: "five Gold Rings"
  defp element(6), do: "six Geese-a-Laying"
  defp element(7), do: "seven Swans-a-Swimming"
  defp element(8), do: "eight Maids-a-Milking"
  defp element(9), do: "nine Ladies Dancing"
  defp element(10), do: "ten Lords-a-Leaping"
  defp element(11), do: "eleven Pipers Piping"
  defp element(12), do: "twelve Drummers Drumming"
end
