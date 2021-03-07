defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  defguard middle_elem_is_eq_key(k, t, l, h) when elem(t, div(h + l, 2)) == k

  defguard(middle_elem_is_gt_key(k, t, l, h) when elem(t, div(h + l, 2)) > k)

  defguard middle_elem_is_lt_key(k, t, l, h) when elem(t, div(h + l, 2)) < k

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _key), do: :not_found

  def search(tuple, key) do
    do_search(tuple, key, 0, tuple_size(tuple))
  end

  defp do_search(_tuple, _key, l, h) when h < l, do: :not_found
  defp do_search(tuple, _key, l, h) when div(h + l, 2) >= tuple_size(tuple), do: :not_found

  defp do_search(tuple, key, l, h) when middle_elem_is_eq_key(key, tuple, l, h),
    do: {:ok, middle(l, h)}

  defp do_search(tuple, key, l, h) when middle_elem_is_gt_key(key, tuple, l, h),
    do: do_search(tuple, key, l, middle(l, h) - 1)

  defp do_search(tuple, key, l, h) when middle_elem_is_lt_key(key, tuple, l, h),
    do: do_search(tuple, key, middle(l, h) + 1, h)

  defp middle(l, h), do: div(h + l, 2)
end
