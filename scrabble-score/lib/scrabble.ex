defmodule Scrabble do
  @points %{
    "A E I O U L N R S T" => 1,
    "D G" => 2,
    "B C M P" => 3,
    "F H V W Y" => 4,
    "K" => 5,
    "J X" => 8,
    "Q Z " => 10
  }
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.trim()
    |> String.upcase()
    |> String.codepoints()
    |> Enum.map(&get_points_for_char/1)
    |> Enum.sum()
  end

  defp get_points_for_char(char) do
    Enum.find(@points, fn {k, _v} ->
      String.contains?(k, char)
    end)
    |> elem(1)
  end
end
