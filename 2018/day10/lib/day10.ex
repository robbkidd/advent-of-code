defmodule Day10 do
  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  @doc """
  Parse a point and its velocity.

  ## Examples

      iex> Day10.parse_line("position=< 10775, -31651> velocity=<-1,  3>")
      %{x: 10775, y: -31651, delta_x: -1, delta_y: 3}

  """
  def parse_line(line) do
    [[x], [y], [delta_x], [delta_y]] = Regex.scan(~r/-?\d+/, line)
    %{x: String.to_integer(x),
      y: String.to_integer(y),
      delta_x: String.to_integer(delta_x),
      delta_y: String.to_integer(delta_y)}
  end

  @doc """
  Returns the x,y coordinates of a point after a given number of seconds

      iex> Day10.new_location(%{x: 10775, y: -31651, delta_x: -1, delta_y: 3}, 3)
      {10772, -31642}

  """
  def new_location(original, seconds) do
    x = original[:x] + (original[:delta_x] * seconds)
    y = original[:y] + (original[:delta_y] * seconds)
    {x,y}
  end

  @doc """
  Gets the bounding box for a list of coordinates.

      iex> Day10.bounding_box([
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9}
      ...> ])
      {1..8, 1..9}

  """
  def bounding_box(coordinates) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, &elem(&1, 1))
    {min_x..max_x, min_y..max_y}
  end

  @doc """
  Creates a fresh, new grid.
  """
  def new_grid({x_range, y_range}) do
    for col <- x_range, row <- y_range, into: %{}, do: {{col, row}, "."}
  end

  def fill(grid, list) do
    Enum.reduce(list, grid, fn point, acc -> mark(acc, point) end)
  end

  def mark(board, {col, row}) do
    mark(board, col, row)
  end

  def mark(board, col, row), do: Map.put(board, {col, row}, "#")

  @doc """
  Display a grid at a given second.

      iex> input = "position=< 9,  1> velocity=< 0,  2>
      ...>position=< 7,  0> velocity=<-1,  0>
      ...>position=< 3, -2> velocity=<-1,  1>
      ...>position=< 6, 10> velocity=<-2, -1>
      ...>position=< 2, -4> velocity=< 2,  2>
      ...>position=<-6, 10> velocity=< 2, -2>
      ...>position=< 1,  8> velocity=< 1, -1>
      ...>position=< 1,  7> velocity=< 1,  0>
      ...>position=<-3, 11> velocity=< 1, -2>
      ...>position=< 7,  6> velocity=<-1, -1>
      ...>position=<-2,  3> velocity=< 1,  0>
      ...>position=<-4,  3> velocity=< 2,  0>
      ...>position=<10, -3> velocity=<-1,  1>
      ...>position=< 5, 11> velocity=< 1, -2>
      ...>position=< 4,  7> velocity=< 0, -1>
      ...>position=< 8, -2> velocity=< 0,  1>
      ...>position=<15,  0> velocity=<-2,  0>
      ...>position=< 1,  6> velocity=< 1,  0>
      ...>position=< 8,  9> velocity=< 0, -1>
      ...>position=< 3,  3> velocity=<-1,  1>
      ...>position=< 0,  5> velocity=< 0, -1>
      ...>position=<-2,  2> velocity=< 2,  0>
      ...>position=< 5, -2> velocity=< 1,  2>
      ...>position=< 1,  4> velocity=< 2,  1>
      ...>position=<-2,  7> velocity=< 2, -2>
      ...>position=< 3,  6> velocity=<-1, -1>
      ...>position=< 5,  0> velocity=< 1,  0>
      ...>position=<-6,  0> velocity=< 2,  0>
      ...>position=< 5,  9> velocity=< 1, -2>
      ...>position=<14,  7> velocity=<-2,  0>
      ...>position=<-3,  6> velocity=< 2, -1>"
      iex> coordinates = Day10.parse_input(input)
      iex> Day10.display_grid_at(coordinates, 3)
      "#...#..###
      #...#...#.
      #...#...#.
      #####...#.
      #...#...#.
      #...#...#.
      #...#...#.
      #...#..###"
  """
  def display_grid_at(coordinates, second) do
    current_locations = coordinates |> Enum.map(&new_location(&1, second))
    {x_range, y_range} = bounding_box(current_locations)
    grid = new_grid({x_range, y_range}) |> fill(current_locations)

    for row <- y_range do
      for col <- x_range do
        grid[{col, row}]
      end
      |> Enum.join
    end
    |> Enum.join("\n")
  end
end
