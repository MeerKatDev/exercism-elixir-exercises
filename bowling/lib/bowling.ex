defmodule Bowling do
  # prev_frame {roll before previous, previous roll}
  defstruct frame: 0, score: 0, prev_frame: {nil,nil}
  @type game :: struct

  # frames are actually half frames
  @max_frames 20
  @max_pins 10
  @max_score 300

  defguard sum_above_max(last, roll) when last + roll > @max_pins
  defguard overgame?(frame) when frame > @max_frames - 1
  defguard ingame?(frame) when frame < @max_frames - 1
  defguard pins_wrong?(frame, last, roll) when roll > @max_pins
    or (rem(frame, 2) == 1 and sum_above_max(last, roll) and last < @max_pins)
    or (overgame?(frame) and sum_above_max(last, roll) and last < @max_pins and roll != @max_pins)
  defguard is_spare?(fst, snd, frame) when fst + snd == @max_pins and ingame?(frame) and rem(frame, 2) == 0
  defguard game_over?(fst, snd, frame) when overgame?(frame) and fst + snd < @max_pins
  defguard cannot_take_score?(fst, snd, frame, score) when ((frame < @max_frames and score == 0)
    or (frame <= @max_frames and fst + snd >= @max_pins)) and score < @max_score

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: game
  def start do
    %Bowling{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(game, integer) :: game | String.t()
  def roll(_, roll) when roll < 0,
  do: {:error, "Negative roll is invalid"}
  def roll(%Bowling{frame: frame, prev_frame: {fst, snd}}, _) when game_over?(fst, snd, frame),
  do: {:error, "Cannot roll after game is over"}
  def roll(%Bowling{frame: @max_frames, prev_frame: {@max_pins, snd}}, @max_pins) when snd < @max_pins,
  do: {:error, "Pin count exceeds pins on the lane"}
  def roll(%Bowling{frame: frame, prev_frame: {_, snd}}, roll) when pins_wrong?(frame, snd, roll),
  do: {:error, "Pin count exceeds pins on the lane"}
  def roll(%Bowling{frame: frame, score: score, prev_frame: {fst, snd}}, roll) do
    %Bowling{
      frame: frame + 1,
      score: score + calc_score(frame, fst, snd, roll),
      prev_frame: {snd, roll}
    }
  end

  defp calc_score(frame, @max_pins, snd, roll) when ingame?(frame), do: roll * 2 + snd
  defp calc_score(frame, fst, @max_pins, roll) when ingame?(frame) and fst < @max_pins, do: roll * 2
  defp calc_score(frame, fst, snd, roll) when is_spare?(fst, snd, frame), do: roll * 2
  defp calc_score(_, _, _, roll), do: roll

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(game) :: integer | String.t()
  def score(%Bowling{frame: frame, score: score, prev_frame: {fst, snd}}) when cannot_take_score?(fst, snd, frame, score) do
    {:error, "Score cannot be taken until the end of the game"}
  end
  def score(game) do
    min(game.score, @max_score)
  end
end
