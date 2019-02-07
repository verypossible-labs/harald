defmodule Harald.MixProject do
  use Mix.Project

  def project do
    [
      app: :harald,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs, :overspecs]
      ]
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
      {:credo, "> 0.0.0", optional: true},
      {:dialyxir, "> 0.0.0", optional: true},
      {:mix_test_watch, "> 0.0.0", optional: true},
      {:stream_data, "> 0.0.0", optional: true}
    ]
  end

  defp description do
    """
    An Elixir Bluetooth library.
    """
  end
end
