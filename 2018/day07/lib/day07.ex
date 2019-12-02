defmodule Day07 do
  @doc """
  Parse a step dependency

  ## Examples

      iex> Day07.parse_step_dependency("Step L must be finished before step M can begin.")
      %{"dep" => "L", "step" => "M"}

  """
  def parse_step_dependency(binary) do
    Regex.named_captures(~r/Step (?<dep>\w) .* step (?<step>\w)/, binary)
  end

  @doc """
  Return a list of instructions.

  ## Examples
      iex> Day07.instructions("Step C must be finished before step A can begin.
      ...>Step C must be finished before step F can begin.
      ...>Step A must be finished before step B can begin.
      ...>Step A must be finished before step D can begin.
      ...>Step B must be finished before step E can begin.
      ...>Step D must be finished before step E can begin.
      ...>Step F must be finished before step E can begin
      ...>")
      [%{"dep" => "C", "step" => "A"},
       %{"dep" => "C", "step" => "F"},
       %{"dep" => "A", "step" => "B"},
       %{"dep" => "A", "step" => "D"},
       %{"dep" => "B", "step" => "E"},
       %{"dep" => "D", "step" => "E"},
       %{"dep" => "F", "step" => "E"}]
  """
  def instructions(file_contents) do
    file_contents
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  @doc """
  Adds a dep to a list of deps, returns sorted.

  ## Examples
      iex> Day07.add_to_deps(["F","L","T"], "D")
      ["D","F","L","T"]
      iex> Day07.add_to_deps(["F","L","T"], "G")
      ["F","G","L","T"]
  """
  def add_to_deps(deps, dep) do
    Enum.sort(deps ++ [dep])
  end

  # def run() do
  #   instructions() |> part1() |> IO.puts()
  #   instructions() |> part2() |> IO.inspect()
  # end

  def part1(instructions), do: (instructions |> all_states(workers: 1) |> Enum.reverse |> hd()).processed
  def part2(instructions), do: duration(all_states(instructions, workers: 5))

  defp duration(all_states),
    # according to challenge, if we have 16 states, the duration is 15 seconds
    do: Enum.count(all_states) - 1

  defp all_states(instructions, opts) do
    instructions
    |> new_state(opts)
    |> Stream.unfold(fn state -> with state when not is_nil(state) <- tick(state), do: {state, state} end)
  end

  defp new_state(instructions, opts) do
    %{
      instructions: instructions,
      remaining_steps: instructions |> Stream.flat_map(&[&1.parent, &1.child]) |> MapSet.new(),
      available_workers: Keyword.fetch!(opts, :workers),
      processing: [],
      processed: ""
    }
  end

  defp tick(state) do
    if Enum.count(state.remaining_steps) + Enum.count(state.processing) == 0,
      do: nil,
      else: state |> process_current() |> start_next_steps()
  end

  defp process_current(state) do
    {done, processing} =
      state.processing
      |> Stream.map(&%{&1 | remaining: &1.remaining - 1})
      |> Enum.split_with(&(&1.remaining == 0))

    done
    |> Stream.map(& &1.step)
    |> Enum.reduce(%{state | processing: processing}, &processed(&2, &1))
  end

  defp processed(state, step) do
    state
    |> update_in([:processed], &(&1 <> step))
    |> update_in([:instructions], &Enum.reject(&1, fn instruction -> instruction.parent == step end))
    |> update_in([:available_workers], &(&1 + 1))
  end

  defp start_next_steps(state) do
    state
    |> Stream.iterate(&maybe_process/1)
    |> Stream.take_while(&(not is_nil(&1)))
    |> Enum.reverse
    |> hd()
  end

  defp maybe_process(state) do
    with true <- state.available_workers > 0,
         {next_step, state} <- pop_next_step(state) do
      state
      |> update_in([:processing], &[%{step: next_step, remaining: processing_time(next_step)} | &1])
      |> update_in([:available_workers], &(&1 - 1))
    else
      _ -> nil
    end
  end

  defp processing_time(<<char>>), do: char - ?A + 61

  defp pop_next_step(state) do
    case available_steps(state) do
      [] ->
        nil

      available_steps ->
        next_step = Enum.min(available_steps)
        {next_step, update_in(state.remaining_steps, &MapSet.delete(&1, next_step))}
    end
  end

  defp available_steps(state), do: state.remaining_steps |> MapSet.difference(child_steps(state)) |> Enum.to_list()
  defp child_steps(state), do: state.instructions |> Stream.map(& &1.child) |> MapSet.new()

  #defp instructions(), do: Enum.map(Aoc.input_lines(2018, 7), &parse_instruction/1)

  defp parse_instruction(instruction) do
    %{"parent" => parent, "child" => child} =
      Regex.named_captures(~r/Step (?<parent>.) must be finished before step (?<child>.) can begin/, instruction)

    %{parent: parent, child: child}
  end
end
