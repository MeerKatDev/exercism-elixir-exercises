defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @some_special_chars ~r"[_,-]"
   # substitute sandwiched hyphen
  @sandwiched_hyphen ~r"(?<=\w)-(?=\w)"
  # deals with HyperText and excludes phrases with "GNU"
  @one_uppercase_in_middle ~r"(?<=\w)+[A-Z].*|^([A-Z]{2,}).*"

  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.replace(@sandwiched_hyphen, " ")
    |> String.replace(@one_uppercase_in_middle, " \\0")
    |> String.replace(@some_special_chars, "")
    |> String.split(" ")
    |> Enum.map(&String.first/1)
    |> Enum.join()
    |> String.upcase()
  end
end
