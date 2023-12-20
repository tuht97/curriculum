defmodule TrafficLightsGridTest do
  use ExUnit.Case
  doctest TrafficLights

  test "current_lights/1 default" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    assert TrafficLights.Grid.current_lights(pid) == [:green, :green, :green, :green, :green]
  end

  test "transition/1" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.current_lights(pid) == [:yellow, :green, :green, :green, :green]
  end

  test "transition/1 6 times" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.current_lights(pid) == [:red, :yellow, :yellow, :yellow, :yellow]
  end
end
