defmodule SaddlePoints do
  import Enum

  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """

  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")
    |> map(fn r ->
      r
      |> String.split(" ")
      |> map(&String.to_integer/1)
    end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    r = rows(str)
    dim = r |> hd() |> length()

    map(0..(dim - 1), fn x ->
      r
      |> List.flatten()
      |> drop(x)
      |> take_every(dim)
    end)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rs = rows(str)
    cs = columns(str)

    for {r, i} <- with_index(rs),
        {c, j} <- with_index(cs),
        max(r) == min(c) do
      {i, j}
    end
  end
end
