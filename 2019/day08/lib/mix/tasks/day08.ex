defmodule Mix.Tasks.Day08 do
  use Mix.Task

  @shortdoc "Run the day's parts"
  def run(_) do
    IO.puts("Day 8")
    IO.puts("- Part 1:")
    Day08.part1
    IO.puts("\n---\n")
    IO.puts("- Part 2:")
    Day08.part2
  end
end
