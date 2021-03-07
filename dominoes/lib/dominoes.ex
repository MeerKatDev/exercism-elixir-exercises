defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true
  def chain?([{a, a}]), do: true
  def chain?([{_a, _b}]), do: false
  def chain?(dominoes) do
    Enum.map(dominoes, fn x ->
      {x, Enum.filter(dominoes, &compatible?(&1, x))}
      # Enum.filter(dominoes, &compatible?(&1, x))
    end)
    |> IO.inspect
    |> case do
      x ->
        if Enum.any?(x, &(match?({_, []}, &1))) do
          false
        else
          total_len = length(x)
          tmp = Enum.filter(x, fn {_, li} ->
            length(li) == 2
          end)
          # IO.inspect(tmp)
          # IO.inspect(elem(Enum.at(tmp,0),0))
          # IO.inspect(elem(Enum.at(tmp,1),0))
          # IO.inspect(compatible?(elem(Enum.at(tmp,0),0), elem(Enum.at(tmp,1),0)))
          # length(tmp) <= 2 || compatible?(elem(Enum.at(tmp,0),0), elem(Enum.at(tmp,1),0))

        end
      _ -> true
    end
  end
  # can't be equal
  defp compatible?(a, a), do: false
  defp compatible?({l1, r1}, {l2, r2}) when l1 == l2 or l1 == r2 or r2 == r1 or l2 == r1, do: true
  defp compatible?(_, _), do: false
end
