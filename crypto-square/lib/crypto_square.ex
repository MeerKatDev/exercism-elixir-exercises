defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> String.downcase()
    |> String.replace(~r"[^a-z\d:]", "")
    |> case do
      "" ->
        ""

      str ->
        cols = calc_cols(str)
        rows = ceil(byte_size(str) / cols)

        li =
          str
          |> String.pad_trailing(cols * rows)
          |> chunk_every(cols)

        Enum.map(0..(cols - 1), &form_vertical_col(li, &1))
        |> Enum.join(" ")
    end
  end

  defp form_vertical_col(li, x) do
    Enum.map(li, &String.at(&1, x))
    |> Enum.join()
    |> String.replace(" ", "")
  end

  defp calc_cols(str), do: byte_size(str) |> :math.sqrt() |> ceil()

  defp chunk_every(str, len) do
    for <<x::binary-size(len) <- str>>, do: x
  end
end
