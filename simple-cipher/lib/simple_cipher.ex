defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key) do
    cypher(plaintext, key, &Kernel.+/2)
  end

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    cypher(ciphertext, key, &Kernel.-/2)
  end

  defp cypher(text, key, op) do
    text
    |> to_charlist
    |> Enum.zip(adapt_key_to_text(text, key))
    |> Enum.map(fn {ch, k} ->
      (ch < ?a && ch) || offset_by_a(op.(ch, k))
    end)
    |> List.to_string()
  end

  defp offset_by_a(res), do: (res < ?a && 26 + res) || res

  defp adapt_key_to_text(text, key) do
    key
    |> to_charlist()
    |> Enum.map(&(&1 - ?a))
    |> Stream.cycle()
    |> Enum.take(byte_size(text))
  end
end
