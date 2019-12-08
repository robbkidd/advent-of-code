defmodule Day08 do
  @moduledoc """
  Documentation for Day08.
  """

  def part1 do
    data_stream()
    |> Enum.chunk_every(25 * 6)
    |> Enum.min_by(&how_much_of_color(&1, 0))
    |> (fn (layer) -> how_much_of_color(layer, 1) * how_much_of_color(layer, 2) end).()
  end

  defp how_much_of_color(layer, color) do
    layer
    |> Enum.count(&(&1 == color))
  end

  def data_stream do
    get_day_input()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp get_day_input do
    day = __MODULE__
          |> to_string
          |> String.replace(~r/Elixir\./, "")
          |> String.downcase
    {:ok, input} = File.read("#{day}-input.txt")
    input
    |> String.trim()
  end
end
