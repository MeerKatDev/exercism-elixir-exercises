defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number not in 1..64 do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  def square(number) do
    {:ok, floor(:math.pow(2, number - 1))}
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    Enum.reduce(1..64, 1, fn _x, acc ->
      2 * acc
    end)
    |> (&({:ok, &1 - 1})).()
  end

end
