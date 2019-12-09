defmodule Intcode do
  @moduledoc """
  Documentation for the Intcode computer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Intcode.run([99])
      [99]
      iex> Intcode.run([1,0,0,0,99])
      [2,0,0,0,99]
      iex> Intcode.run([1,1,1,4,99,5,6,0,99])
      [30,1,1,4,2,5,6,0,99]

  """
  def run(program, position \\ 0)

  def run(program, :halt), do: program

  def run(program, position) do
    {next_state, next_position} =
      program
      |> Enum.at(position)
      |> do_op(program, position)

    run(next_state, next_position)
   end

  def do_op(99, program, _position) do
    {program, :halt}
  end

  @doc """
  opcode 1 - Add

    ## Examples

      iex> Intcode.do_op(1, [1,0,0,0,99], 0)
      {[2,0,0,0,99], 4}

  """
  def do_op(1, program, position) do
    [noun_index, verb_index, write_to] = Enum.slice(program, position+1..position+3)
    noun = Enum.at(program, noun_index)
    verb = Enum.at(program, verb_index)
    new_program_state = List.replace_at(program, write_to, noun + verb)
    {new_program_state, position + 4}
  end

  @doc """
  opcode 1 - Multiply

    ## Examples

      iex> Intcode.do_op(2, [2,3,0,3,99], 0)
      {[2,3,0,6,99], 4}
      iex> Intcode.do_op(2, [2,4,4,5,99,0], 0)
      {[2,4,4,5,99,9801], 4}

  """
  def do_op(2, program, position) do
    [noun_index, verb_index, write_to] = Enum.slice(program, position+1..position+3)
    noun = Enum.at(program, noun_index)
    verb = Enum.at(program, verb_index)
    new_program_state = List.replace_at(program, write_to, noun * verb)
    {new_program_state, position + 4}
  end
end
