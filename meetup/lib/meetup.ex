defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """
  @type weekday :: :monday | :tuesday | :wednesday | :thursday | :friday | :saturday | :sunday
  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @regulars [:first, :second, :third, :fourth]

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    get_range(schedule)
    |> Enum.find(&weekday(weekday, Date.new(year, month, &1)))
    |> (&Date.new!(year, month, &1)).()
  end

  defp get_range(:teenth), do: 13..19
  defp get_range(:last), do: 31..21

  defp get_range(schedule) when schedule in @regulars do
    (7 * Enum.find_index(@regulars, &(&1 == schedule)) + 1)
    |> (&(&1..(&1 + 6))).()
  end

  defp weekday(_, {:error, _}), do: false

  defp weekday(weekday, {:ok, date}) do
    Calendar.strftime(date, "%A")
    |> String.downcase()
    |> String.to_atom()
    |> (&(&1 == weekday)).()
  end
end
