defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @default_names ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    import Enum

    [fst_row, snd_row] =
      String.split(info_string, "\n")
      |> map(&to_charlist/1)

    student_names
    |> sort
    |> with_index
    |> into(%{}, fn
      {v, k} when k * 2 + 1 <= length(fst_row) ->
        {v,
         {
           at(fst_row, k * 2) |> veg(),
           at(fst_row, k * 2 + 1) |> veg(),
           at(snd_row, k * 2) |> veg(),
           at(snd_row, k * 2 + 1) |> veg()
         }}

      {v, _k} ->
        {v, {}}
    end)
  end

  defp veg(?V), do: :violets
  defp veg(?C), do: :clover
  defp veg(?R), do: :radishes
  defp veg(?G), do: :grass
end
