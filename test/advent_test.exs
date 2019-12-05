defmodule AdventTest do
  use ExUnit.Case
  doctest Advent
  doctest Advent.Day.One
  doctest Advent.Day.Two

  test "greets the world" do
    assert Advent.hello() == :world
  end
end
