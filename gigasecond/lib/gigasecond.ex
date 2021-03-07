defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  defguard is_leap_year(year) when rem(year, 400) == 0
    or (rem(year, 100) != 0 and rem(year, 4) == 0)

  @gigasecond 1_000_000_000
  @seconds_in_a_year 31_536_000
  @seconds_in_a_day 86_400
  @seconds_in_a_hour 3600
  @months_with_30_days [4, 6, 9, 11]

  def from({{year, month, day}, {hours, minutes, seconds}}) do
    {y, rem_months}  = process_years(year)
    {m, rem_days}    = process_seconds_in_year(rem_months, month, day, leap_year?(year + y))
    {d, rem_hours}   = {div(rem_days, @seconds_in_a_day),   rem(rem_days, @seconds_in_a_day)   }
    {h, rem_minutes} = {div(rem_hours, @seconds_in_a_hour), rem(rem_hours, @seconds_in_a_hour) }
    {min, s} = {div(rem_minutes, 60), rem(rem_minutes, 60)}

    {{year + y + (m < month && 1 || 0), m, d}, {hours + h, minutes + min, seconds + s}}
  end

  defp how_many_leap_years?(years_range),
  do: Enum.count(years_range, &leap_year?/1)

  defp leap_year?(year) when is_leap_year(year), do: true
  defp leap_year?(_year), do: false

  defp process_years(init_year) do
    y = div(@gigasecond, @seconds_in_a_year)
    rem_months = rem(@gigasecond, @seconds_in_a_year)
    days_to_rem = how_many_leap_years?(init_year..(init_year + y - 1)) * @seconds_in_a_day
    eff_rem_months = rem_months - days_to_rem
    {y, eff_rem_months}
  end

  # ugly hack
  defp process_seconds_in_year(seconds, init_month, init_day, is_leap_year?) when is_leap_year? and init_month > 2,
  do: process_seconds_in_year(seconds - @seconds_in_a_day, init_month, init_day, false)

  defp process_seconds_in_year(seconds, init_month, init_day, is_leap_year?) do
    Stream.cycle(1..12)
    |> Stream.drop(init_month-1)
    |> Enum.reduce_while(seconds, fn
      2, acc ->
        days_num = (is_leap_year? && 29 || 28)
        process_month(2, days_num, acc, init_month, init_day)
      x, acc when x in @months_with_30_days ->
        process_month(x, 30, acc, init_month, init_day)
      x, acc ->
        process_month(x, 31, acc, init_month, init_day)
    end)
  end

  defp process_month(init_month, days_num, acc, init_month, init_day) do
    res = acc - ((days_num - init_day) * @seconds_in_a_day)
    res > 0 && {:cont, res} || {:halt, {init_month, acc}}
  end

  defp process_month(month, days_num, acc, _init_month, _init_day) do
    res = acc - (days_num * @seconds_in_a_day)
    res > 0 && {:cont, res} || {:halt, {month, acc}}
  end

end
