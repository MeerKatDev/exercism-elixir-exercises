defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2),
  do: {:error, "Lists must be the same length"}

  def hamming_distance(strand1, strand2) do
    {:ok, rec(0, strand1, strand2)}
  end

  defp rec(acc, [], []), do: acc
  defp rec(acc, [h1 | t1], [h2 | t2]),
  do: rec(h1 != h2 && acc + 1 || acc, t1, t2)
end
