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
      elixir: "~> 1.7",
      package: package(),
      source_url: "https://github.com/verypossible/harald",
      start_permanent: Mix.env() == :prod,
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
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.9", only: [:dev], runtime: false},
      {:stream_data, "~> 0.1", only: [:test]}
    ]
  end

  defp description do
    """
    An Elixir Bluetooth library.
    """
  end

  defp package do
    [
      organization: :very,
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/verypossible/harald"}
    ]
  end
end
