defmodule SecretHandshake do
  use Bitwise

  @dict %{
    1 => "wink",
    2 => "double blink",
    4 => "close your eyes",
    8 => "jump"
  }

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) when (code &&& 16) == 0, do: reduce(code)
  def commands(code), do: reduce(code) |> Enum.reverse()

  defp reduce(code) do
    for {p, action} <- @dict, (code &&& p) != 0, do: action
  end
end
