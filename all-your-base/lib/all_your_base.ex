defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """
  alias __MODULE__.SimpleState, as: Holder

  @spec convert(list, integer, integer) :: list | nil
  def convert(digits, _base_a, base_b) do
    dg_to_convert = String.to_integer(Enum.join(digits))
    IO.inspect(dg_to_convert)
    Holder.start_link([base_b, dg_to_convert])
    power = round(log(dg_to_convert, base_b))
    rec(dg_to_convert, digits, [], power)
    |> Enum.reverse()
  end

  defp new_base_to_power(pow),
  do: round(:math.pow(Holder.base(),pow))

  defp log(x, 10), do: :math.log10(x)
  defp log(x, 2), do: :math.log2(x)
  defp log(x, b), do: :math.log2(x)/:math.log2(b)

  defp rec(_, _, acc, -1), do: acc
  defp rec(res, _digits, acc, idx) do
    #[_h | t] = digits
    order = new_base_to_power(idx)
    diff = res - order
    IO.inspect([res, diff, order, idx,  diff > 0])
    if diff >= 0 do
      rec(diff, 0, [Holder.base() - 1 | acc], idx-1)
    else
      rec(res, 0, [0 | acc], idx-1)
    end
  end

  defmodule SimpleState do
    use Agent

    def start_link([base, value]) do
      Agent.start_link(fn -> %{base: base, value: value} end, name: __MODULE__)
    end

    def value do
      Agent.get(__MODULE__, & &1.value)
    end

    def base do
      Agent.get(__MODULE__, & &1.base)
    end
  end
end
