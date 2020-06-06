defmodule MinoaWeb.Maze do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :maze, [])}
  end

  def render(assigns) do
    hero_square = Enum.random(1..100)
    ~L"""
    <main class="maze">
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
    </main>
    """
  end
end
