defmodule MatchingBrackets do
  @not_a_bracket ~r"[^()\[\]{}]"
  @opening_brackets [ ?(, ?{, ?[ ]

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    only_pars = String.replace(str, @not_a_bracket, "")

    only_pars
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.map_reduce([], fn {x, i}, acc ->
      if x in @opening_brackets do
        {{x, i}, [i | acc]}
      else
        {{x, -1}, acc} # opening brackets are assigned indices
      end
    end)
    |> (fn {li, idxs} -> # idxs is ordered from max to min
      if length(li) == length(idxs)*2 do # the opening brackets have to be 1/2 of the total length
        Enum.reduce(idxs, li, fn idx, acc ->
          {_hd, tl} = Enum.split(acc, idx)
          first_on_right = Enum.find_index(tl, &(elem(&1, 1) == -1)) # how to get a default?
          closing_p_idx = idx + (is_nil(first_on_right) && 0 || first_on_right) # some issue here
          opening_p = elem(Enum.at(acc,idx), 0)
          List.replace_at(acc, closing_p_idx, {get_closing_bracket(opening_p), closing_p_idx})
        end)
      else
        [{0, 0}]
      end
    end).()
    |> Enum.unzip()
    |> (&(List.to_string(elem(&1, 0)) == only_pars)).()
  end

  # unluckily, it's not simply +1
  defp get_closing_bracket(code) do
    case code do
      ?( -> ?)
      ?[ -> ?]
      ?{ -> ?}
    end
  end
end
