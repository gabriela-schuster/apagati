defmodule Apagati.Repo do
  use Ecto.Repo,
    otp_app: :apagati,
    adapter: Ecto.Adapters.Postgres
end
