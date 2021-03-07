defmodule PigLatin do
  @vowels ["a", "e", "i", "o", "u"]
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    String.split(phrase)
    |> Enum.map_join(" ", &translate_word/1)
  end

  defp translate_word(word = <<dg::bytes-1>> <> _) when dg in @vowels, do: "#{word}ay"
  defp translate_word(word = "y" <> <<dg::bytes-1>> <> _) when dg not in @vowels, do: "#{word}ay"
  defp translate_word(word = <<dg::bytes-2>> <> _) when dg in ["xr", "xb"], do: "#{word}ay"

  defp translate_word(word) do
    word
    |> String.codepoints()
    |> Enum.reduce_while([], fn
      "u", ["q" | t] ->
        {:halt, form_pig_word(["u", "q"] ++ t, word)}
      letter, acc when letter in @vowels ->
        {:halt, form_pig_word(acc, word)}
      letter, acc ->
        {:cont, [letter | acc]}
    end)
  end

  def form_pig_word(acc, word) do
    init = acc |> Enum.reverse() |> Enum.join()
    String.slice(word, byte_size(init)..byte_size(word)) <> init <> "ay"
  end
end
