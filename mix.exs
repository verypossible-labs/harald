defmodule Harald.MixProject do
  use Mix.Project

  def project do
    [
      app: :harald,
      deps: deps(),
      description: description(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs, :overspecs]
      ],
      docs: docs(),
      elixir: "~> 1.7",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/verypossible/harald",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:circuits_uart, "~> 1.3"},
      {:credo, "~> 1.0", runtime: false},
      {:dialyxir, "1.0.0-rc.4", runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test], runtime: false},
      {:mix_test_watch, "~> 0.9", only: [:dev], runtime: false},
      {:stream_data, "~> 0.1", only: [:test]}
    ]
  end

  defp description do
    """
    An Elixir Bluetooth library.
    """
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/verypossible/harald"}
    ]
  end
end
