defmodule Minoa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # we use Faker everywhere, so start it here
    Faker.start()

    children = [
      # Start the Telemetry supervisor
      MinoaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Minoa.PubSub},
      # Start the Endpoint (http/https)
      MinoaWeb.Endpoint,
      Minoa.MazeServer,
      Minoa.PlayerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Minoa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MinoaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
