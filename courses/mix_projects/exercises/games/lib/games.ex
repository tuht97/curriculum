defmodule Games do
  def main(args) do
    choice =
      IO.gets("""
      What game would you like to play?
      1. Guessing Game
      2. Rock Paper Scissors
      3. Wordle

      enter "stop" to exit
      """)
      |> String.trim()

    case choice do
      "1" -> Games.GuessingGame.play()
      "2" -> Games.RockPaperScissors.play()
      "3" -> Games.Wordle.play()
      "stop" -> IO.puts("Exiting the program!")
    end

    unless choice == "stop" do
      main(args)
    end
  end
end
