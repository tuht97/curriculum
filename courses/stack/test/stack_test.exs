defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "start_link/1 - default state" do
    {:ok, pid} = Stack.start_link([])
    assert Stack.get_stack(pid) == []
  end

  test "start_link/1 - default configuration" do
    {:ok, pid} = Stack.start_link(["a", "b", "c"])
    assert Stack.get_stack(pid) == ["a", "b", "c"]
  end

  test "pop/1 - remove one element from stack" do
    {:ok, pid} = Stack.start_link(["a", "b", "c"])
    assert Stack.pop(pid) == "a"
    assert Stack.get_stack(pid) == ["b", "c"]
  end

  test "pop/1 - remove multiple elements from stack" do
    {:ok, pid} = Stack.start_link(["a", "b", "c"])
    assert Stack.pop(pid) == "a"
    assert Stack.pop(pid) == "b"
    assert Stack.get_stack(pid) == ["c"]
  end

  test "pop/1 - remove element from empty stack" do
    {:ok, pid} = Stack.start_link([])
    assert Stack.pop(pid) == nil
    assert Stack.get_stack(pid) == []
  end

  test "push/2 - add element to empty stack" do
    {:ok, pid} = Stack.start_link([])
    Stack.push(pid, "a")
    assert Stack.get_stack(pid) == ["a"]
  end

  test "push/2 - add element to stack with multiple elements" do
    {:ok, pid} = Stack.start_link([])
    Stack.push(pid, "b")
    Stack.push(pid, "a")
    assert Stack.get_stack(pid) == ["a", "b"]
  end
end
