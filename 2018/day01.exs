#! /usr/bin/env elixir

# LIBERALLY CRIBBED FROM https://github.com/scmx/advent-of-code-2018-elixir/blob/master/lib/day_01_chronal_calibration.ex
# Trying to get my Elixir learn on

defmodule Day01 do
  def part1 do
    {:ok, input} = File.read('day01-input.txt')
    input
    |> find_final_frequency
    |> IO.inspect
  end

  def part2 do
    {:ok, input} = File.read('day01-input.txt')
    input
    |> first_repeated_frequency
    |> IO.inspect
  end

  def find_final_frequency(input) do
    input
    |> input_to_frequencies
    |> Enum.sum
  end

  def first_repeated_frequency(input) do
    input
    |> input_to_frequencies
    |> Stream.cycle
    |> Enum.reduce_while({0, MapSet.new()}, fn change, {last, visited} ->
      resulting_frequency = last + change

      if MapSet.member?(visited, resulting_frequency) do
        {:halt, resulting_frequency}
      else
        {:cont, {resulting_frequency, MapSet.put(visited, resulting_frequency)}}
      end
    end)
  end

  def input_to_frequencies(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end

Day01.part1
Day01.part2
