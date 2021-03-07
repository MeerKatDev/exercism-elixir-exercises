defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    String.replace(sentence, ~r/[^a-zA-Zö0-9-_]+/, " ")
    |> String.split([" ", "_"], trim: true)
    |> Enum.reduce(%{}, &update_map(&2, String.downcase(&1))) # unreadable but nice
  end

  defp update_map(acc, xn) do
    case acc do
      %{^xn => _sth} ->
        Map.update!(acc, xn, &(&1 + 1))
      _ ->
        Map.put(acc, xn, 1)
    end
  end
end
