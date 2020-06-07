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
    {:ok, generate_maze()}
  end

  def handle_call(:get_maze, _from, maze) do
    {:reply, maze, maze}
  end

  #
  # implementation
  #

  defp generate_maze() do
    make_solid_grid()
    |> carve_grid_into_maze()
  end

  defp make_solid_grid() do
    Enum.reduce(0..9, %{}, fn i, maze ->
      Map.put(
        maze,
        i,
        Enum.reduce(0..9, %{}, fn j, row ->
          Map.put(row, j, "closed-square")
        end))
    end)
  end

  defp carve_grid_into_maze(solid_grid) do
    open_square(solid_grid, 1, 1)    
    |> open_square(1, 2)
    |> open_square(1, 3)
    |> open_square(1, 4)
    |> open_square(1, 5)
    |> open_square(1, 6)
    |> open_square(1, 7)
    |> open_square(1, 8)
    |> open_square(2, 1)
    |> open_square(2, 2)
    |> open_square(2, 3)
    |> open_square(2, 4)
    |> open_square(2, 5)
    |> open_square(2, 6)
    |> open_square(2, 7)
    |> open_square(2, 8)
    |> open_square(3, 1)
    |> open_square(3, 2)
    |> open_square(3, 3)
    |> open_square(3, 4)
    |> open_square(3, 5)
    |> open_square(3, 6)
    |> open_square(3, 7)
    |> open_square(3, 8)
    |> open_square(4, 2)
    |> open_square(4, 7)
    |> open_square(4, 8)
    |> open_square(5, 1)
    |> open_square(5, 2)
    |> open_square(5, 3)
    |> open_square(5, 5)
    |> open_square(5, 6)
    |> open_square(5, 7)
    |> open_square(5, 8)
    |> open_square(6, 1)
    |> open_square(6, 2)
    |> open_square(6, 3)
    |> open_square(6, 5)
    |> open_square(6, 6)
    |> open_square(6, 7)
    |> open_square(6, 8)
    |> open_square(7, 1)
    |> open_square(7, 2)
    |> open_square(7, 3)
    |> open_square(7, 5)
    |> open_square(7, 6)
    |> open_square(7, 7)
    |> open_square(7, 8)
    |> open_square(8, 1)
    |> open_square(8, 2)
    |> open_square(8, 3)
    |> open_square(8, 4)
    |> open_square(8, 5)
    |> open_square(8, 6)
    |> open_square(8, 7)
    |> open_square(8, 8)
  end

  defp open_square(maze, i, j) do
    put_in(maze[i][j], "open-square")
  end
  
  # defp carve_grid_into_maze(solid_grid) do
  #   carve_grid_into_maze(
  #     solid_grid,
  #     {Enum.random(1..8), Enum.random(1..8)},
  #     MapSet.new())
  # end

  # defp carve_grid_into_maze(maze, coordinate, visited_squares) do
  #   if((visited_squares |> MapSet.size()) < 64) do
  #     carve_grid_into_maze(
  #       put_in(maze[(coordinate |> elem(0))][(coordinate |> elem(1))], "open-square"),
  #       get_next_coordinate(coordinate),
  #       MapSet.put(visited_squares, coordinate))
  #   else
  #     maze
  #   end
  # end

  # defp get_next_coordinate(coordinate) do
  #   [:north, :south, :east, :west]
  #   |> Enum.random()
  #   |> (&get_next_coordinate(coordinate, &1)).()
  # end

  # defp get_next_coordinate(coordinate, :north) do
  #   if((coordinate |> elem(1)) == 1) do
  #     # can't go north into the border, so head south
  #     {(coordinate |> elem(0)), (coordinate |> elem(1) |> Kernel.+(1))}
  #   else
  #     {(coordinate |> elem(0)), (coordinate |> elem(1) |> Kernel.-(1))}
  #   end
  # end

  # defp get_next_coordinate(coordinate, :south) do
  #   if((coordinate |> elem(1)) == 8) do
  #     # can't go south into the border, so head north
  #     {(coordinate |> elem(0)), (coordinate |> elem(1) |> Kernel.-(1))}
  #   else
  #     {(coordinate |> elem(0)), (coordinate |> elem(1) |> Kernel.+(1))}
  #   end
  # end

  # defp get_next_coordinate(coordinate, :east) do
  #   if((coordinate |> elem(0)) == 8) do
  #     # can't go east into the border, so head west
  #     {(coordinate |> elem(0) |> Kernel.-(1)), (coordinate |> elem(1))}
  #   else
  #     {(coordinate |> elem(0) |> Kernel.+(1)), (coordinate |> elem(1))}
  #   end
  # end

  # defp get_next_coordinate(coordinate, :west) do
  #   if((coordinate |> elem(0)) == 1) do
  #     # can't go west into the border, so head east
  #     {(coordinate |> elem(0) |> Kernel.+(1)), (coordinate |> elem(1))}
  #   else
  #     {(coordinate |> elem(0) |> Kernel.-(1)), (coordinate |> elem(1))}
  #   end
  # end
  
end
