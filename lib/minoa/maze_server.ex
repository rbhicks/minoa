defmodule Minoa.MazeServer do
  @moduledoc """
  """

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :maze_server)
  end

  def init(_args) do
    {:ok, generate_maze()}
  end

  # currently only used for testing, but could be
  # used for future enhancements
  def handle_call(:reset_maze, _from, _maze) do
    maze = generate_maze()
    {:reply, maze, maze}
  end

  def handle_call(:get_maze, _from, maze) do
    {:reply, maze, maze}
  end

  def handle_call(:get_random_open_square, _from, maze) do
    {:reply, get_random_open_square(), maze}
  end

  # there might not be one, but returning [] when there isn't
  # allows us to only check the surrounding squares
  def handle_call({:get_enemy_pids, player_pid, {x, y}}, _from, maze) do
    {:reply, get_enemy_pids(x, y, maze, player_pid), maze}
  end

  def handle_call(
        {:remove_player, {x, y}, pid},
        _from,
        maze
      ) do
    {:reply, {x, y}, put_in(maze[x][y], maze[x][y] |> List.delete(pid))}
  end

  def handle_call(
        {:update_player_position, {{}, {x, y}, pid}},
        _from,
        maze
      ) do
    {:reply, {x, y}, put_in(maze[x][y], [pid | maze[x][y]])}
  end

  def handle_call(
        {:update_player_position, {{previous_x, previous_y}, {x, y}, pid}},
        _from,
        maze
      ) do
    maze = put_in(maze[previous_x][previous_y], maze[previous_x][previous_y] |> tl())
    {:reply, {x, y}, put_in(maze[x][y], [pid | maze[x][y]])}
  end

  def handle_call(
        {:closed_square?, {x, y}},
        _from,
        maze
      ) do
    {:reply, closed_square?(x, y), maze}
  end

  defp generate_maze() do
    Enum.reduce(0..9, %{}, fn x, maze ->
      Map.put(
        maze,
        x,
        Enum.reduce(0..9, %{}, fn y, column ->
          Map.put(
            column,
            y,
            [get_square_type(x, y)]
          )
        end)
      )
    end)
  end

  defp get_square_type(x, y) do
    if(closed_square?(x, y)) do
      "closed-square"
    else
      "open-square"
    end
  end

  defp closed_square?(x, y) do
    cond do
      x == 0 -> true
      x == 9 -> true
      y == 0 -> true
      y == 9 -> true
      x == 1 && y == 4 -> true
      x > 2 && x < 7 && y == 4 -> true
      x == 4 && y > 4 && y < 8 -> true
      true -> false
    end
  end

  defp get_random_open_square do
    Enum.random(1..8)
    |> case do
      1 -> {1, 1..8 |> Enum.to_list() |> Kernel.--([4]) |> Enum.random()}
      2 -> {2, 1..8 |> Enum.to_list() |> Enum.random()}
      3 -> {3, 1..8 |> Enum.to_list() |> Kernel.--([4]) |> Enum.random()}
      4 -> {4, 1..8 |> Enum.to_list() |> Kernel.--([4, 5, 6, 7]) |> Enum.random()}
      5 -> {5, 1..8 |> Enum.to_list() |> Kernel.--([4]) |> Enum.random()}
      6 -> {6, 1..8 |> Enum.to_list() |> Kernel.--([4]) |> Enum.random()}
      7 -> {7, 1..8 |> Enum.to_list() |> Enum.random()}
      8 -> {8, 1..8 |> Enum.to_list() |> Enum.random()}
    end
  end

  defp get_enemy_pids(x, y, maze, player_pid) do
    maze[x][y]
    |> Enum.map(fn square_status ->
      if(square_status |> is_pid()) do
        unless square_status == player_pid do
          square_status
        end
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end
end
