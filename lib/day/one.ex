defmodule Advent.Day.One do

  @moduledoc """
  This handles the work for Advent of Code Day 1.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Pulls in a mass value and returns the fuel cost.
    iex> Advent.Day.One.determine_fuel_need(12)
    2
    iex> Advent.Day.One.determine_fuel_need(14)
    2
    iex> Advent.Day.One.determine_fuel_need(98273)
    32755
  """
  @spec determine_fuel_need(integer) :: integer
  def determine_fuel_need(mass) when is_integer(mass) do
    mass
    |> div(3)
    |> (&(&1 - 2)).()
  end

  @doc """
  Takes a list of mass values and returns the sum cost, using tasks for concurrent work.

    iex> Advent.Day.One.determine_fuel_need([12, 14, 972167125, 11247751752, 1277512857851728])
    425841692590199
  """
  @spec determine_fuel_need([integer]) :: integer
  def determine_fuel_need(list_of_masses) when is_list(list_of_masses) do
    list_of_masses
    |> Task.async_stream(&determine_fuel_need/1, max_concurrency: System.schedulers_online() * 2)
    |> Enum.reduce(0, fn {:ok, v}, acc -> acc+v end)
  end

  @d1data File.read!("data/dayone")
  |> String.split("\n", trim: true)
  |> Enum.map(fn str -> with {n, _} <- Integer.parse(str), do: n end)


  @doc """
  Returns the answer of the Day 1 challenge.
    iex> Advent.Day.One.get_answer
    3318632
  """
  @spec get_answer :: integer
  def get_answer, do: determine_fuel_need(@d1data)

end
