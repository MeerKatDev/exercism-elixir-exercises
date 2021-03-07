defmodule Zipper do
  @type t :: {BinTree.t(), []}
  defstruct [:node, :data]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{node: bin_tree, data: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{node: node, data: []}), do: node
  def to_tree(zipper), do: to_tree(up(zipper))

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{node: nil, data: _}), do: nil
  def value(%Zipper{node: node, data: _}), do: node.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{node: %{left: nil}, data: _}), do: nil

  def left(%Zipper{node: node, data: path}) do
    new_left_data = {%{node | left: nil}, :left}
    %Zipper{node: node.left, data: [new_left_data | path]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{node: %{right: nil}, data: _}), do: nil

  def right(%Zipper{node: node, data: path}) do
    new_right_data = {%{node | right: nil}, :right}
    %Zipper{node: node.right, data: [new_right_data | path]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{node: _, data: []}), do: nil

  def up(%Zipper{node: node, data: [{parent_node, pos} | tail]}) do
    %Zipper{node: %{parent_node | "#{pos}": node}, data: tail}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value), do: set(:value, zipper, value)

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, value), do: set(:left, zipper, value)

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, value), do: set(:right, zipper, value)

  defp set(pos, %Zipper{node: node, data: path}, value) do
    %Zipper{node: %{node | "#{pos}": value}, data: path}
  end
end
