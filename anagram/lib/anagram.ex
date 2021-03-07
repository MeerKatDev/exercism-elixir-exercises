defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    sorted_base = sort_letters(base)
    candidates
    |> Enum.filter(fn word ->
      String.downcase(word) != String.downcase(base)
        and sort_letters(word) == sorted_base
    end)
  end

  defp sort_letters(word) do
    word
    |> String.downcase
    |> String.codepoints()
    |> Enum.sort()
  end
end
