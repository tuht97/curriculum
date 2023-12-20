defmodule TrafficLights.Light do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  def transition(pid) do
    GenServer.call(pid, :transition)
  end

  def current_light(pid) do
    GenServer.call(pid, :current_light)
  end

  @impl true
  def init(_opts) do
    {:ok, :green}
  end

  @impl true
  def handle_call(:transition, _from, state) do
    next_state =
      case state do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end

    {:reply, next_state, next_state}
  end

  @impl true
  def handle_call(:current_light, _from, state) do
    {:reply, state, state}
  end
end
