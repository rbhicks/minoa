defmodule MinoaWeb.Game do
  use Phoenix.LiveView


  def mount(_params, _session, socket) do
    {:ok, assign(socket,
                 maze: GenServer.call(:maze_server, :get_maze),
                 player_id: UUID.uuid1(),
                 pid: nil)}
  end

  def handle_event(
        "start",
        %{"player_id" => player_id},
        %Phoenix.LiveView.Socket{assigns: %{pid: nil}}=socket) do
    {:ok, pid} = Minoa.PlayerSupervisor.start_player(player_id)
    GenServer.call(pid, :place_player_randomly)
    {:noreply, assign(socket, pid: pid, maze: GenServer.call(:maze_server, :get_maze))}
  end

  def handle_event(
        "start",
        _,
        %Phoenix.LiveView.Socket{assigns: %{pid: pid}}=socket) do
    GenServer.call(pid, :place_player_randomly)
    {:noreply, assign(socket, maze: GenServer.call(:maze_server, :get_maze))}
  end
  
  def handle_event("left", _params, socket) do
    {:noreply, socket}
  end
  
  def render(assigns) do
    ~L"""
    <main>
    <section class="maze">
    <%= for x <- 0..9 do %>
      <%= for y <- 0..9 do %>
        <div class="<%= get_square_class(@pid, @maze[x][y]) %>">
        </div>
      <% end %>
    <% end %>
    </section>
    <section align="center">
      <form phx-submit="start" >
        <input type="submit" value="start"/>
        <input type="edit"
               hidden=true
               name="player_id"
               value= <%= @player_id %> />
        <input type="edit"
               phx-value-player-id="zorg"
               name="player_name"
               value="jumpy monkey"/>
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
end
