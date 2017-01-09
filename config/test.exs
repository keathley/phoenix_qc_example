use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_qc_example, PhoenixQcExample.Endpoint,
  http: [port: 4001],
  server: true

config :phoenix_qc_example, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn
