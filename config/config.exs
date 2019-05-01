# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :demo,
  ecto_repos: [Demo.Repo]

# Configures the endpoint
config :demo, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DgdIVBLQQIFKCMxSQGnZhi7JtDnJ4qpMrZiCPls0KrrH+QQj07EF8YT4ARz9pW7k",
  render_errors: [view: DemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Demo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user,user:email,public_repo"]},
    twitter: {Ueberauth.Strategy.Twitter, []},
    instagram: {Ueberauth.Strategy.Instagram, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "c8e6aff8b43475f74d44",
  client_secret: "5d0e41f9345bb5cf54ba3872f636b87200a83145"

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: "Xvqy1r5Zakci1MHV11ffEbsyw",
  consumer_secret: "50EdLLHeFYHmw2qspTnR0uqyc2JT5UuzH2qfCxvodplGBkDJGP"

config :ueberauth, Ueberauth.Strategy.Instagram.OAuth,
  client_id: "736f8eec4ead46438f0c3bf6ac169eb5",
  client_secret: "80f14837cf454d5bbb8d84889e69530e"
