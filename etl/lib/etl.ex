defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"aardvark" => "a", "ability" => "a", "ballast" => "b", "beauty" => "b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Enum.reduce([], fn {k, v}, acc ->
      Enum.map(v, &({String.downcase(&1), k})) ++ acc
    end)
    |> Map.new()

  end
end
