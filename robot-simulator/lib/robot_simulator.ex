defmodule RobotSimulator do
  @moduledoc false

  @cc_directions [:north, :east, :south, :west]

  defguard correct_dir(dir) when dir in @cc_directions
  defguard positions_are_int(a, b) when is_integer(a) and is_integer(b)

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`

  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, {a, b}) when correct_dir(direction) and positions_are_int(a, b) do
    %{dir: direction, pos: {a, b}}
  end

  def create(direction, _) when correct_dir(direction), do: {:error, "invalid position"}
  def create(_, _), do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.codepoints()
    |> Enum.reduce_while(robot, fn instruction, acc ->
      %{dir: dir, pos: pos} = acc
      dir_idx = Enum.find_index(@cc_directions, &(&1 == dir))

      case instruction do
        "R" ->
          # new_dir =
          {:cont, %{dir: Enum.at(@cc_directions, rem(dir_idx + 1, 4)), pos: pos}}

        "L" ->
          # new_dir =
          {:cont, %{dir: Enum.at(@cc_directions, rem(dir_idx - 1, 4)), pos: pos}}

        "A" ->
          Map.update!(acc, :pos, fn {x, y} ->
            case acc.dir do
              :north -> {x, y + 1}
              :east -> {x + 1, y}
              :south -> {x, y - 1}
              :west -> {x - 1, y}
            end
          end)
          |> (&{:cont, &1}).()

        _ ->
          {:halt, {:error, "invalid instruction"}}
      end
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.dir
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.pos
  end
end
