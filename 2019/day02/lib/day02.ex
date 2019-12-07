defmodule Day02 do
  @moduledoc """
  Documentation for Day02.
  """

  @doc """
  Restore gravity assist program's error state.

  ## Examples

      iex> Day02.part1
      3101878

  """
  def part1 do
    run_gravity_assist_program(12, 2)
  end

  @doc """
  Restore gravity assist program's error state.

  ## Examples

      iex> Day02.part2
      8444

  """
  def part2 do
    for(
      noun <- 0..99,
      verb <- 0..99,
      run_gravity_assist_program(noun, verb) == 19_690_720,
      do: 100 * noun + verb
    )
    |> hd()
  end

  def run_gravity_assist_program(noun, verb) do
    load_gravity_assist_program()
    |> replace_first_sentence(noun, verb)
    |> Intcode.run()
    |> hd()
  end

  def replace_first_sentence(program, noun, verb) do
    program
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def load_gravity_assist_program do
    [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,9,27,1,5,27,31,1,9,31,35,1,35,10,39,2,13,39,43,1,43,9,47,1,47,9,51,1,6,51,55,1,13,55,59,1,59,13,63,1,13,63,67,1,6,67,71,1,71,13,75,2,10,75,79,1,13,79,83,1,83,10,87,2,9,87,91,1,6,91,95,1,9,95,99,2,99,10,103,1,103,5,107,2,6,107,111,1,111,6,115,1,9,115,119,1,9,119,123,2,10,123,127,1,127,5,131,2,6,131,135,1,135,5,139,1,9,139,143,2,143,13,147,1,9,147,151,1,151,2,155,1,9,155,0,99,2,0,14,0]
  end
end
