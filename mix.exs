defmodule PhoenixQcExample.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_qc_example,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PhoenixQcExample, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :faker, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:quixir, "~> 0.9.1", only: [:dev, :test]},
     {:wallaby, "~> 0.14.0", only: [:dev, :test]},
     {:pollution, "~> 0.9.0", only: [:dev, :test]},
     {:httpoison, "~> 0.10.0"},
     {:faker, "~> 0.7", only: [:dev, :test]},
     {:poison, "~> 2.0"},
   ]
  end
end
