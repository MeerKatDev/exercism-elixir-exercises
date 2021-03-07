defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @alphabet_length 26
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> String.codepoints()
    |> Enum.map(fn <<c::utf8>> ->
      <<transpose_ascii_code(c, shift)::utf8>>
    end)
    |> Enum.join()
  end

  defp transpose_ascii_code(c, shift) when c in ?A..?Z do
    (rem(c + shift - ?A, @alphabet_length) + ?A)
  end
  defp transpose_ascii_code(c, shift) when c in ?a..?z do
    (rem(c + shift - ?a, @alphabet_length) + ?a)
  end
  defp transpose_ascii_code(c, _shift), do: c
end
