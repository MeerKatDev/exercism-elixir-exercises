defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """
  @is_hexadecimal ~r"^[a-f0-9]+$"i
  @offset_with_letters 87
  @offset_with_numbers 48

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    if hex =~ @is_hexadecimal do
      len = byte_size(hex)
      hex
      |> String.downcase()
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(0, fn
        {"0", _k}, acc ->
          0 + acc
        {<<c::utf8>>, k}, acc  ->
          sub_offset(c) * :math.pow(16, len - 1 - k) + acc
      end)
    else
      0
    end
  end

  defp sub_offset(c) when c in ?1..?9, do: c - @offset_with_numbers
  defp sub_offset(c), do: c - @offset_with_letters
end
