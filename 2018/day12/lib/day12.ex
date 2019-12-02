defmodule Day12 do
  @input "##.##.#.#...#......#..#.###..##...##.#####..#..###.########.##.....#...#...##....##.#...#.###...#.##"

  @rules %{
    "....." => ".",
    "....#" => ".",
    "...#." => ".",
    "...##" => "#",
    "..#.." => ".",
    "..#.#" => "#",
    "..##." => ".",
    "..###" => ".",
    ".#..." => "#",
    ".#..#" => "#",
    ".#.#." => "#",
    ".#.##" => "#",
    ".##.." => ".",
    ".##.#" => "#",
    ".###." => "#",
    ".####" => ".",
    "#...." => ".",
    "#...#" => ".",
    "#..#." => "#",
    "#..##" => ".",
    "#.#.." => "#",
    "#.#.#" => ".",
    "#.##." => "#",
    "#.###" => ".",
    "##..." => "#",
    "##..#" => "#",
    "##.#." => ".",
    "##.##" => ".",
    "###.." => "#",
    "###.#" => "#",
    "####." => "#",
    "#####" => "."
  }

  @doc """
  part 1!

      iex> Day12.part1
      0
  """
  def part1 do
    @input
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> next_generation
    |> live_plant_count
  end

  @doc """
  Return string chuck at an index.

  ## Examples

      iex> Day12.chunk_at("....#..#.#..##......###...###....", 2)
      "....#"
      iex> Day12.chunk_at("....#..#.#..##......###...###....", 3)
      "...#."
      iex> Day12.chunk_at("....#..#.#..##......###...###....", 4)
      "..#.."
  """
  def chunk_at(string, index) do
    String.slice(string, index-2, 5)
  end

  def next_generation(generation, spreads \\ @input_spreads) do
    padded_generation = prep_generation(generation)

    for i <- 2..(String.length(padded_generation)-3), into: [] do
      Map.get(spreads, chunk_at(padded_generation, i), ".")
    end
    |> Enum.join
    |> trim_generation
  end

  @doc """
  Pad a generation of pots with empties.

      iex> Day12.prep_generation("#..#.#..##......###...###")
      "....#..#.#..##......###...###...."
  """
  def prep_generation(generation) do
    generation
    |> trim_generation
    |> (&("...."<>&1)).()
    |> (&(&1<>"....")).()
  end

  def trim_generation(generation) do
    generation
    |> String.trim(".")
  end

  @doc """
  count the number of pots with live plants

      iex> Day12.live_plant_count("...#...#....#.....#..#..#..#...........")
      7
  """
  def live_plant_count(generation) do
    generation
    |> String.split("")
    |> Enum.count(&(&1 == "#"))
  end
end
