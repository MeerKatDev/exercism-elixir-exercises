defmodule Allergies do
  @allergens %{
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }
  @powers Enum.map(7..0, &(:math.pow(2, &1) |> round()))
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) when flags > 255, do: list(253)

  def list(flags) do
    Enum.reduce(@powers, {flags, []}, fn x, {acc, allg} ->
      new_acc = acc - x
      (new_acc >= 0 && {new_acc, [@allergens[x] | allg]}) || {acc, allg}
    end)
    |> elem(1)
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    item in list(flags)
  end
end
