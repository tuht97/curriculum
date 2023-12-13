defmodule GamesWordleTest do
  use ExUnit.Case
  doctest Games.Wordle

  test "all match and correct order" do
    assert Games.Wordle.feedback("aaaaa", "aaaaa") == [:green, :green, :green, :green, :green]
  end

  test "one wrong" do
    assert Games.Wordle.feedback("aaaaa", "aaaab") ==
             [:green, :green, :green, :green, :grey]
  end

  test "all match but wrong order" do
    assert Games.Wordle.feedback("abdce", "edcba") ==
             [:yellow, :yellow, :yellow, :yellow, :yellow]
  end

  test "mix" do
    assert Games.Wordle.feedback("aaabb", "xaaaa") ==
             [:grey, :green, :green, :yellow, :grey]
  end
end
