use Mix.Config

config :harald,
  env: Mix.env()

config :hook,
  mappings: [],
  mix_env_allowlist: [:dev, :test],
  resolve_at: :compile_time,
  top_level_module_allowlist: [Harald]

case Mix.env() do
  :dev ->
    config :mix_test_watch,
      clear: true,
      tasks: [
        "test --stale",
        "format --check-formatted"
      ]

  :test ->
    config :hook,
      resolve_at: :run_time

  _ ->
    :ok
end
