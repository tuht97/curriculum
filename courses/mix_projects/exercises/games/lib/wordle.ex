defmodule Games.Wordle do
  def feedback(answer, guess) do
    answer_list = String.to_charlist(answer)
    guess_list = String.to_charlist(guess)

    pairs = Enum.zip(answer_list, guess_list)

    {feedback_list, _answer_list} =
      Enum.reduce(pairs, {[], answer_list}, fn {a, g}, {feedback, answer} ->
        cond do
          a == g ->
            answer = List.delete(answer, a)

            {[:green | feedback], answer}

          g in answer ->
            answer = List.delete(answer, g)

            {[:yellow | feedback], answer}

          true ->
            {[:grey | feedback], answer}
        end
      end)

    Enum.reverse(feedback_list)
  end

  def play() do
    word = ["toast", "tarts", "hello", "beats"] |> Enum.random()
    play(word, 6)
  end

  defp play(word, tries) do
    if tries > 0 do
      IO.puts("Enter a five letter word:")
      guess = IO.gets("> ")

      if String.length(guess) == 6 do
        guess = String.trim(guess)

        if guess == word do
          IO.puts("You guessed it! The word was #{word}.")
          IO.puts("You win!")
        else
          feedback = feedback(word, guess)

          IO.puts(
            Enum.zip(String.split(guess, "", trim: true), feedback)
            |> Enum.map(fn {char, color} ->
              case color do
                :green -> IO.ANSI.green() <> char <> IO.ANSI.reset()
                :yellow -> IO.ANSI.yellow() <> char <> IO.ANSI.reset()
                :grey -> IO.ANSI.light_black() <> char <> IO.ANSI.reset()
              end
            end)
            |> List.to_string()
          )

          IO.puts("You have #{tries - 1} tries left.")
          play(word, tries - 1)
        end
      else
        IO.puts("Please enter a five letter word.")
        play(word, tries)
      end
    else
      IO.puts("You ran out of tries. The word was #{word}.")
      IO.puts("You lose.")
    end
  end
end
