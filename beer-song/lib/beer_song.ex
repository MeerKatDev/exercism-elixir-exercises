defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(0) do
    """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
  end
  def verse(number) do
    """
    #{number} bottle#{plural?(number)} of beer on the wall, #{number} bottle#{plural?(number)} of beer.
    Take #{number==1&&"it"||"one"} down and pass it around, #{number==1&&"no more"||number-1} bottle#{plural?(number-1)} of beer on the wall.
    """
  end

  defp plural?(1), do: ""
  defp plural?(_), do: "s"

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    Enum.map(range, &verse/1) |> Enum.join("\n")
  end
end
