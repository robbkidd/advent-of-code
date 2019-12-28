defmodule Intcode do
  defstruct addresses: {}, position: 0, state: :new

  @moduledoc """
  Documentation for the Intcode computer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> %Intcode{state: :halt} = Intcode.run([99])
      iex> Intcode.run([1,0,0,0,99]) |> Map.get(:addresses) |> Map.get(0)
      2
      iex> Intcode.run([1,1,1,4,99,5,6,0,99]) |> Map.get(:addresses) |> Map.get(0)
      30

  """
  def run(program) when is_list(program) do
    addresses = program
                |> Enum.with_index()
                |> Enum.into(Map.new, fn {n, i} -> {i, n} end)

    %__MODULE__{addresses: addresses, state: :running}
    |> run()
  end

  def run(%__MODULE__{state: :halt}=intcode), do: intcode

  def run(intcode) do
    opcode = Map.fetch!(intcode.addresses, intcode.position)

    do_op(opcode, intcode)
    |> run()
   end

  def do_op(99, intcode) do
    %__MODULE__{intcode | state: :halt}
  end

  def do_op(1, intcode) do
    [noun_index, verb_index, write_to] = Enum.map((intcode.position+1..intcode.position+3),
                                                  fn i -> Map.fetch!(intcode.addresses, i) end)

    noun = Map.fetch!(intcode.addresses, noun_index)
    verb = Map.fetch!(intcode.addresses, verb_index)
    new_addresses = Map.put(intcode.addresses, write_to, noun + verb)
    new_position = intcode.position + 4
    %__MODULE__{intcode | addresses: new_addresses, position: new_position}
  end

  def do_op(2, intcode) do
    [noun_index, verb_index, write_to] = Enum.map((intcode.position+1..intcode.position+3),
                                                  fn i -> Map.fetch!(intcode.addresses, i) end)

    noun = Map.fetch!(intcode.addresses, noun_index)
    verb = Map.fetch!(intcode.addresses, verb_index)
    new_addresses = Map.put(intcode.addresses, write_to, noun * verb)
    new_position = intcode.position + 4
    %__MODULE__{intcode | addresses: new_addresses, position: new_position}
  end
end
