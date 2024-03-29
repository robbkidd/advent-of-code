defmodule Day10 do
  @moduledoc """
  Which asteroid can see the most other asteroids?
  """

  def part1 do
    asteroids = get_day_input()
                |> find_asteroids()
    asteroids
    |> best_station_location_in()
  end

  def part2 do
    asteroids = get_day_input()
                |> find_asteroids()

    {station, _} = best_station_location_in(asteroids)
    asteroids
    |> order_targets(station)
  end

  def order_targets(asteroids, station) do
    asteroids
    |> MapSet.delete(station)
    |> Enum.map(fn asteroid ->
      {asteroid, polar_coordinates_to(station, asteroid)}
    end)
    |> Enum.group_by(fn {_asteroid, {_r, theta}} -> theta end)
    |> Enum.map(fn {theta, asteroids} ->
      [ theta, asteroids
               |> Enum.sort_by(fn {_roid, {r, _theta}} -> r end)
               |> Enum.map(fn {roid, _polar_coordinates} -> roid end)
      ]
     end)
     |> Enum.sort()
     #|> pluck_em_off()
  end

  def pluck_em_off(asteroids_by_angle, targets \\ [])

  def pluck_em_off(asteroids_by_angle, targets) do
  end

  def best_station_location_in(asteroids) do
    asteroids
    |> Enum.map(fn asteroid ->
      { asteroid, count_asteroids_visible_from(asteroids, asteroid) }
    end)
    |> Enum.max_by(fn {_asteroid, visible_asteroids} -> visible_asteroids end)
  end

  def count_asteroids_visible_from(asteroids, asteroid) do
    asteroids
    |> MapSet.delete(asteroid)
    |> Enum.map(&polar_coordinates_to(asteroid, &1))
    |> Enum.uniq_by(fn {_r, theta} -> theta end)
    |> length()
  end

  def polar_coordinates_to(reference, other) do
    {diff_x, diff_y} = {(reference.x - other.x), (reference.y - other.y)}
    r = :math.sqrt(:math.pow(diff_x, 2) + :math.pow(diff_y, 2))
    theta = :math.atan2(diff_y, diff_x)
    tweeked_theta =
      if theta < -:math.pi / 2 do
        (2 * :math.pi) + theta
      else
        theta
      end
    {r, tweeked_theta}
  end

  def find_asteroids(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} -> row_asteroid_coords(row, y) end)
    |> MapSet.new
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
