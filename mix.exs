defmodule VsmStarter.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/viable-systems/vsm-starter"

  def project do
    [
      app: :vsm_starter,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: @source_url,
      homepage_url: @source_url,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Core dependencies
      {:telemetry, "~> 1.2"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},

      # Optional dependencies for common VSM patterns
      {:jason, "~> 1.4"},
      {:decimal, "~> 2.0"},

      # Development and test dependencies
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end

  defp description() do
    """
    A starter template for Viable Systems Model (VSM) applications in Elixir.
    Provides a foundation for building cybernetic systems with telemetry integration.
    """
  end

  defp package() do
    [
      name: "vsm_starter",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "VSM Documentation" => "https://viable-systems.github.io"
      },
      maintainers: ["Viable Systems Team"],
      files: ~w(lib priv .formatter.exs mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "VSM Starter",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/vsm_starter",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"],
      groups_for_modules: [
        Core: [
          VsmStarter,
          VsmStarter.Application,
          VsmStarter.Telemetry
        ],
        "System Components": [
          VsmStarter.System1,
          VsmStarter.System2,
          VsmStarter.System3,
          VsmStarter.System4,
          VsmStarter.System5
        ],
        Channels: [
          VsmStarter.Channels.Command,
          VsmStarter.Channels.Resource,
          VsmStarter.Channels.Algedonic
        ]
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [
      setup: ["deps.get", "compile"],
      test: ["test"],
      "test.coverage": ["coveralls"],
      "test.coverage.html": ["coveralls.html"],
      quality: ["format", "credo --strict", "dialyzer"],
      "quality.ci": ["format --check-formatted", "credo --strict", "dialyzer"]
    ]
  end
end
