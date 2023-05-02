defmodule GamcoTest do
  use ExUnit.Case
  doctest Gamco

  test "greets the world" do
    assert Gamco.hello() == :world
  end
end
