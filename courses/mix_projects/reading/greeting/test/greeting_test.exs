defmodule GreetingTest do
  use ExUnit.Case
  doctest Greeting

  test "greets the world" do
    assert Greeting.hello() == :world
  end
end
