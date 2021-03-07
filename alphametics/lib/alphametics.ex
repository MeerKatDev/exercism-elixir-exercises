defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

      iex> Alphametics.solve("I + BB == ILL")
      %{?I => 1, ?B => 9, ?L => 0}

      iex> Alphametics.solve("A == B")
      nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    [total, "==" | others] = String.split(puzzle) |> Enum.reverse()
    total_len = byte_size(total)
    terms = Enum.reject(others, &(&1 == "+")) |> Enum.map(&to_charlist/1)
    terms_max_len = Enum.map(terms, &Enum.max/1) |> Enum.max()

    cond do
      (total_len == 1 && length(terms) == 1) ||
          terms_max_len > total_len ->
        nil

      true ->
        find_numbers(terms, to_charlist(total))
    end
  end

  defp generate_initial_pairings(total, n, l) do
    uniq = Enum.uniq(total)
    Enum.zip(uniq, n..(9-length(uniq)))
  end

  # charlist, charlist -> ?
  defp find_numbers(terms, total) do
    for n <- 9..0, l <- 9..0, n != l, do: {n, l}

    starting_dict = generate_initial_pairings(total)
    Enum.reduce(terms, fn x, acc ->

    end)
  end

end
