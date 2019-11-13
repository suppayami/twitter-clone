use Mix.Config

# Configure your database
config :kvy, Kvy.Repo,
  username: "postgres",
  password: "postgres",
  database: "twitter_clone_test",
  hostname: "test_db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kvy, KvyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure argon2 for testing
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
