defmodule CheckPoint.Repo do
  use Ecto.Repo,
    otp_app: :check_point,
    adapter: Ecto.Adapters.SQLite3
end
