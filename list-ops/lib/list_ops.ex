defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    rec_count(l)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    rec_reverse(l)
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    rec_map(l, f)
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    rec_filter(l, f)
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f) do
    rec_reduce(l, f, acc)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    appendl(a, b)
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    ll
    |> reverse()
    |> reduce([], &append(&1, &2))
  end

  defp rec_count(a, acc \\ 0)
  defp rec_count([], acc), do: acc
  defp rec_count([_h | t], acc), do: rec_count(t, acc + 1)

  defp rec_reverse(a, acc \\ [])
  defp rec_reverse([], acc), do: acc
  defp rec_reverse([h | t], acc), do: rec_reverse(t, [h | acc])

  defp rec_map(a, b, acc \\ [])
  defp rec_map([], _f, acc), do: rec_reverse(acc)
  defp rec_map([h | t], f, acc), do: rec_map(t, f, [f.(h) | acc])

  defp rec_filter(a, b, acc \\ [])
  defp rec_filter([], _f, acc), do: rec_reverse(acc)

  defp rec_filter([h | t], f, acc),
    do: rec_filter(t, f, (f.(h) && [h | acc]) || acc)

  # acc is -always- given
  defp rec_reduce([], _f, acc), do: acc
  defp rec_reduce([h | t], f, acc), do: rec_reduce(t, f, f.(h, acc))

  defp append_list([head | tail], b), do: [head | append_list(tail, b)]
  defp append_list([], b), do: b

  defp appendl([], []), do: []
  defp appendl([], b), do: b
  defp appendl(a, []), do: a
  defp appendl(a, b), do: append_list(a, b)
end
