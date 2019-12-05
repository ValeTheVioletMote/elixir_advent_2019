defmodule Advent.Day.One do


  @spec determine_fuel_need(integer) :: integer
  def determine_fuel_need(mass) when is_integer(mass) do
    mass
    |> div(3)
    |> (&(&1 - 2)).()
  end

  @spec determine_fuel_need([integer]) :: integer
  def determine_fuel_need(list_of_masses) when is_list(list_of_masses) do
    list_of_masses
    |> Task.async_stream(&determine_fuel_need/1, max_concurrency: System.schedulers_online() * 2)
    |> Enum.reduce(0, fn {:ok, v}, acc -> acc+v end)
  end

  @d1data File.read!("data/dayone")
  |> String.split("\n", trim: true)
  |> Enum.map(fn str -> with {n, _} <- Integer.parse(str), do: n end)

  @spec get_answer :: integer
  def get_answer, do: determine_fuel_need(@d1data)

end
