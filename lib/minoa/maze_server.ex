defmodule Minoa.MazeServer do
  @moduledoc """
  """

  use GenServer


  #
  # GenServer Callbacks
  #

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :maze_server)
  end

  def init(_args) do
    
    {:ok, {}}
  end
end
