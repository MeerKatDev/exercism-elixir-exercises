defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct map: []

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %__MODULE__{map: Enum.uniq(enumerable)}
  end

  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{map: custom_set}) do
    length(custom_set) == 0
  end

  @spec contains?(t, any) :: boolean
  def contains?(%__MODULE__{map: custom_set}, element) do
    element in custom_set
  end

  @spec subset?(t, t) :: boolean
  def subset?([], _), do: true

  def subset?(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    Enum.all?(custom_set_1, &(&1 in custom_set_2))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?([], _), do: true
  def disjoint?(_, []), do: true

  def disjoint?(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    !Enum.any?(custom_set_1, &(&1 in custom_set_2))
  end

  @spec equal?(t, t) :: boolean
  def equal?(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    Enum.sort(custom_set_1) == Enum.sort(custom_set_2)
  end

  @spec add(t, any) :: t
  def add(%__MODULE__{map: custom_set}, element) do
    [element | custom_set] |> new()
  end

  @spec intersection(t, t) :: t
  def intersection(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2})
      when length(custom_set_1) >= length(custom_set_2) do
    custom_set_1
    |> Enum.filter(&(&1 in custom_set_2))
    |> new()
  end

  def intersection(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    custom_set_2
    |> Enum.filter(&(&1 in custom_set_1))
    |> new()
  end

  @spec difference(t, t) :: t
  def difference(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    custom_set_1
    |> Enum.reject(&(&1 in custom_set_2))
    |> new()
  end

  @spec union(t, t) :: t
  def union(%__MODULE__{map: custom_set_1}, %__MODULE__{map: custom_set_2}) do
    (custom_set_1 ++ custom_set_2) |> new()
  end
end
