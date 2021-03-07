defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    valid_number = String.replace(number, " ", "")
    if valid_number =~ ~r"^[0-9]*$" && byte_size(valid_number) > 1  do
      valid_number
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.map(&String.to_integer/1)
      |> case do
        [check | digits] ->
          digits
          |> Enum.with_index()
          |> Enum.map(fn
            {v, k} when rem(k, 2) == 0 ->
              v in 0..4 && 2 * v || (2 * v - 9)
            {v, _k} -> v
          end)
          |> Enum.sum()
          |> (&(rem(&1 + check,10) == 0)).()
      end
    else
      false
    end
  end
end
