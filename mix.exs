defmodule Gamco.MixProject do
  use Mix.Project

  @source_url "https://github.com/amco/gamco-ex"
  @version "0.1.1"

  def project do
    [
      app: :gamco,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: @source_url,
      homepage_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, ">= 1.4.0"},
      {:phoenix_live_view, ">= 0.17.0"}
    ]
  end

  defp docs do
    [
      main: "readme",
      formatters: ["html"],
      extras: ["CHANGELOG.md", "CONTRIBUTING.md", "README.md"]
    ]
  end

  defp package do
    [
      description: "Google Analytics wrapper for elixir applications.",
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE"],
      maintainers: ["Alejandro Gutiérrez"],
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url,
        Changelog: "https://hexdocs.pm/gamco/changelog.html"
      }
    ]
  end
end
