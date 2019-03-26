defmodule SIOMockTest do
  use ExUnit.Case
  doctest SIOMock

  test "greets the world" do
    assert SIOMock.hello() == :world
  end
end
