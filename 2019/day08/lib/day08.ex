defmodule Day08 do
  @moduledoc """
  Documentation for Day08.
  """

  alias __MODULE__.{SIF}

  def part1 do
    get_day_input()
    |> SIF.new(25, 6)
    |> SIF.weird_elven_checksum()
    |> IO.puts()
  end

  def part2 do
    get_day_input()
    |> SIF.new(25, 6)
    |> SIF.render()
    |> IO.puts()
  end

  defmodule SIF do
    defstruct [:layers, :width, :height]

    @black 0
    @white 1
    @transparent 2

    @doc """
    Examples:

      iex> Day08.SIF.new("0222112222120000", 2, 2)
      %Day08.SIF{
              height: 2,
              layers: [[0, 2, 2, 2], [1, 1, 2, 2], [2, 2, 1, 2], [0, 0, 0, 0]],
              width: 2
            }
    """
    def new(data_stream, width, height) when is_binary(data_stream) do
      data = data_stream
             |> String.graphemes()
             |> Enum.map(&String.to_integer/1)
      new(data, width, height)
    end

    def new(data, width, height), do: %__MODULE__{layers: Enum.chunk_every(data, width * height), width: width, height: height }

    @doc """
    Examples:

      iex> Day08.SIF.new("0222112222120000", 2, 2) |> Day08.SIF.render
      " 🎅
      🎅 "
    """
    def render(sif) do
      sif.layers
      |> List.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&render_pixel/1)
      |> Enum.chunk_every(sif.width)
      |> Enum.map(&Enum.join/1)
      |> Enum.join("\n")
    end

    defp render_pixel(layered_pixel) do
      layered_pixel
      |> Enum.map(&replace_color/1)
      |> Enum.find(&(&1 != @transparent))
    end

    defp replace_color(@black), do: " "
    defp replace_color(@white), do: "🎅"
    defp replace_color(any), do: any

    @doc """
    Examples:

      iex> Day08.SIF.new(Day08.get_day_input(), 25, 6) |> SIF.weird_elven_checksum()
      2520

    """
    def weird_elven_checksum(sif) do
      sif.layers
      |> Enum.min_by(&how_much_of_color(&1, @black))
      |> (fn (layer) -> how_much_of_color(layer, @white) * how_much_of_color(layer, @transparent) end).()
    end

    defp how_much_of_color(layer, color) do
      layer
      |> Enum.count(&(&1 == color))
    end
  end

  def get_day_input do
    day = __MODULE__
          |> to_string
          |> String.replace(~r/Elixir\./, "")
          |> String.downcase
    {:ok, input} = File.read("#{day}-input.txt")
    input
    |> String.trim()
  end
end
