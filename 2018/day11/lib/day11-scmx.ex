defmodule Adventofcode.Day11ChronalCharge do
  @grid_size 300

  def most_powered_three_by_three(input) do
    input
    |> parse
    |> build_grid
    |> fuel_squares_largest(3)
    |> Tuple.to_list()
    |> Enum.take(2)
    |> Enum.join(",")
  end

  def most_powered_any_size(input) do
    input
    |> parse
    |> build_grid
    |> fuel_squares_largest_total_power
    |> Tuple.to_list()
    |> Enum.take(3)
    |> Enum.join(",")
  end

  defp parse(input) when is_number(input), do: input
  defp parse(input) when is_binary(input), do: String.to_integer(input)

  defp build_grid(grid_serial_number) do
    for y <- 1..@grid_size do
      for x <- 1..@grid_size, do: power_level(grid_serial_number, {x, y})
    end
  end

  defp power_level(grid_serial_number, {x, y}) do
    rack_id = x + 10
    power = (rack_id * y + grid_serial_number) * rack_id
    zero_to_nine = power |> div(100) |> rem(10)

    zero_to_nine - 5
  end

  # Credits to Joe Chiarella for the algorithm
  # https://github.com/joechiarella/advent_of_code/blob/master/lib/aoc2018_11.ex
  defp fuel_squares_largest_total_power(grid) do
    1..@grid_size
    |> Enum.map(&fuel_squares_largest(grid, &1))
    |> Enum.max_by(&elem(&1, 3))
  end

  defp fuel_squares_largest(grid, size) do
    grid
    |> Enum.map(&sum_row(&1, size))
    |> List.zip()
    |> Enum.map(&sum_row(Tuple.to_list(&1), size))
    |> List.flatten()
    |> Enum.with_index(1)
    |> Enum.max_by(&elem(&1, 0))
    |> do_fuel_squares_largest(size)
  end

  defp do_fuel_squares_largest({max, index}, size) do
    x = div(index, @grid_size - (size - 1)) + 1
    y = rem(index, @grid_size - (size - 1))

    {x, y, size, max}
  end

  defp sum_row(row, size) do
    current = row |> Enum.take(size) |> Enum.sum()
    adds = Enum.drop(row, size)

    [current | moving_sum(current, adds, row)]
  end

  defp moving_sum(_, [], _), do: []

  defp moving_sum(prev, [add | add_tail], [sub | sub_tail]) do
    current = prev + add - sub

    [current | moving_sum(current, add_tail, sub_tail)]
  end
end
