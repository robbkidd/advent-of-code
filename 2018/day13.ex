defmodule Advent.Day13 do
  @max_processing 6000
  defmodule Cart do
    defstruct direction: "", turns: 0

    def direction(nil), do: nil
    def direction(%{direction: value}), do: value

    def make_turn(%{direction: direction, turns: turns} = cart) do
      direction =
        case {direction, turns} do
          {">", 0} -> "^"
          {"<", 0} -> "v"
          {"^", 0} -> "<"
          {"v", 0} -> ">"
          {_, 1} -> direction
          {">", 2} -> "v"
          {"<", 2} -> "^"
          {"^", 2} -> ">"
          {"v", 2} -> "<"
        end

      %{cart | direction: direction, turns: rem(turns + 1, 3)}
    end
  end

  def parse(input) do
    map =
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> List.flatten()

    carts =
      map
      |> Enum.filter(&String.match?(elem(&1, 1), ~r/[><v^]/))
      |> Enum.map(&{elem(&1, 0), %Cart{direction: elem(&1, 1)}})
      |> Enum.into(%{})

    map =
      map
      |> Enum.map(fn {position, value} ->
        direction =
          Map.get(carts, position)
          |> Cart.direction()

        value =
          cond do
            direction == ">" || direction == "<" -> "-"
            direction != nil -> "|"
            true -> value
          end

        {position, value}
      end)
      |> Enum.into(%{})

    max =
      map
      |> Map.keys()
      |> Enum.reduce({0, 0}, fn {x, y}, {max_x, max_y} ->
        {
          if(x > max_x, do: x, else: max_x),
          if(y > max_y, do: y, else: max_y)
        }
      end)

    {map, carts, max}
  end

  def part1(input) do
    {map, carts, max} =
      input
      |> parse()

    case process({map, carts}, max, @max_processing) do
      {:crash, _carts, crashed} ->
        crashed
        |> Enum.at(0)

      _ ->
        -999
    end
  end

  def part2(input) do
    {map, carts, max} =
      input
      |> parse()

    process_until_one_cart_left({map, carts}, max, @max_processing)
  end

  def process_until_one_cart_left({map, carts}, max, 0) do
    draw({map, carts}, max)
    -999
  end

  def process_until_one_cart_left({map, carts}, max, times) do
    if Enum.count(carts) > 1 do
      case process({map, carts}, max, @max_processing) do
        {:crash, carts, _crashed} ->
          process_until_one_cart_left({map, carts}, max, times - 1)

        _ ->
          process_until_one_cart_left({map, carts}, max, times - 1)
      end
    else
      carts |> Map.keys() |> Enum.at(0)
    end
  end

  def process(mines, _max, 0), do: mines

  def process({map, _carts} = mines, max, times) do
    {carts, crashed} = tick(mines, max)

    if length(crashed) > 0 do
      {:crash, carts, crashed}
    else
      process({map, carts}, max, times - 1)
    end
  end

  def tick({map, carts}, max) do
    carts
    |> Enum.reduce({carts, []}, fn {position, cart}, {carts, crashed} ->
      if position in crashed do
        {carts, crashed}
      else
        carts = Map.delete(carts, position)
        {new_position, cart} = update_cart(Map.get(map, position), cart, position)

        if Map.get(carts, new_position) do
          {
            Map.delete(carts, new_position),
            [new_position | crashed]
          }
        else
          {
            Map.put(carts, new_position, cart),
            crashed
          }
        end
      end
    end)
  end

  defp update_cart("+", cart, {x, y}) do
    update_cart(".", Cart.make_turn(cart), {x, y})
  end

  defp update_cart(current, %{direction: direction} = cart, {x, y}) do
    {position, direction} =
      case {current, direction} do
        {"/", "^"} -> {{x + 1, y}, ">"}
        {"\\", ">"} -> {{x, y + 1}, "v"}
        {"/", "v"} -> {{x - 1, y}, "<"}
        {"\\", "<"} -> {{x, y - 1}, "^"}
        {"\\", "v"} -> {{x + 1, y}, ">"}
        {"/", ">"} -> {{x, y - 1}, "^"}
        {"\\", "^"} -> {{x - 1, y}, "<"}
        {"/", "<"} -> {{x, y + 1}, "v"}
        {_, ">"} -> {{x + 1, y}, ">"}
        {_, "<"} -> {{x - 1, y}, "<"}
        {_, "v"} -> {{x, y + 1}, "v"}
        {_, "^"} -> {{x, y - 1}, "^"}
      end

    {position, %{cart | direction: direction}}
  end

  defp draw({map, carts}, {max_x, max_y}) do
    IO.write("\n")

    for y <- 0..max_y do
      for x <- 0..max_x do
        case Map.get(carts, {x, y}) do
          "X" -> IO.write("X")
          %{direction: direction} -> IO.write(direction)
          _ -> IO.write(Map.get(map, {x, y}) || " ")
        end
      end

      IO.write("\n")
    end

    {map, carts}
  end
end
