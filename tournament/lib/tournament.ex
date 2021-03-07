defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  import Enum

  @possible_values ["loss", "draw", "win"]
  @initial_map %{played: 1, win: 0, draw: 0, loss: 0}
  @table_header "#{String.pad_trailing("Team", 31)}| MP |  W |  D |  L |  P\n"

  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    map(input, &String.split(&1, ";"))
    |> reduce(%{}, fn
      [team1, team2, res], acc when res in @possible_values ->
        key = String.to_atom(res)
        acc
        |> Map.update(team1, init_val(key), &update(&1, key))
        |> Map.update(team2, init_val(inv(key)), &update(&1, inv(key)))
      _, acc ->
        acc
    end)
    |> (fn map ->
      @table_header <>
       (map
       |> sort(&(pts(&1) >= pts(&2)))
       # formats for presentation, or for the tests
       |> map_join("\n", fn {k, v} ->
         ~s(#{String.pad_trailing(k, 31)}|  #{v.played} |  #{v.win} |  #{v.draw} |  #{v.loss} |  #{
           pts(v)
         })
       end))
    end).()
  end
  # converts statistics to points
  defp pts({_k, v}), do: v.win * 3 + v.draw
  defp pts(v), do: pts({nil, v})
  # inverts outcome for the second team in the tuple
  defp inv(:win), do: :loss
  defp inv(:loss), do: :win
  defp inv(:draw), do: :draw
  # updates the map depending on the outcome
  defp init_val(key), do: merge_with_sum(@initial_map, %{key => 1})
  defp update(current, key), do: merge_with_sum(current, %{:played => 1, key => 1})

  defp merge_with_sum(map1, map2), do: Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)
end
