defmodule PlayerTest do
  use ExSpec, async: false

  describe "the maze server" do
    context "the placement and movement handlers:" do
      it ":place_player_randomly should work" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())
        {x, y} = GenServer.call(player_pid, :place_player_randomly)
        updated_maze = GenServer.call(:maze_server, :get_maze)

        assert updated_maze[x][y] |> hd() == player_pid
      end

      it ":move_player left when left is open should work" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {2, 2}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {2, 2}})
        GenServer.call(player_pid, {:move_player, "left"})

        assert GenServer.call(:maze_server, :get_maze)[1][2] |> hd() == player_pid
      end

      it ":move_player left when left is closed shouldn't move" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {1, 1}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {1, 1}})
        GenServer.call(player_pid, {:move_player, "left"})

        assert GenServer.call(:maze_server, :get_maze)[1][1] |> hd() == player_pid
      end

      it ":move_player right when left is open should work" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {2, 2}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {2, 2}})
        GenServer.call(player_pid, {:move_player, "right"})

        assert GenServer.call(:maze_server, :get_maze)[3][2] |> hd() == player_pid
      end

      it ":move_player right when right is closed shouldn't move" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {8, 1}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {8, 1}})
        GenServer.call(player_pid, {:move_player, "right"})

        assert GenServer.call(:maze_server, :get_maze)[8][1] |> hd() == player_pid
      end

      it ":move_player up when left is open should work" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {2, 2}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {2, 2}})
        GenServer.call(player_pid, {:move_player, "up"})

        assert GenServer.call(:maze_server, :get_maze)[2][1] |> hd() == player_pid
      end

      it ":move_player up when right is closed shouldn't move" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {1, 1}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {1, 1}})
        GenServer.call(player_pid, {:move_player, "up"})

        assert GenServer.call(:maze_server, :get_maze)[1][1] |> hd() == player_pid
      end

      it ":move_player up when down is open should work" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {2, 2}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {2, 2}})
        GenServer.call(player_pid, {:move_player, "down"})

        assert GenServer.call(:maze_server, :get_maze)[2][3] |> hd() == player_pid
      end

      it ":move_player up when down is closed shouldn't move" do
        {:ok, player_pid} = Minoa.PlayerSupervisor.start_player(Faker.Nato.callsign())

        GenServer.call(
          :maze_server,
          {:update_player_position, {{}, {1, 8}, player_pid}}
        )

        GenServer.call(player_pid, {:set_position, {1, 8}})
        GenServer.call(player_pid, {:move_player, "down"})

        assert GenServer.call(:maze_server, :get_maze)[1][8] |> hd() == player_pid
      end
    end
  end
end
