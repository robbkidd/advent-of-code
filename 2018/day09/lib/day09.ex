defmodule Day09 do
  alias __MODULE__.CircularList

  def run() do
    play(430, 71588) |> max_score() |> IO.puts()
    play(430, 7_158_800) |> max_score() |> IO.puts()
  end

  defp play(num_players, num_marbles) do
    Enum.reduce(
      1..num_marbles,
      %{circle: CircularList.new([0]), current_player: 0, num_players: num_players, scores: %{}},
      &make_move(&2, &1)
    )
  end

  defp max_score(game_state), do: game_state.scores |> Map.values() |> Enum.max()

  defp make_move(game, marble) when rem(marble, 23) == 0 do
    circle = Enum.reduce(1..7, game.circle, fn _, circle -> CircularList.previous(circle) end)
    {scored, circle} = CircularList.pop(circle)
    scored = scored + marble

    game
    |> put_in([:circle], circle)
    |> update_in([:scores], &Map.update(&1, game.current_player, scored, fn score -> score + scored end))
    |> update_in([:current_player], &rem(&1 + 1, game.num_players))
  end

  defp make_move(game, marble) do
    game
    |> update_in([:circle], &(&1 |> CircularList.next() |> CircularList.next() |> CircularList.insert(marble)))
    |> update_in([:current_player], &rem(&1 + 1, game.num_players))
  end

  defmodule CircularList do
    def new(elements), do: {elements, []}

    def next({[], previous}), do: next({Enum.reverse(previous), []})
    def next({[current | rest], previous}), do: {rest, [current | previous]}

    def previous({next, []}), do: previous({[], Enum.reverse(next)})
    def previous({next, [last | rest]}), do: {[last | next], rest}

    def insert({next, previous}, element), do: {[element | next], previous}

    def pop({[], previous}), do: pop({Enum.reverse(previous), []})
    def pop({[current | rest], previous}), do: {current, {rest, previous}}
  end
end
