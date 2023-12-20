defmodule Stack do
  @moduledoc """
  iex> {:ok, pid} = Stack.start_link([])
  iex> :ok = Stack.push(pid, 1)
  iex> Stack.pop(pid)
  1
  iex> Stack.pop(pid)
  nil
  """

  use GenServer

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack)
  end

  @doc """
  Remove element from the stack
  ## Examples
      iex> {:ok,pid} = Stack.start_link([])
      iex> Stack.push(pid, 1)
      :ok
  """

  def push(stack_pid, element) do
    GenServer.cast(stack_pid, {:push, element})
  end

  @doc """
  Remove element from the stack
  ## Examples
      iex> {:ok,pid} = Stack.start_link([])
      iex> :ok = Stack.push(pid, 1)
      iex> Stack.pop(pid)
      1
  """

  def pop(stack_pid) do
    GenServer.call(stack_pid, :pop)
  end

  def get_stack(stack_pid) do
    GenServer.call(stack_pid, :get_stack)
  end

  # Define the necessary Server callback functions:
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, state) do
    if state == [] do
      {:reply, nil, state}
    else
      [h | t] = state
      {:reply, h, t}
    end
  end

  @impl true
  def handle_call(:get_stack, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
