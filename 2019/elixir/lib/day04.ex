defmodule Day04 do
  @moduledoc """
  Documentation for Day04.
  """

  def part1 do
    passwords_range()
    |> Enum.filter(&valid?/1)
    |> Enum.count
  end

  @doc """
  Password validation.

  ## Examples

      iex> Day04.valid?("111111")
      true
      iex> Day04.valid?("122345")
      true
      iex> Day04.valid?("111123")
      true
      iex> Day04.valid?("223450")
      false
      iex> Day04.valid?("123789")
      false

  """
  def valid?(password) do
    correct_length?(password) &&
      ever_increasing?(password) &&
      contains_adjacent_digits?(password)
  end

  @doc """
  Password validation in part 2.

  ## Examples

      iex> Day04.really_valid?("111111")
      false
      iex> Day04.really_valid?("112233")
      true
      iex> Day04.really_valid?("111122")
      true
      iex> Day04.really_valid?("123444")
      false
      iex> Day04.really_valid?("123789")
      false

  """
  def really_valid?(password) do
    correct_length?(password) &&
      ever_increasing?(password) &&
      contains_adjacent_digits?(password)
  end

  def passwords_range do
    Aoc2019.get_day_input(__MODULE__)
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> (fn [a, b] -> a..b end).()
    |> Enum.to_list()
    |> Enum.map(&to_string/1)
  end

  @doc """
  Check password length.

  ## Examples

      iex> Day04.correct_length?("111111")
      true
      iex> Day04.correct_length?("11111")
      false
      iex> Day04.correct_length?("1111111")
      false

  """
  def correct_length?(password) do
    String.length(password) == 6
  end

  @doc """
  all digits are increasing

  ## Examples

      iex> Day04.ever_increasing?("123789")
      true
      iex> Day04.ever_increasing?("122345")
      true
      iex> Day04.ever_increasing?("124454")
      false
      iex> Day04.ever_increasing?("123454")
      false

  """
  def ever_increasing?(password) do
    password
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a,b] -> a <= b end)
  end

  @doc """
  contains_adjacent_digits?

  ## Examples

      iex> Day04.contains_adjacent_digits?("123789")
      false
      iex> Day04.contains_adjacent_digits?("122345")
      true
      iex> Day04.contains_adjacent_digits?("124454")
      true
      iex> Day04.contains_adjacent_digits?("123454")
      false

  """
  def contains_adjacent_digits?(password) do
    password
    |> String.graphemes
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a,b] -> a == b end)
  end

  @doc """
  contains_adjacent_digits?

  ## Examples

      iex> Day04.contains_a_pair_of_digits?("123789")
      false
      iex> Day04.contains_a_pair_of_digits?("122345")
      true
      iex> Day04.contains_a_pair_of_digits?("124454")
      true
      iex> Day04.contains_a_pair_of_digits?("123454")
      false
      iex> Day04.contains_a_pair_of_digits?("111122")
      true
      iex> Day04.contains_a_pair_of_digits?("123444")
      false

  """
  def contains_a_pair_of_digits?(password) do
    password
    |> String.graphemes
    |> Enum.chunk_while([],
      (fn
        elem, [] -> {:cont, [elem]}
        elem, chunk ->
          if elem == hd(chunk) do
            {:cont, [elem | chunk]}
          else
            {:cont, chunk, [elem]}
          end
       end
      ),
      (fn chunk -> chunk end)
    )
    #|> Enum.any?(fn [a,b] -> a == b end)
  end
end
