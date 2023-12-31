defmodule Games.RockPaperScissors do
  @moduledoc """
   Documentation for `Games.RockPaperScissors`.
  """
  @spec play :: :ok
  def play do
    rand_choice = Enum.random(["rock", "paper", "scissors"])
    guess = IO.gets("Choose rock, paper, or scissors:") |> String.trim()

    case {guess, rand_choice} do
      {"rock", "scissors"} ->
        Games.ScoreTracker.add_points(10)
        IO.puts("You win! rock beats scissors.")

      {"rock", "paper"} ->
        IO.puts("You lose! paper beats rock.")

      {"paper", "rock"} ->
        Games.ScoreTracker.add_points(10)
        IO.puts("You win! paper beats rock.")

      {"paper", "scissors"} ->
        IO.puts("You lose! scissors beats paper.")

      {"scissors", "paper"} ->
        Games.ScoreTracker.add_points(10)
        IO.puts("You win! scissors beats paper.")

      {"scissors", "rock"} ->
        IO.puts("You lose! rock beats scissors.")

      {_, _} ->
        IO.puts("It's a tie!")
    end
  end
end
