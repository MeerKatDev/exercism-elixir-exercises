defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  import Patterns

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) when length(hands) == 1, do: hands

  def best_hand(hands) do
    graded_hands =
      Enum.map(hands, fn hand ->
        Enum.sort(hand, &poker_sorting/2)
        |> Enum.map(&ten_to_x/1)
        |> assign_points()
      end)

    tied_hands = highest_key_values(graded_hands)

    if length(tied_hands) > 1 do
      tied_hands
      |> Enum.map(fn x -> {sum_cards(x), x} end)
      |> highest_key_values()
    else
      tied_hands
    end
  end

  defp highest_key_values(hands) do
    max_grade = Enum.max_by(hands, fn {g, _} -> g end) |> elem(0)

    Enum.filter(hands, fn {g, _} -> max_grade == g end)
    |> Enum.map(fn {_, h} -> Enum.map(h, &x_to_ten/1) end)
  end

  # points are assigned dependent on the ranking here:
  # https://en.wikipedia.org/wiki/List_of_poker_hands (10 - rank)
  # floating points are assigned for ties
  defp assign_points(hand) do
    cond do
      flush(hand) != 0 -> flush(hand)
      four_of_a_kind(hand) != 0 -> four_of_a_kind(hand)
      full_house(hand) != 0 -> full_house(hand)
      two_pairs(hand) != 0 -> two_pairs(hand)
      straight(hand) != 0 -> straight(hand)
      one_pair(hand) != 0 -> one_pair(hand)
      true -> 0
    end
    |> (&{&1 + take_higher_card(hand), hand}).()
  end

  defp take_higher_card(hand) do
    hand
    |> Enum.at(-1)
    |> String.at(0)
    |> to_numbers
    |> Kernel./(100)
  end

  defp sum_cards(hand) do
    hand
    |> Enum.map(fn x -> String.at(x, 0) |> to_numbers end)
    |> Enum.sum()
    |> Kernel./(100)
  end

  # introducing X to have a stable number of chars
  defp ten_to_x("10" <> a), do: "X" <> a
  defp ten_to_x(n), do: n

  defp x_to_ten("X" <> a), do: "10" <> a
  defp x_to_ten(n), do: n

  # This is not ideal, the best would be to generate it with a macro
  # true when a < b
  defp poker_sorting("J" <> _, "Q" <> _), do: true
  defp poker_sorting("J" <> _, "K" <> _), do: true
  defp poker_sorting("J" <> _, "A" <> _), do: true
  defp poker_sorting("Q" <> _, "K" <> _), do: true
  defp poker_sorting("Q" <> _, "A" <> _), do: true
  defp poker_sorting("K" <> _, "A" <> _), do: true

  defp poker_sorting("Q" <> _, "J" <> _), do: false
  defp poker_sorting("K" <> _, "J" <> _), do: false
  defp poker_sorting("A" <> _, "J" <> _), do: false
  defp poker_sorting("K" <> _, "Q" <> _), do: false
  defp poker_sorting("A" <> _, "Q" <> _), do: false
  defp poker_sorting("A" <> _, "K" <> _), do: false

  defp poker_sorting(<<a::bytes-1>> <> _, <<a::bytes-1>> <> _), do: true

  defp poker_sorting(a, b) do
    case {Integer.parse(a), Integer.parse(b)} do
      {{x, _}, {y, _}} -> x < y
      {:error, {_, _}} -> false
      {{_, _}, :error} -> true
      {:error, :error} -> raise ArgumentError, "This should not happen"
    end
  end
end
