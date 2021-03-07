defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(n :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(n) do
    # needs to be flat_map, not map
    Enum.flat_map(n..1, &[&1, &1])
    |> tl
    |> Enum.reduce({{0, -1}, {0, 1}, []}, fn e, {{x, y}, {ix, iy}, acc} ->
      # this builds side by side, using ix and ix as indicators of "alignment"
      # and x and y as counters
      side =
        for i <- 1..e,
            do: {x + i * ix, y + i * iy}

      {{x + e * ix, y + e * iy}, {iy, -ix}, acc ++ side}
    end)
    |> elem(2)
    |> Enum.with_index(1)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.chunk_every(n)
  end
end
