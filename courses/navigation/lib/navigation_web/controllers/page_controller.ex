defmodule NavigationWeb.PageController do
  use NavigationWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def about(conn, _params) do
    render(conn, :about, layout: false)
  end

  def projects(conn, _params) do
    render(conn, :projects, layout: false, count: 0)
  end

  def increment(conn, params) do
    current_count = String.to_integer(params["count"])
    increment_by = String.to_integer(params["increment_by"])
    render(conn, :projects, layout: false, count: current_count + increment_by)
  end
end
