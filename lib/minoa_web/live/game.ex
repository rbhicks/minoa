defmodule MinoaWeb.Game do
  use Phoenix.LiveView


  def mount(_params, _session, socket) do
    {:ok, assign(socket,
                 maze: GenServer.call(:maze_server, :get_maze),
                 pid: nil)}
  end

  def handle_event(
        "start",
        %{"player_name" => player_name},
        %Phoenix.LiveView.Socket{assigns: %{pid: nil}}=socket) do
    if(GenServer.whereis({:global, player_name})) do
      {:noreply,
       assign(
         socket,
         pid: GenServer.whereis({:global, player_name}),
         maze: GenServer.call(:maze_server, :get_maze))}
    else
      {:ok, pid} = Minoa.PlayerSupervisor.start_player(player_name)
      GenServer.call(pid, :place_player_randomly)
      {:noreply,
       assign(
         socket,
         pid: pid,
         maze: GenServer.call(:maze_server, :get_maze))}
    end
  end

  def handle_event(
        "start",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, :place_player_randomly)
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end
  
  def handle_event("left",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, {:move_player, "left"})
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end

  def handle_event("down",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, {:move_player, "down"})
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end

  def handle_event("up",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, {:move_player, "up"})
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end

  def handle_event("right",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, {:move_player, "right"})
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end

  def handle_event("attack",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    pid
    |> GenServer.call(:get_position)
    |> get_squares_within_attack_range()
    |> Enum.each(fn target_coordinates ->
      if GenServer.call(:maze_server, {:get_enemy_pid, target_coordinates}) |> is_pid() do
        GenServer.call(:maze_server, {:get_enemy_pid, target_coordinates})
        |> GenServer.call(:kill_player)        
      end      
    end)
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end
  
  def render(assigns) do
    ~L"""
    <main>
    <section class="maze">
    <%= for y <- 0..9 do %>
      <%= for x <- 0..9 do %>
        <div class="<%= get_square_class(@pid, @maze[x][y] |> hd()) %>">
        </div>
      <% end %>
    <% end %>
    </section>
    <section align="center">
      <form phx-submit="start" >
        <input type="submit" value="start"/>
        <input type="edit"
               name="player_name"
               value="<%= Faker.Commerce.product_name() %>"/>
      </form>
      <span></span>
      <button phx-click="left">left</button>
      <button phx-click="down">down</button>
      <button phx-click="up">up</button>
      <button phx-click="right">right</button>
      <span></span>
      <button phx-click="attack">attack</button>
    </section>
    </main>
    """
  end

  defp get_square_class(player_pid, class_determinant) when is_pid(class_determinant) do
    if(player_pid == class_determinant) do
      "hero"
    else
      "enemy"
    end
  end

  defp get_square_class(nil, class_determinant), do: class_determinant
  defp get_square_class(_pid, class_determinant), do: class_determinant

  defp get_squares_within_attack_range(coordinates) do
    get_surrounding_deltas()
    |> Enum.reduce([], fn deltas, squares_within_attack_range ->
      if GenServer.call(:maze_server,
                        {:closed_square?,
                        translate_coordinates(coordinates, deltas)}) do
        squares_within_attack_range
      else
        squares_within_attack_range ++ [translate_coordinates(coordinates, deltas)]
      end
    end)
  end

  defp get_surrounding_deltas() do
    [
      {0,  -1},
      {1,  -1},
      {1,   0},
      {1,   1},
      {0,   1},
      {-1,  1},
      {-1,  0},
      {-1, -1}
    ]
  end

  defp translate_coordinates(coordinates, deltas) do
    {coordinates |> elem(0) |> Kernel.+(deltas |> elem(0)),
     coordinates |> elem(1) |> Kernel.+(deltas |> elem(1))}
  end
  
end
