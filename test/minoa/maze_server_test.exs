defmodule MazeServerTest do

  #  use ExUnit.Case, async: true
  use ExSpec, async: true

  setup do
    on_exit fn ->
      GenServer.call(:maze_server, :reset_maze)
    end

    {:ok, initial_maze: GenServer.call(:maze_server, :get_maze)}
  end

  describe "the maze server" do
    context "by getting the initial maze:" do
      it "should have a solid square outer border", %{initial_maze: maze} do
        verify_outer_border(maze)
      end

      it "should have the correct internal closed square structure", %{initial_maze: maze} do
        verify_internal_closed_square_structure(maze)
      end

      it "should have the correct internal open square structure", %{initial_maze: maze} do
        verify_internal_open_square_structure(maze)
      end
    end

    context "by getting the regenerated maze:" do
      it "should have a solid square outer border" do
        verify_outer_border(GenServer.call(:maze_server, :reset_maze))
      end

      it "should have the correct internal closed square structure" do
        verify_internal_closed_square_structure(GenServer.call(:maze_server, :reset_maze))
      end

      it "should have the correct internal open square structure" do
        verify_internal_open_square_structure(GenServer.call(:maze_server, :reset_maze))
      end
    end
    
    context "by placing and removing players:" do
      it "updating a player position and retrieving the maze should show the player in that postion" do

        player_position_x = 3
        player_position_y = 3
        pid = self()

        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {player_position_x, player_position_y},
            pid}})

        assert GenServer.call(:maze_server, :get_maze)[player_position_x][player_position_y] |> hd() == pid
      end

      it "updating a player position, removening it, and retrieving the maze should show the postion empty" do

        player_position_x = 3
        player_position_y = 3
        pid = self()

        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {player_position_x, player_position_y},
            pid}})

        GenServer.call(
          :maze_server,
          {:remove_player,
           {player_position_x, player_position_y}, pid})

        assert GenServer.call(:maze_server, :get_maze)[player_position_x][player_position_y] |> hd() == "open-square"
      end
    end

    context "checking informational message handlers:" do
      it ":get_random_open_square provides open squares at least 10000 times in a row in the default maze",
        %{initial_maze: maze} do
        Enum.each(0..9999, fn _ ->
          {x, y} = GenServer.call(:maze_server, :get_random_open_square)
          assert maze[x][y] |> hd() != "closed-square"
        end)        
      end

      it ":get_random_open_square provides open squares at least 10000 times in a row in an updated maze" do
        player_position_x = 3
        player_position_y = 3
        {:ok, enemy_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {player_position_x, player_position_y},
            enemy_pid}})
        
        updated_maze = GenServer.call(:maze_server, :get_maze)

        Enum.each(0..9999, fn _ ->
          {x, y} = GenServer.call(:maze_server, :get_random_open_square)
          assert updated_maze[x][y] |> hd() != "closed-square"
        end)
      end

      it ":get_enemy_pids returns all other players pids" do
        {:ok, enemy_0_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())
        {:ok, enemy_1_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())
        {:ok, enemy_2_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())
        {:ok, player_pid}  = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {1, 1},
            enemy_0_pid}})
        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {2, 2},
            enemy_1_pid}})
        GenServer.call(
          :maze_server,
          {:update_player_position,
           {{}, {2, 2},
            enemy_2_pid}})
        
        single_enemy = GenServer.call(:maze_server, {:get_enemy_pids, player_pid, {1, 1}})
        two_enemies  = GenServer.call(:maze_server, {:get_enemy_pids, player_pid, {2, 2}})

        assert single_enemy == [enemy_0_pid]
        assert two_enemies  == [enemy_2_pid, enemy_1_pid]
      end
    end
  end    

  defp verify_outer_border(maze) do

    # leftmost column
    assert maze[0][0] |> hd() == "closed-square"
    assert maze[0][1] |> hd() == "closed-square"
    assert maze[0][2] |> hd() == "closed-square"
    assert maze[0][3] |> hd() == "closed-square"
    assert maze[0][4] |> hd() == "closed-square"
    assert maze[0][5] |> hd() == "closed-square"
    assert maze[0][6] |> hd() == "closed-square"
    assert maze[0][7] |> hd() == "closed-square"
    assert maze[0][8] |> hd() == "closed-square"
    assert maze[0][9] |> hd() == "closed-square"

    # top row (without the ends that are tested
    # with the columns)
    assert maze[1][0] |> hd() == "closed-square"
    assert maze[2][0] |> hd() == "closed-square"
    assert maze[3][0] |> hd() == "closed-square"
    assert maze[4][0] |> hd() == "closed-square"
    assert maze[5][0] |> hd() == "closed-square"
    assert maze[6][0] |> hd() == "closed-square"
    assert maze[7][0] |> hd() == "closed-square"
    assert maze[8][0] |> hd() == "closed-square"
    
    # bottom row (without the ends that are
    # tested with the columns)
    assert maze[1][9] |> hd() == "closed-square"
    assert maze[2][9] |> hd() == "closed-square"
    assert maze[3][9] |> hd() == "closed-square"
    assert maze[4][9] |> hd() == "closed-square"
    assert maze[5][9] |> hd() == "closed-square"
    assert maze[6][9] |> hd() == "closed-square"
    assert maze[7][9] |> hd() == "closed-square"
    assert maze[8][9] |> hd() == "closed-square"

    # rightmost column
    assert maze[9][0] |> hd() == "closed-square"
    assert maze[9][1] |> hd() == "closed-square"
    assert maze[9][2] |> hd() == "closed-square"
    assert maze[9][3] |> hd() == "closed-square"
    assert maze[9][4] |> hd() == "closed-square"
    assert maze[9][5] |> hd() == "closed-square"
    assert maze[9][6] |> hd() == "closed-square"
    assert maze[9][7] |> hd() == "closed-square"
    assert maze[9][8] |> hd() == "closed-square"
    assert maze[9][9] |> hd() == "closed-square"
  end

  def verify_internal_closed_square_structure(maze) do
    assert maze[1][4] |> hd() == "closed-square"
    assert maze[3][4] |> hd() == "closed-square"
    assert maze[4][4] |> hd() == "closed-square"
    assert maze[5][4] |> hd() == "closed-square"
    assert maze[6][4] |> hd() == "closed-square"
    assert maze[4][5] |> hd() == "closed-square"
    assert maze[4][6] |> hd() == "closed-square"
    assert maze[4][7] |> hd() == "closed-square"
  end

  def verify_internal_open_square_structure(maze) do
    assert maze[1][1] |> hd() == "open-square"
    assert maze[2][1] |> hd() == "open-square"
    assert maze[3][1] |> hd() == "open-square"
    assert maze[4][1] |> hd() == "open-square"
    assert maze[5][1] |> hd() == "open-square"
    assert maze[6][1] |> hd() == "open-square"
    assert maze[7][1] |> hd() == "open-square"
    assert maze[8][1] |> hd() == "open-square"

    assert maze[1][2] |> hd() == "open-square"
    assert maze[2][2] |> hd() == "open-square"
    assert maze[3][2] |> hd() == "open-square"
    assert maze[4][2] |> hd() == "open-square"
    assert maze[5][2] |> hd() == "open-square"
    assert maze[6][2] |> hd() == "open-square"
    assert maze[7][2] |> hd() == "open-square"
    assert maze[8][2] |> hd() == "open-square"

    assert maze[1][3] |> hd() == "open-square"
    assert maze[2][3] |> hd() == "open-square"
    assert maze[3][3] |> hd() == "open-square"
    assert maze[4][3] |> hd() == "open-square"
    assert maze[5][3] |> hd() == "open-square"
    assert maze[6][3] |> hd() == "open-square"
    assert maze[7][3] |> hd() == "open-square"
    assert maze[8][3] |> hd() == "open-square"

    assert maze[2][4] |> hd() == "open-square"
    assert maze[7][4] |> hd() == "open-square"
    assert maze[8][4] |> hd() == "open-square"

    assert maze[1][5] |> hd() == "open-square"
    assert maze[2][5] |> hd() == "open-square"
    assert maze[3][5] |> hd() == "open-square"
    assert maze[5][5] |> hd() == "open-square"
    assert maze[6][5] |> hd() == "open-square"
    assert maze[7][5] |> hd() == "open-square"
    assert maze[8][5] |> hd() == "open-square"
        
    assert maze[1][6] |> hd() == "open-square"
    assert maze[2][6] |> hd() == "open-square"
    assert maze[3][6] |> hd() == "open-square"
    assert maze[5][6] |> hd() == "open-square"
    assert maze[6][6] |> hd() == "open-square"
    assert maze[7][6] |> hd() == "open-square"
    assert maze[8][6] |> hd() == "open-square"

    assert maze[1][7] |> hd() == "open-square"
    assert maze[2][7] |> hd() == "open-square"
    assert maze[3][7] |> hd() == "open-square"
    assert maze[5][7] |> hd() == "open-square"
    assert maze[6][7] |> hd() == "open-square"
    assert maze[7][7] |> hd() == "open-square"
    assert maze[8][7] |> hd() == "open-square"
        
    assert maze[1][8] |> hd() == "open-square"
    assert maze[2][8] |> hd() == "open-square"
    assert maze[3][8] |> hd() == "open-square"
    assert maze[4][8] |> hd() == "open-square"
    assert maze[5][8] |> hd() == "open-square"
    assert maze[6][8] |> hd() == "open-square"
    assert maze[7][8] |> hd() == "open-square"
    assert maze[8][8] |> hd() == "open-square"
  end
end
