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

  def handle_call(:get_maze, _from, maze) do
    {:reply, maze, maze}
  end

  def handle_call(:get_random_open_square, _from, maze) do
    {:reply, get_random_open_square(), maze}
  end

  def handle_call(
        {:update_player_position, {{}, {x, y}, pid}},
        _from,
        maze) do
    {:reply, {x, y}, put_in(maze[x][y], pid )}
  end

  def handle_call(
        {:update_player_position,
         {{previous_x, previous_y}, {x, y}, pid}},
        _from,
        maze) do
    maze = put_in(maze[previous_x][previous_y], "open-square")
    {:reply, {x, y}, put_in(maze[x][y], pid)}
  end

  defp generate_maze() do
    Enum.reduce(0..9, %{}, fn y, maze ->
      Map.put(
        maze,
        y,
        Enum.reduce(0..9, %{}, fn x, row ->
          Map.put(
            row,
            x,
            get_square_type(x, y))
        end))
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

  defp get_random_open_square() do
    Enum.random(1..8)
    |> case do
         1 -> {1, 1..8 |> Enum.random}
         2 -> {2, 1..8 |> Enum.random}
         3 -> {3, 1..8 |> Enum.random}
         4 -> {4, 1..8 |> Enum.to_list |> Kernel.--([1, 3, 4, 5, 6]) |> Enum.random}
         5 -> {5, 1..8 |> Enum.to_list |> Kernel.--([4]) |> Enum.random}
         6 -> {6, 1..8 |> Enum.to_list |> Kernel.--([4]) |> Enum.random}
         7 -> {7, 1..8 |> Enum.to_list |> Kernel.--([4]) |> Enum.random}
         8 -> {8, 1..8 |> Enum.random}
       end    
  end
end
