defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum([a, b, c]) do
    a + b + c
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product([a, b, c]) do
    a * b * c
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    :math.pow(a, 2) + :math.pow(b, 2) == :math.pow(c, 2)
  end

  defp find_permutations_ab_until(min, max) do
    for(
      a <- Enum.to_list(min..(max - 1)),
      b <- Enum.to_list(min..(max - 1)),
      a != b,
      do: {min(a, b), max(a, b)}
    )
    |> Enum.uniq()
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max) do
    perms = find_permutations_ab_until(min, max)

    Enum.reduce(min..max, [], fn c, acc ->
      Enum.flat_map(perms, fn {a, b} ->
        li = [a, b, c]
        (pythagorean?(li) && [li]) || []
      end)
      |> (&(acc ++ &1)).()
    end)
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max, int_sum) do
    perms = find_permutations_ab_until(min, max)

    Enum.reduce(min..max, [], fn c, acc ->
      Enum.flat_map(perms, fn {a, b} ->
        li = [a, b, c]
        (pythagorean?(li) and sum(li) == int_sum && [li]) || []
      end)
      |> (&(&1 ++ acc)).()
    end)
  end
end
