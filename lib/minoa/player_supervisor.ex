defmodule Minoa.PlayerSupervisor do
  use DynamicSupervisor

  
  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_player(id) do
    DynamicSupervisor.start_child(__MODULE__, {Minoa.Player, id})
  end
end
