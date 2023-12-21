defmodule Pokemon do
  @enforce_keys [
    :id,
    :name,
    :hp,
    :attack,
    :defense,
    :special_attack,
    :special_defense,
    :speed,
    :weight,
    :height,
    :types
  ]
  defstruct @enforce_keys
end

defmodule Pokelixir do
  @moduledoc """
  Documentation for `Pokelixir`.
  """
  use Application

  @impl true
  def start(_type, _args) do
    # Although we don't use the supervisor name below directly,
    # it can be useful when debugging or introspecting the system.
    Pokelixir.Supervisor.start_link(name: Pokelixir.Supervisor)
  end

  def get_one(pokemon_name) do
    request = Finch.build(:get, "https://pokeapi.co/api/v2/pokemon/#{pokemon_name}")
    response = Finch.request!(request, MyApp.Finch)

    data = Jason.decode!(response.body)
    to_pokemon(data)
  end

  def get_all() do
    request = Finch.build(:get, "https://pokeapi.co/api/v2/pokemon")
    response = Finch.request!(request, MyApp.Finch)
    data = Jason.decode!(response.body)
    count = data["count"]
    url = "https://pokeapi.co/api/v2/pokemon?limit=#{count}"
    request = Finch.build(:get, url)
    response = Finch.request!(request, MyApp.Finch)
    data = Jason.decode!(response.body)
    results = data["results"]

    Enum.map(results, fn result ->
      name = result["name"]
      get_one(name)
    end)
  end

  # Recursive option
  # def get_all() do
  #   url = "https://pokeapi.co/api/v2/pokemon"
  #   fetch_all(url, [])
  # end

  # defp fetch_all(nil, acc), do: acc

  # defp fetch_all(url, acc) do
  #   request = Finch.build(:get, url)
  #   response = Finch.request!(request, MyApp.Finch)
  #   data = Jason.decode!(response.body)
  #   results = data["results"]

  #   pokemon_list =
  #     Enum.map(results, fn result ->
  #       name = result["name"]
  #       get_one(name)
  #     end)

  #   next_url = data["next"]
  #   fetch_all(next_url, acc ++ pokemon_list)
  # end

  def to_pokemon(data) do
    id = data["id"]
    name = data["name"]
    weight = data["weight"]
    height = data["height"]
    types = Enum.map(data["types"], fn type -> type["type"]["name"] end)

    stats =
      Enum.map(data["stats"], fn stat -> {stat["stat"]["name"], stat["base_stat"]} end)
      |> Enum.into(%{})

    hp = Map.get(stats, "hp")
    attack = Map.get(stats, "attack")
    defense = Map.get(stats, "defense")
    special_attack = Map.get(stats, "special-attack")
    special_defense = Map.get(stats, "special-defense")
    speed = Map.get(stats, "speed")

    %Pokemon{
      id: id,
      name: name,
      hp: hp,
      attack: attack,
      defense: defense,
      special_attack: special_attack,
      special_defense: special_defense,
      speed: speed,
      weight: weight,
      height: height,
      types: types
    }
  end
end
