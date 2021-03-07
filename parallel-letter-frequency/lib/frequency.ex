defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @all_chars ~r/[\p{L}]/ui
  @all_not_chars ~r/[^\p{L}]/ui
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(Frequency, :count_freq, [], max_concurrency: workers)
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn {:ok, count_map}, acc ->
      Map.merge(count_map, acc, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  def count_freq(str) do
    str
    |> String.replace(@all_not_chars, "")
    |> String.replace(@all_chars, " \\0")
    |> String.split(" ", trim: true)
    |> Enum.frequencies_by(&String.downcase/1)
  end
end
