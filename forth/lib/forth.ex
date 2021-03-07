defmodule Forth do
  @opaque evaluator :: {list, map}

  @allowed_symbols ~r{[^a-z0-9+-/*]}i
  @arithmetic_ops ["+", "-", "*", "/"]
  @stack_ops ["DUP", "DROP", "SWAP", "OVER"]

  @doc """
  Create a new evaluator.
  The evaluator has the result string on the left
  and the newly defined commands on the right
  """
  @spec new() :: evaluator
  def new() do
    {[], %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval({res, custom}, ": " <> declaration) do
    [new_cmd | rest] = String.split(declaration, " ")
    # get both the old commands to be used and the terms after the ;
    {cmds, [";" | other_res]} = Enum.split_while(rest, fn x -> x != ";" end)
    # if the new command is a number, raise an error
    if is_tuple(Integer.parse(new_cmd)), do: raise(Forth.InvalidWord)
    # join the new command keying a string composed of the old commands
    new_custom = Map.merge(custom, %{new_cmd => Enum.join(cmds, " ")})
    # use already the new commands, before the next eval
    replaced_cmds = Enum.map(other_res, &integrate_custom(&1, new_custom))
    {res ++ replaced_cmds, new_custom}
  end

  def eval({res, custom}, s) do
    instr = res ++ parse(integrate_custom(s, custom))

    Enum.reduce(instr, [], fn x, acc ->
      try do
        handle_operation(x, acc)
      rescue
        # when it cannot pattern match the arguments in `handle_operation`
        _ in FunctionClauseError -> raise Forth.StackUnderflow
      end
    end)
    |> Enum.reverse()
    |> (&{&1, custom}).()
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack({res, _custom}) do
    Enum.join(res, " ")
  end

  defp integrate_custom(str, custom) when custom == %{}, do: str

  defp integrate_custom(str, custom) do
    Enum.reduce(custom, str, fn {k, v}, acc ->
      String.replace(acc, k, v)
    end)
  end

  defp handle_operation(x, [x2, x1 | t]) when x in @arithmetic_ops,
    do: [arithmetic_op(x1, x, x2) | t]

  defp handle_operation("DUP", [x1 | t]), do: [x1, x1] ++ t
  defp handle_operation("DROP", [_ | t]), do: t
  defp handle_operation("OVER", [x2, x1 | t]), do: [x1, x2, x1] ++ t
  defp handle_operation("SWAP", [x2, x1 | t]), do: [x1, x2] ++ t

  defp handle_operation(x, acc) when x not in @stack_ops do
    case Integer.parse(x) do
      {i, ""} -> [i | acc]
      :error -> raise Forth.UnknownWord
    end
  end

  defp arithmetic_op(x1, x, x2) do
    case x do
      "+" -> x1 + x2
      "-" -> x1 - x2
      "*" -> x1 * x2
      "/" when x2 == 0 -> raise Forth.DivisionByZero
      "/" -> div(x1, x2)
    end
  end

  defp parse(str) do
    str
    |> String.upcase()
    |> String.replace(" ", " ")
    |> String.split(@allowed_symbols)
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
