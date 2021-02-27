defmodule Apertivo.Repo do
  use Ecto.Repo,
    otp_app: :apertivo,
    adapter: Ecto.Adapters.Postgres
end
