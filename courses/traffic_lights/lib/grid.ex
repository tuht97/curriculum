defmodule TrafficLights.Grid do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {[], 0})
  end

  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  def current_lights(pid) do
    GenServer.call(pid, :current_lights)
  end

  @impl true
  def init(_opts) do
    lights = Enum.map(1..5, fn _ -> TrafficLights.Light.start_link([]) |> elem(1) end)
    {:ok, {lights, 0}}
  end

  @impl true
  def handle_cast(:transition, {lights, index}) do
    TrafficLights.Light.transition(Enum.at(lights, index))
    next_index = rem(index + 1, length(lights))
    {:noreply, {lights, next_index}}
  end

  @impl true
  def handle_call(:current_lights, _from, {lights, index}) do
    states = Enum.map(lights, &TrafficLights.Light.current_light/1)
    {:reply, states, {lights, index}}
  end
end
