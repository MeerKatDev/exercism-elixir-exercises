defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1 do
    {:error, "Classification is only possible for natural numbers."}
  end

  def classify(number) do
    if prime?(number) do
      {:ok, :deficient}
    else
      case pf_sum(number) do
        1 -> {:ok, :deficient}
        x when x == number -> {:ok, :perfect}
        x when x > number -> {:ok, :abundant}
        x when x < number -> {:ok, :deficient}
      end
    end
  end

  def pf_sum(a, n \\ 1, acc \\ 0)
  # stop when counter is at one half + 1 of
  def pf_sum(num, n, acc) when div(num, 2) == n - 1, do: acc
  # early exit for abundant numbers
  def pf_sum(num, _, acc) when acc > num, do: acc
  # main branch, sum to acc
  def pf_sum(num, n, acc) when rem(num, n) == 0, do: pf_sum(num, n + 1, acc + n)
  # go on with the search
  def pf_sum(num, n, acc), do: pf_sum(num, n + 1, acc)

  def prime?(n) do
    last = round(:math.sqrt(n))
    not Enum.any?(2..last, &(rem(n, &1) == 0))
  end
end
