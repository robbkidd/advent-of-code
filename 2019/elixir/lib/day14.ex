defmodule Day14 do
  @moduledoc """
  Ore to fuel converter.
  """

  def part1 do
    produce(%{}, "FUEL", 1)
    #|> Enum.reduce(0, fn {"ORE", count}, acc -> acc + count end)
  end

  def part2 do
  end

  def produce(resources, chemical, needed) when chemical == "ORE" do
    Map.update(resources, "ORE", needed, &(&1 + needed))
  end

  def produce(resources, chemical, needed) do
    {:ok, reaction} = Map.fetch(resource_map(), chemical)
    on_hand = Map.get(resources, chemical, 0)

    cond do
      on_hand >= needed ->
        Map.update(resources, chemical, needed, &(&1 - needed))
      on_hand < needed ->
        reaction.consumes
        |> Enum.each(fn input ->
          input_needed = input.quantity * Float.ceil((needed - on_hand) / reaction.produces)
          produce(resources, input.chem, input_needed)
        end)
    end
    #Map.update(resources, chemical, needed, &(&1 + multiplier * reaction.produces))
  end

  def resource_map do
    parse_input(example1())
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " => "))
    |> Enum.into(Map.new(), fn [consumes, produces] ->
      chemical = parse_chemical(produces)
      { chemical.chem,
        %{ produces: chemical.quantity,
           consumes: consumes
                     |> String.split(", ")
                     |> Enum.map(fn chem_and_quant -> parse_chemical(chem_and_quant) end)
         }
      }
    end)
  end

  @spec parse_chemical([...]) :: %{chem: binary, quantity: Integer}
  def parse_chemical([quantity, chemical]) do
    %{chem: chemical, quantity: String.to_integer(quantity)}
  end

  @spec parse_chemical(binary) :: %{chem: binary, quantity: Integer}
  def parse_chemical(chem_and_quantity) do
    chem_and_quantity
    |> String.split()
    |> parse_chemical()
  end

  def input_to_graph(input) do
    graph = Graph.new

    parse_input(input)
    |> Enum.flat_map(fn {chem, reaction} ->
      Enum.map(reaction.consumes, fn ingredient ->
        Graph.Edge.new(chem, ingredient.chem, weight: ingredient.quantity)
      end)
    end)
    |> (&Graph.add_edges(graph, &1)).()
  end

  def day_input() do
    Aoc2019.get_day_input(__MODULE__)
  end

  def example1() do
    """
    9 ORE => 2 A
    8 ORE => 3 B
    7 ORE => 5 C
    3 A, 4 B => 1 AB
    5 B, 7 C => 1 BC
    4 C, 1 A => 1 CA
    2 AB, 3 BC, 4 CA => 1 FUEL
    """
  end

  def example2 do
    """
    157 ORE => 5 NZVS
    165 ORE => 6 DCFZ
    44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
    12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
    179 ORE => 7 PSHF
    177 ORE => 5 HKGWZ
    7 DCFZ, 7 PSHF => 2 XJWVT
    165 ORE => 2 GPVTF
    3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
    """
  end

  def write_graph_to_dot(graph) do
    {:ok, dot_content} = Graph.to_dot(graph)
    {:ok, dot_file} = File.open("graph.dot", [:write])
    IO.binwrite(dot_file, dot_content)
    File.close(dot_file)
  end
end
