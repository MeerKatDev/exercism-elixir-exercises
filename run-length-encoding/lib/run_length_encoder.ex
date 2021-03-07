defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(string) do
    string
    |> String.codepoints()
    |> Enum.reduce([{0, ""}], fn x, [last | t] = acc ->
      {cn, ch} = last

      if ch == x or ch == "" do
        [{cn + 1, x} | t]
      else
        [{1, x} | acc]
      end
    end)
    |> Enum.reverse()
    |> Enum.map(fn
      {1, ch} -> ch
      {cn, ch} -> "#{cn}#{ch}"
    end)
    |> Enum.join()
  end

  @spec decode(String.t()) :: String.t()
  def decode(""), do: ""

  def decode(string) do
    string
    |> String.codepoints()
    |> Enum.reduce([""], fn x, [last | t] = acc ->
      case Integer.parse(x) do
        {cn, _fl} when is_number(last) ->
          [String.to_integer("#{last}#{cn}") | t]

        {cn, _fl} when is_binary(last) ->
          [cn | acc]

        :error when is_binary(last) ->
          [x | acc]

        :error when is_number(last) ->
          [gen_chars_string(x, last) | t]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp gen_chars_string(x, n), do: List.duplicate(x, n) |> Enum.join()
end
