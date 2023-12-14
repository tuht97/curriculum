defmodule Games.GuessingGame do
  @moduledoc """
   Documentation for `Games.GuessingGame`.
  """
  def play do
    rand_numb = Enum.random(1..10)
    IO.puts("Guess a number between 1 and 10:")
    guess_loop(rand_numb, 10)
  end

  defp guess_loop(rand_numb, 0), do: IO.puts("You lose! the answer was #{rand_numb}")

  defp guess_loop(rand_numb, attempts) do
    guess_numb = IO.gets("Enter your guess:") |> String.trim() |> String.to_integer()

    cond do
      guess_numb == rand_numb ->
        IO.puts("Correct!")

      guess_numb < rand_numb ->
        IO.puts("Too Low!")
        guess_loop(rand_numb, attempts - 1)

      guess_numb > rand_numb ->
        IO.puts("Too High!")
        guess_loop(rand_numb, attempts - 1)
    end
  end
end
