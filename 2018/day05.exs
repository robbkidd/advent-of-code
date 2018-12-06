#! /usr/bin/env elixir

# LIBERALLY LIFTED FROM https://github.com/scmx/advent-of-code-2018-elixir/blob/master/lib/day_05_alchemical_reaction.ex
# But I managed to figure out how to parallelize part 2!

defmodule Day05 do

  @pairs Enum.zip(?A..?Z, ?a..?z)

  def part1 do
    {:ok, input} = File.read('day05-input.txt')
    input
    |> String.trim
    |> remaining_units
    |> IO.inspect
  end

  def part2 do
    {:ok, input} = File.read('day05-input.txt')
    input
    |> String.trim
    |> improved_remaining_units
    |> IO.inspect
  end

  def remaining_units(input) do
    input
    |> apply_reductions
    |> String.length()
  end

  def improved_remaining_units(input) do
    @pairs
    |> Enum.map(&(Task.async(fn -> improved_apply_reductions(&1, input) end)))
    |> Enum.map(&Task.await/1)
    # |> Enum.map(&improved_apply_reductions(&1, input))
    |> Enum.map(&String.length/1)
    |> Enum.min()
  end

  def improved_apply_reductions({a, b}, input) do
    a = to_string([a])
    b = to_string([b])

    input
    |> String.replace(a, "")
    |> String.replace(b, "")
    |> apply_reductions
  end

  def apply_reductions(input) do
    input
    |> String.to_charlist()
    |> reduce_repeatedly
    |> to_string
  end

  defp reduce_repeatedly(list) do
    case Enum.reverse(reduce(list)) do
      ^list -> list
      different -> different |> reduce_repeatedly
    end
  end

  defp reduce(characters, res \\ [])

  defp reduce([], res), do: res

  defp reduce([a], res), do: [a | res]

  defp reduce([a, b | tail], res)
       when abs(a - b) == 32,
       do: reduce(tail, res)

  defp reduce([a, b, c | tail], res)
       when abs(b - c) == 32,
       do: reduce([a | tail], res)

  defp reduce([a | tail], res), do: reduce(tail, [a | res])
end

Day05.part1
Day05.part2
