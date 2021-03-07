defmodule Bob do
  def hey(input) do
    cond do
      String.ends_with?(input,"?") && String.match?(input, ~r/^[^a-z0-9:)]*$/) ->
        "Calm down, I know what I'm doing!"
      String.trim(input) |> String.ends_with?("?") ->
        "Sure."
      String.split(input) == [] ->
        "Fine. Be that way!"
      String.match?(input, ~r/^[,0-9 ]+$/) ->
        "Whatever."
      String.match?(input, ~r/^[^a-z]*$/) ->
        "Whoa, chill out!"
      true ->
        "Whatever."
    end
  end
end
