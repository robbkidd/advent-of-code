defmodule Day10 do
  @moduledoc """
  Which asteroid can see the most other asteroids?
  """

  def part1 do
    asteroids = get_day_input()
                |> find_asteroids()
    asteroids
    |> Enum.map(&num_asteroids_visible_from(asteroids,&1))
    |> Enum.max()
  end

  def num_asteroids_visible_from(asteroids, asteroid) do
    asteroids
    |> Enum.reject(fn (other) -> other == asteroid end)
    |> Enum.group_by(&vector(asteroid, &1))
    |> Enum.count(fn {_vector, other_asteroids} -> Enum.count(other_asteroids) > 0 end)
  end

  @spec vector(%{x: number, y: number}, %{x: number, y: number}) :: %{
          delta_x: float,
          delta_y: float
        }
  def vector(a, b) when a != b do
    [diff_x, diff_y] = diff(a, b)
    diff_gcd = Integer.gcd(diff_x, diff_y)
    %{ delta_x: (diff_x / diff_gcd),
       delta_y: (diff_y / diff_gcd)
     }
  end

  def vector(a, b) when a == b do
    %{ delta_x: 0, delta_y: 0 }
  end

  @spec distance(%{x: number, y: number}, %{x: number, y: number}) :: number
  def distance(a, b) do
    diff(a, b)
    |> (fn [dx, dy] -> abs(dx) + abs(dy) end).()
  end

  @spec diff(%{x: number, y: number}, %{x: number, y: number}) :: [number, ...]
  def diff(a, b) do
    [(a.x - b.x), (a.y - b.y)]
  end

  def find_asteroids(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} -> row_asteroid_coords(row, y) end)
  end

  def row_asteroid_coords(row, y) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {spot, _x} -> "#" == spot end)
    |> Enum.map(fn {_spot, x} -> %{x: x, y: y} end)
  end

  def get_day_input do
    Aoc2019.get_day_input(__MODULE__)
  end
end
