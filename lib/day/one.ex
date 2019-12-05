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
  Revised version of the determine fuel function, now taking into account the
  need to recurse calculation on fuel. Still uses the old function to prevent DRY.
    iex> Advent.Day.One.determine_fuel_need_revised 14
    2
    iex> Advent.Day.One.determine_fuel_need_revised 1969
    966
    iex> Advent.Day.One.determine_fuel_need_revised 100756
    50346
  """
  @spec determine_fuel_need_revised(number, number) :: number
  def determine_fuel_need_revised(mass, acc \\ 0)
  def determine_fuel_need_revised(0, acc) when is_number(acc) do
    acc
  end
  def determine_fuel_need_revised(mass, acc) when is_number(mass) do
    case determine_fuel_need(mass) do
      new_mass when new_mass > 0  -> determine_fuel_need_revised(new_mass, acc+new_mass)
      _ -> determine_fuel_need_revised(0, acc)
    end
  end

  @doc """
  Handles a list for the new form of fuel determination.
  Something of a DRY violation as it does precisely what the previous version minus one change. TODO: marry the two to follow DRY.
    iex> Advent.Day.One.determine_fuel_need_revised [12, 14, 972167125, 11247751752, 1277512857851728]
    638762538885064
  """
  @spec determine_fuel_need_revised([number], 0) :: number
  def determine_fuel_need_revised(list_of_masses, 0) when is_list(list_of_masses) do
    list_of_masses
    |> Task.async_stream(&determine_fuel_need_revised/1, max_concurrency: System.schedulers_online() * 2)
    |> Enum.reduce(0, fn {:ok, v}, acc -> acc+v end)
  end


  @doc """
  Returns the answers of the Day 1 challenge. Default is for part 1
    iex> Advent.Day.One.get_answer
    3318632
    iex> Advent.Day.One.get_answer 2
    4975084
  """
  @spec get_answer(part :: number) :: integer
  def get_answer(part \\ 1)
  def get_answer(1), do: determine_fuel_need(@d1data)
  def get_answer(2), do: determine_fuel_need_revised(@d1data)
end
