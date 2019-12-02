defmodule Day01 do
  @moduledoc """
  Documentation for Day01.
  """

  def part1 do
    {:ok, input} = File.read('day01-input.txt')
    input
    |> input_to_module_masses
    |> Enum.map(&mass_to_fuel/1)
    |> Enum.sum
  end

  def part2 do
    {:ok, input} = File.read('day01-input.txt')
    input
    |> input_to_module_masses
    |> Enum.map(&required_fuel/1)
    |> Enum.sum
  end

  @doc """
  Straight mass-to-fuel calculation.

  ## Examples

      iex> Day01.mass_to_fuel(12)
      2
      iex> Day01.mass_to_fuel(14)
      2
      iex> Day01.mass_to_fuel(1969)
      654
      iex> Day01.mass_to_fuel(100756)
      33583

  """
  def mass_to_fuel(mass) do
    div(mass, 3) - 2
  end

  @doc """
  How much fuel for fuel?

  ## Examples

      iex> Day01.required_fuel(12)
      2
      iex> Day01.required_fuel(14)
      2
      iex> Day01.required_fuel(1969)
      966
      iex> Day01.required_fuel(100756)
      50346

  """
  def required_fuel(mass, acc \\ 0)

  def required_fuel(mass, acc) when mass <= 0, do: acc - mass

  def required_fuel(mass, acc) do
    fuel = mass_to_fuel(mass)
    required_fuel(fuel, acc + fuel)
  end

  def input_to_module_masses(input) do
    input
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
  end
end
