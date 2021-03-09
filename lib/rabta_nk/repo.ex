defmodule RabtaNk.Repo do
  use Ecto.Repo,
    otp_app: :rabta_nk,
    adapter: Ecto.Adapters.Postgres
end
