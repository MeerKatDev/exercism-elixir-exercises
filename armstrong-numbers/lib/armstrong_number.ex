defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) when number < 10, do: true
  def valid?(number) do
    digits = Integer.digits(number)
    len = length(digits)
    res = Enum.reduce(digits, 0, fn v, acc -> round(:math.pow(v, len)) + acc end)
    res == number
  end
end
