defmodule Apagati.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ApagatiWeb.Telemetry,
      # Start the Ecto repository
      Apagati.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Apagati.PubSub},
      # Start Finch
      {Finch, name: Apagati.Finch},
      # Start the Endpoint (http/https)
      ApagatiWeb.Endpoint
      # Start a worker by calling: Apagati.Worker.start_link(arg)
      # {Apagati.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apagati.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ApagatiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
