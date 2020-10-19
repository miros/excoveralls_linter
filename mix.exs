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
      ],
      package: package(),
      description: description(),
      preferred_cli_env: ["coveralls.lint": :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mix]
    ]
  end

  defp package do
    [
      name: :excoveralls_linter,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Miroslav Malkin"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/miros/excoveralls_linter"
      }
    ]
  end

  defp description() do
    "Simple mix task to run excoveralls for coverage linting"
  end

  defp deps do
    [
      {:excoveralls, "~> 0.12", only: :test},
      {:jason, "~> 1.1"},
      {:optimus, "~> 0.1.9"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: :dev, runtime: false}
    ]
  end
end
