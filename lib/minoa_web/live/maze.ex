defmodule MinoaWeb.Maze do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :maze, GenServer.call(:maze_server, :get_maze))}
  end

  def render(assigns) do
    ~L"""
    <main>
    <section class="maze">
    <%= for i <- 0..9 do %>
      <%= for j <- 0..9 do %>
        <div class="<%= @maze[i][j] %>">
        </div>
      <% end %>
    <% end %>
    </section>
    <section align="center">
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
end
