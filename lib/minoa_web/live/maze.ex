defmodule MinoaWeb.Maze do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :maze, [])}
  end

  def render(assigns) do
    hero_square = Enum.random(1..100)
    ~L"""
    <main>
    <section class="maze">
    <%= for index <- 1..100 do %>
      <%= if Enum.random(0..1) == 1  do %>
        <div class="closed-square">
          <%= unless index != hero_square do %>
            <div class="hero"></div>
          <% end %>
        </div>
      <% else %>
        <div class="open-square">
          <%= unless index != hero_square do %>
            <div class="hero"></div>
          <% end %>
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
