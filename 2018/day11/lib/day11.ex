defmodule Day11 do
  def part1 do
    a_grid(2187)
    |> max_square_power
  end

  @doc """
  Power level of a fuel cell

  ## Examples

      iex> Day11.fuel_cell_power_level({3,5}, 8)
      4
      iex> Day11.fuel_cell_power_level({122,79}, 57)
      -5
      iex> Day11.fuel_cell_power_level({217,196}, 39)
      0
      iex> Day11.fuel_cell_power_level({101,153}, 71)
      4
  """
  def fuel_cell_power_level({x, y}, serial_number) do
    trunc((((x + 10) * y) + serial_number) * (x+10) / 100)
    |> Integer.to_string
    |> String.reverse
    |> String.first
    |> String.to_integer
    |> Kernel.-(5)
  end


  def a_grid(serial_number) do
    for x <- 1..300,
        y <- 1..300, into: %{} do
          {{x,y}, fuel_cell_power_level({x,y}, serial_number)}
        end
  end

  @doc """
  Return the total power for a 3x3 square whose upper left corner is within a grid.

      iex> Day11.a_grid(18) |> Day11.square_power({33,45})
      29
      iex> Day11.a_grid(42) |> Day11.square_power({21,61})
      30
  """
  def square_power(grid, {x, y}) do
    for x <- x..(x+2),
        y <- y..(y+2) do
          grid[{x,y}] || 0
        end
        |> Enum.reduce(fn power, total_power -> total_power + power end)
  end

  def max_square_power(grid) do
    grid
    |> Enum.map(fn {coord, _} -> {coord, square_power(grid, coord)} end)
    |> Enum.max_by(fn {k,v} -> v end)
  end


end
