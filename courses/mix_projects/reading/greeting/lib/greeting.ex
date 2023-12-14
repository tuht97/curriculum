defmodule Greeting do
  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [time: :string, upcase: :boolean])
    upcase = opts[:upcase] || false

    if upcase,
      do: IO.puts(String.upcase("Good #{opts[:time] || "morning"}!")),
      else: IO.puts("Good #{opts[:time] || "morning"}!")
  end
end
