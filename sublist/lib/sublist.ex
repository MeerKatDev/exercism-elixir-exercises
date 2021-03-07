defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a), do: :equal
  def compare([], _b), do: :sublist
  def compare(_a, []), do: :superlist
  def compare(a, b) when length(a) > length(b) do
    length(a -- b) == length(a) && :unequal || :superlist
  end
  def compare(a, b) when length(b) > length(a) do
    diff = b -- a
    length(diff) == length(b) && :unequal || :sublist
  end
  def compare(_a, _b), do: :unequal
end
