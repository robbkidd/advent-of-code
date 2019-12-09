defmodule Aoc2019 do
  @moduledoc """
  Documentation for Aoc2019.
  """

  def get_day_input(module_name) do
    day = module_name
          |> to_string
          |> String.replace(~r/Elixir\./, "")
          |> String.downcase

    {:ok, input} = File.read("../inputs/#{day}-input.txt")
    input
    |> String.trim()
  end
end
