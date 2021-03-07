defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    {}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(tuple, elem) do
    tuple |> reverse() |> Tuple.append(elem) |> reverse()
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(tuple) do
    tuple_size(tuple)
  end

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(tuple) do
    tuple_size(tuple) == 0
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek(tuple) do
    {:ok, elem(tuple, 0)}
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail(tuple) do
    {:ok, Tuple.delete_at(tuple, 0)}
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop(tuple) do
    el = elem(tuple, 0)
    {:ok, el, Tuple.delete_at(tuple, 0)}
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(tuple()) :: t
  def from_list(tuple) do
    List.to_tuple(tuple)
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: tuple()
  def to_list(tuple) do
    Tuple.to_list(tuple)
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(tuple) do
    tuple |> to_list() |> Enum.reverse() |> from_list()
  end
end
