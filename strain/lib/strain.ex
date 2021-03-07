defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    rec(list, [], fun)
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    rec(list, [], fn x -> !fun.(x) end)
  end


  defp rec([], res, _), do: Enum.reverse(res)
  defp rec([h | t], acc, fun) do
    if fun.(h),
    do: rec(t, [h|acc], fun),
  else: rec(t, acc, fun)
  end
end
