defmodule ExCoverallsLinter.MixProject do
  use Mix.Project

  def project do
    [
      app: :excoveralls_linter,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs, :unknown]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mix]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.12", only: :test},
      {:jason, "~> 1.1"},
      {:optimus, "~> 0.1.9"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false}
    ]
  end
end
