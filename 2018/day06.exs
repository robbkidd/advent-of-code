defmodule Day06 do
  def part1 do

    finite_area_sizes(interesting_points)
  end

  def interesting_points do
    get_input |> parse_points
  end

  def get_input do
    {:ok, input} = File.read('day06-input.txt')
    input
    |> String.trim
  end

  def the_world(bounds \\ %{x: 0..400, y: 0..400}) do
    Enum.flat_map(bounds[:x], fn n -> Enum.map(bounds[:y], &{n, &1}) end)
  end

  def finite_area_sizes(points) do
    bounds = point_bounds(Map.keys(points))
    world = the_world(bounds)
    area_sizes(points, world)
    # |> Enum.filter_the_infinite_ones(ontheoutside)
    # |>
    # |> Enum.filter(fn {{_, n1}, {_, n2}} -> n1 == n2 end)
    # |> Enum.sort_by(fn {name, size} -> size end)
    # |> Enum.reverse()
    #|> hd()
  end

  def area_sizes(points, world) do
    points
    |> closest_points(world)
    # |> Map.values()
    # |> Enum.reduce(%{}, &do_sum_area_sizes/2)
  end

  defp do_sum_area_sizes(name, acc), do: Map.update(acc, name, 1, &(&1 + 1))

  def closest_points(points, world \\ the_world()) do
    world
    |> Enum.map(&{&1, closest_point(&1, points)})
    |> Enum.into(%{})
  end

  def closest_point(point, points) do
    case do_closest(point, points) |> Enum.sort() do
      [{distance, _}, {distance, _} | _] -> ".."
      [{_, other_point_name} | _] -> String.downcase(other_point_name)
    end
  end

  defp do_closest(point, points) do
    Enum.map(points, fn {other_point, other_point_name} ->
      {manhattan_distance(point, other_point), other_point_name}
    end)
  end

  def point_bounds(points) do
    {min_x, max_x} = points
                      |> Enum.map(fn {x, _} -> x end)
                      |> Enum.min_max
    {min_y, max_y} = points
                      |> Enum.map(fn {_, y} -> y end)
                      |> Enum.min_max
    %{x: Range.new(min_x, max_x),
      y: Range.new(min_y, max_y)}
  end

  def grid_locations(range \\ 0..400) do
    Enum.flat_map(range, fn n -> Enum.map(range, &{n, &1}) end)
  end

  def parse_points(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_point/1)
    |> Enum.zip(names())
    |> Enum.into(%{})
  end

  defp parse_point(point) do
    point
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def names do
    ?A..?Z
    |> Enum.map(&to_string([&1]))
    |> Enum.flat_map(fn a -> Enum.map(0..1, &"#{&1}#{a}") end)
    |> Enum.sort()
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

end
