# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chatter,
  ecto_repos: [Chatter.Repo]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oTQKYo/dJP4iDtEbYR7lKNSIhV107gI3h42KHPCvYZO1J3ZBZrDTJzE2Q631Rj2E",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chatter.PubSub,
  live_view: [signing_salt: "kavNRK4N"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Chatter",
  ttl: {30, :days},
  allowed_drfit: 2000,
  verify_issuer: true,
  secret_key: "IhVAnIXKqC3joIyzEsMtJJK482a/1dvBI3VclQC76xzjCBiyo3foq1OsNlyqEcei", #String used to authenticate json tokens
  serializer: ChatterWeb.GuardianSerializer
  
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
