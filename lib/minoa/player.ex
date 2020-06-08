defmodule Minoa.Player do
  use GenServer


  def start_link(player_name) do
    GenServer.start_link(__MODULE__, player_name, name: {:global, player_name})
  end

  def init(player_name) do
    {:ok, %{pid: self(), player_name: player_name, position: {}}}
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

  def handle_call(
        {:move_player, "left"},
        _from,
        %{pid: pid,
          position: {previous_x, previous_y}}=state) do
    if(GenServer.call(:maze_server,
          {:closed_square?, {previous_x - 1, previous_y}})) do
      {:reply, {previous_x, previous_y}, state}
    else
      {:reply,
       GenServer.call(
         :maze_server,
         {:update_player_position,
          {{previous_x, previous_y}, {previous_x - 1, previous_y}, pid}}),
       Map.put(state, :position, {previous_x - 1, previous_y})}
    end
  end

  def handle_call(
        {:move_player, "down"},
        _from,
        %{pid: pid,
          position: {previous_x, previous_y}}=state) do
    if(GenServer.call(:maze_server,
          {:closed_square?, {previous_x, previous_y + 1}})) do
      {:reply, {previous_x, previous_y}, state}
    else
        {:reply,
         GenServer.call(
           :maze_server,
           {:update_player_position,
            {{previous_x, previous_y}, {previous_x, previous_y + 1}, pid}}),
         Map.put(state, :position, {previous_x, previous_y + 1})}
    end
  end

  def handle_call(
        {:move_player, "up"},
        _from,
        %{pid: pid,
          position: {previous_x, previous_y}}=state) do
    if(GenServer.call(:maze_server,
          {:closed_square?, {previous_x, previous_y - 1}})) do
      {:reply, {previous_x, previous_y}, state}
    else
        {:reply,
         GenServer.call(
           :maze_server,
           {:update_player_position,
            {{previous_x, previous_y}, {previous_x, previous_y - 1}, pid}}),
         Map.put(state, :position, {previous_x, previous_y - 1})}
    end
  end

  def handle_call(
        {:move_player, "right"},
        _from,
        %{pid: pid,
          position: {previous_x, previous_y}}=state) do
    if(GenServer.call(:maze_server,
          {:closed_square?, {previous_x + 1, previous_y}})) do
      {:reply, {previous_x, previous_y}, state}
    else
        {:reply,
         GenServer.call(
           :maze_server,
           {:update_player_position,
            {{previous_x, previous_y}, {previous_x + 1, previous_y}, pid}}),
         Map.put(state, :position, {previous_x + 1, previous_y})}
    end
  end

  def handle_call(
        :get_position,
        _from,
        %{position: {x, y}}=state) do
    {:reply, {x, y}, state}
  end

  def handle_call(
        :kill_player,
        _from,
        %{position: {x, y}}=state) do    
    {:reply,
     GenServer.call(
       :maze_server,
       {:remove_player, {x, y}}),
     Map.put(state, :position, {})}
  end
end
