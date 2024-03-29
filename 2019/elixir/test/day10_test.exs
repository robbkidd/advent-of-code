defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  alias Day10

  test "example 1" do
    grid = """
           ......#.#.
           #..#.#....
           ..#######.
           .#.#.###..
           .#..#.....
           ..#....#.#
           #..#....#.
           .##.#..###
           ##...#..#.
           .#....####
           """
    detected = Day10.find_asteroids(grid)
               |> Day10.count_asteroids_visible_from(%{x: 5, y: 8})
    assert detected == 33
  end

  test "example 2" do
    grid = """
           #.#...#.#.
           .###....#.
           .#....#...
           ##.#.#.#.#
           ....#.#.#.
           .##..###.#
           ..#...##..
           ..##....##
           ......#...
           .####.###.
           """
    detected = Day10.find_asteroids(grid)
               |> Day10.count_asteroids_visible_from(%{x: 1, y: 2})
    assert detected == 35
  end

  test "example 3" do
    grid = """
           .#..#..###
           ####.###.#
           ....###.#.
           ..###.##.#
           ##.##.#.#.
           ....###..#
           ..#.#..#.#
           #..#.#.###
           .##...##.#
           .....#.#..
           """
    detected = Day10.find_asteroids(grid)
               |> Day10.count_asteroids_visible_from(%{x: 6, y: 3})
    assert detected == 41
  end

  test "example 4" do
    grid = """
           .#..##.###...#######
           ##.############..##.
           .#.######.########.#
           .###.#######.####.#.
           #####.##.#.##.###.##
           ..#####..#.#########
           ####################
           #.####....###.#.#.##
           ##.#################
           #####.##.###..####..
           ..######..##.#######
           ####.##.####...##..#
           .#####..#.######.###
           ##...#.##########...
           #.##########.#######
           .####.#.###.###.#.##
           ....##.##.###..#####
           .#.#.###########.###
           #.#.#.#####.####.###
           ###.##.####.##.#..##
           """
    detected = Day10.find_asteroids(grid)
               |> Day10.count_asteroids_visible_from(%{x: 11, y: 13})
    assert detected == 210
  end

  test "part 2" do
    grid = """
           .#..##.###...#######
           ##.############..##.
           .#.######.########.#
           .###.#######.####.#.
           #####.##.#.##.###.##
           ..#####..#.#########
           ####################
           #.####....###.#.#.##
           ##.#################
           #####.##.###..####..
           ..######..##.#######
           ####.##.####...##..#
           .#####..#.######.###
           ##...#.##########...
           #.##########.#######
           .####.#.###.###.#.##
           ....##.##.###..#####
           .#.#.###########.###
           #.#.#.#####.####.###
           ###.##.####.##.#..##
           """
    roids = Day10.find_asteroids(grid)
    {station, _} = Day10.best_station_location_in(roids)
    roids_by_angle = roids |> Day10.order_targets(station)

    first = roids_by_angle |> hd()
    assert first == %{x: 11, y: 12}
  end
end
