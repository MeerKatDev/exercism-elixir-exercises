defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    digits = String.replace(isbn, "-", "")
    if byte_size(digits) != 10
      or String.last(digits) =~ ~r"[^0-9X:]"
      or String.slice(digits, 0..-2) =~ ~r"[^0-9:]"
    do
      false
    else
      is_isbn_valid?(digits)
    end
  end

  # input a list
  defp is_isbn_valid?(isbn) do
    isbn
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {"X", k}, acc -> 10 * (10-k) + acc
      {v, k}, acc ->  String.to_integer(v) * (10 - k) + acc
    end)
    |> rem(11)
    |> (&(&1 == 0)).()
  end
end
