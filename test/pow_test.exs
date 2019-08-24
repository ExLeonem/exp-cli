defmodule PowTest do
  use ExUnit.Case
  doctest Pow

  test "greets the world" do
    assert Pow.hello() == :world
  end
end
