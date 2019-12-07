defmodule Day06 do
  @moduledoc """
  Working with an orbital graph. Uses `Graph`.
  """
  def part1 do
    get_day06_input()
    |> orbit_graph()
    |> num_direct_and_indirect_orbits()
  end

  def part2 do
    get_day06_input()
    |> orbit_graph()
    |> add_orbited_by()
    |> min_orbital_transfers_between("YOU", "SAN")
  end

  @doc """
  Testing part 1 with the example data.

  ## Examples

      iex> Day06.example1
      42

  """
  def example1 do
    part1_example()
    |> orbit_graph()
    |> num_direct_and_indirect_orbits()
  end

  @doc """
  Testing part 2 with the example data.

  ## Examples

      iex> Day06.example2
      4

  """
  def example2 do
    part2_example()
    |> orbit_graph()
    |> add_orbited_by()
    |> min_orbital_transfers_between("YOU", "SAN")
  end

  def num_direct_and_indirect_orbits(graph) do
    paths_to_orbital_center(graph) |> Enum.map(&hop_count/1) |> Enum.sum
  end

  def min_orbital_transfers_between(graph, a, b) do
    graph
    |> Graph.dijkstra(a, b)
    |> Enum.reject(fn v -> v == a || v == b end)
    |> hop_count()
  end

  def hop_count(path) do
    Enum.count(path) - 1
  end

  def paths_to_orbital_center(graph) do
    core = orbital_center(graph)
    Graph.vertices(graph)
    |> Enum.reject(fn v -> v == core end)
    |> Enum.map(&Graph.dijkstra(graph, &1, core))
  end

  def orbital_center(graph) do
    Graph.topsort(graph)
    |> List.last
  end

  def orbit_graph(input) do
    input_to_orbits(input)
    |> orbit_pairs_to_graph()
  end

  def add_orbited_by(graph) do
    graph
    |> Graph.edges()
    |> Enum.map(&Day06.orbiting_to_orbited_by/1)
    |> (&Graph.add_edges(graph, &1)).()
  end

  def input_to_orbits(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.map(&pair_to_orbiting_edge/1)
  end

  def orbit_pairs_to_graph(orbits) do
    Graph.new |> Graph.add_edges(orbits)
  end

  def pair_to_orbiting_edge([body, satellite]) do
    {satellite, body, weight: 1, label: :orbiting}
  end

  def orbiting_to_orbited_by(orbiting_edge) do
    {orbiting_edge.v2, orbiting_edge.v1, weight: 2, label: :orbited_by}
  end

  def get_day06_input do
    {:ok, input} = File.read('day06-input.txt')
    input
  end

  def part1_example do
    """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """
  end

  def part2_example do
    """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """
  end

  def write_graph_to_dot(graph) do
    {:ok, dot_content} = Graph.to_dot(graph)
    {:ok, dot_file} = File.open("graph.dot", [:write])
    IO.binwrite(dot_file, dot_content)
    File.close(dot_file)
  end
end
