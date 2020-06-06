defmodule MinoaWeb.Maze do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :maze, [])}
  end

  def render(assigns) do
    ~L"""
    <main class="maze">
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>

      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
      <b class="closed-square"></b>
    </main>
    """
  end
end
