defmodule Intcode do
  defstruct addresses: {}, position: 0, state: :new, input: [], output: ""

  @moduledoc """
  Documentation for the Intcode computer.
  """

  def new(program, input \\ []) when is_list(program) do
    addresses = program
                |> Enum.with_index()
                |> Enum.into(Map.new, fn {n, i} -> {i, n} end)

    %__MODULE__{addresses: addresses, state: :running, input: input}
  end

  @doc """
  Hello world.

  ## Examples

      iex> %Intcode{state: :halt} = Intcode.run([99])
      iex> Intcode.run([1,0,0,0,99]) |> Map.get(:addresses) |> Map.get(0)
      2
      iex> Intcode.run([1,1,1,4,99,5,6,0,99]) |> Map.get(:addresses) |> Map.get(0)
      30
      iex> Intcode.new([3,0,4,0,99], [42]) |> Intcode.run() |> Map.get(:addresses) |> Map.get(0)
      42
      iex> Intcode.new([3,0,4,0,99], [42]) |> Intcode.run() |> Map.get(:output) |> String.trim()
      "42"

  """
  def run(program) when is_list(program) do
    new(program)
    |> run()
  end

  def run(%__MODULE__{state: :halt}=intcode), do: intcode

  def run(intcode) do
    instruction = Map.fetch!(intcode.addresses, intcode.position)
    {parameter_modes, opcode} = parse_instruction(instruction)

    do_op(opcode, intcode)
    |> run()
  end


 @doc """
  Hello world.

  ## Examples

      iex> Intcode.parse_instruction(2)
      {[:position, :position, :position], 2}
      iex> Intcode.parse_instruction(1002)
      {[:position, :immediate, :position], 2}

  """
  def parse_instruction(instruction) when is_integer(instruction) do
    <<raw_parameter_modes::binary-size(3), opcode::binary-size(2)>> =
      Integer.to_string(instruction)
      |> String.pad_leading(5, "0")

    { raw_parameter_modes
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.map(fn param_mode ->
           case param_mode do
             "0" -> :position
             "1" -> :immediate
           end
         end) ,
      opcode
      |> String.to_integer()
    }
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

  def do_op(3, intcode) do
    write_to = Map.fetch!(intcode.addresses, intcode.position+1)
    [input | rest] = intcode.input
    new_addresses = Map.put(intcode.addresses, write_to, input)
    new_position = intcode.position + 2
    %__MODULE__{intcode | addresses: new_addresses, input: rest, position: new_position}
  end

  def do_op(4, intcode) do
    output_position = Map.fetch!(intcode.addresses, intcode.position+1)
    output = Map.fetch!(intcode.addresses, output_position)
    updated_output = intcode.output <> to_string(output) <> "\n"
    new_position = intcode.position + 2
    %__MODULE__{intcode | output: updated_output, position: new_position}
  end
end
