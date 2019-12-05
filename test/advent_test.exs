defmodule AdventTest do
  use ExUnit.Case
  doctest Advent
  doctest Advent.Day.One

  test "greets the world" do
    assert Advent.hello() == :world
  end
end
