defmodule Minoa.Player do
  use GenServer


  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: {:global, "player:#{id}"})
  end

  def init(id) do
    {:ok, %{pid: self(), id: id, position: {}}}
  end

  def handle_call(
        :place_player_randomly,
        _from,
        %{pid: pid, position: {}}=state) do    
    {x, y} = GenServer.call(:maze_server, :get_random_open_square)
    {:reply,
     GenServer.call(
       :maze_server,
       {:update_player_position, {{}, {x, y}, pid}}),
     Map.put(state, :position, {x, y})}
  end

  def handle_call(
        :place_player_randomly,
        _from,
        %{pid: pid,
          position: {previous_x, previous_y}}=state) do
    {x, y} = GenServer.call(:maze_server, :get_random_open_square)
    {:reply,
     GenServer.call(
       :maze_server,
       {:update_player_position,
        {{previous_x, previous_y}, {x, y}, pid}}),
     Map.put(state, :position, {x, y})}
  end  
end
