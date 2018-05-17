use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :real_world, RealWorldWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :real_world, RealWorld.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox
