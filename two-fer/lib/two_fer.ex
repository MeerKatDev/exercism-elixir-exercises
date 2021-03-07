defmodule TwoFer do
  @doc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(), do: "One for you, one for me"
  def two_fer(str) when not is_binary(str), do: raise FunctionClauseError
  def two_fer(str), do: "One for #{str}, one for me"
end
