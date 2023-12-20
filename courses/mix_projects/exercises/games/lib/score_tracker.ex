defmodule Games.ScoreTracker do
  @moduledoc """
   Documentation for `Games.ScoreTracker`.
  """
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :score_tracker)
  end

  def add_points(points) do
    GenServer.cast(:score_tracker, {:add_points, points})
  end

  def current_score() do
    GenServer.call(:score_tracker, :current_score)
  end

  def total_score() do
    score = current_score()

    IO.puts("""
    ====================================
      Your score is #{score}
    ====================================
    """)
  end

  # Define the necessary Server callback functions:
  @impl true
  def init(_opts) do
    {:ok, 0}
  end

  @impl true
  def handle_call(:current_score, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add_points, points}, state) do
    {:noreply, state + points}
  end
end
