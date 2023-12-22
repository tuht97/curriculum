defmodule RandomNumberWeb.RandomNumberController do
  use RandomNumberWeb, :controller

  def random_number(conn, _params) do
    render(conn, :random_number, layout: false, random_number: Enum.random(1..100))
  end
end
