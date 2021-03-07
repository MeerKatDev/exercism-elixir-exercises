defmodule Patterns do
  def full_house([
        <<a::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<c::bytes-1>> <> _,
        <<d::bytes-1>> <> _,
        <<e::bytes-1>> <> _
      ]) do
    case [a, b, c, d, e] do
      [a, a, b, b, b] -> 7 + to_numbers(b) / 100
      [a, a, a, b, b] -> 7 + to_numbers(a) / 100
      # three of a kind
      [a, a, a, _b, _c] -> 4
      [_b, _c, a, a, a] -> 4
      [_b, a, a, a, _c] -> 4
      _ -> 0
    end
  end

  def four_of_a_kind([
        <<_a::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _
      ]) do
    8 + to_numbers(b) / 100
  end

  def four_of_a_kind([
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<_a::bytes-1>> <> _
      ]) do
    8 + to_numbers(b) / 100
  end

  def four_of_a_kind(_), do: 0

  def flush([
        <<a::bytes-1>> <> x,
        <<b::bytes-1>> <> x,
        <<c::bytes-1>> <> x,
        <<d::bytes-1>> <> x,
        <<e::bytes-1>> <> x
      ]) do
    (are_cards_consecutive?([a, b, c, d, e]) && 9) || 6
  end

  def flush(_), do: 0

  # malus to counterbalance the fact that the ace here has less value
  def straight(["2" <> _, "3" <> _, "4" <> _, "5" <> _, "A" <> _]), do: 4.80

  def straight([
        <<a::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<c::bytes-1>> <> _,
        <<d::bytes-1>> <> _,
        <<e::bytes-1>> <> _
      ]) do
    (are_cards_consecutive?([a, b, c, d, e]) && 5.01) || 0
  end

  def straight(_), do: 0

  def two_pairs([
        <<a::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<c::bytes-1>> <> _,
        <<d::bytes-1>> <> _,
        <<e::bytes-1>> <> _
      ]) do
    case [a, b, c, d, e] do
      [a, a, b, b, _] -> 3 + to_numbers(a) / 100 + to_numbers(b) / 100
      [_, a, a, b, b] -> 3 + to_numbers(a) / 100 + to_numbers(b) / 100
      [a, a, _, b, b] -> 3 + to_numbers(a) / 100 + to_numbers(b) / 100
      _ -> 0
    end
  end

  def one_pair([
        <<a::bytes-1>> <> _,
        <<b::bytes-1>> <> _,
        <<c::bytes-1>> <> _,
        <<d::bytes-1>> <> _,
        <<e::bytes-1>> <> _
      ]) do
    case [a, b, c, d, e] do
      [a, a, _, _, _] -> 2
      [_, a, a, _, _] -> 2
      [_, _, a, a, _] -> 2
      [_, _, _, a, a] -> 2
      _ -> 0
    end
  end

  def to_numbers(e) do
    case e do
      "X" -> 10
      "J" -> 11
      "Q" -> 12
      "K" -> 13
      "A" -> 14
      n when is_binary(n) -> String.to_integer(n)
      n -> n
    end
  end

  defp are_cards_consecutive?(nums) do
    ints = Enum.map(nums, &to_numbers/1)
    Enum.at(ints, 0) + 4 == Enum.at(ints, -1)
  end
end
