defmodule Minoa.Player do
  use GenServer

  #
  # GenServer callbacks
  #
  
  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: {:global, "player:#{id}"})
  end

  def init(id) do
    {:ok, %{pid: self(), id: id}}
  end
end
