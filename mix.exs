defmodule StreamPgKinesis.MixProject do
  use Mix.Project

  def project do
    [
      app: :stream_pg_kinesis,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {StreamPgKinesis.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0.7"},
      {:ecto_sql, "~> 3.0.5"},
      {:postgrex, "~> 0.14.1"},
      {:jason, "~> 1.1.2"},
      {:ex_aws, "~> 2.1.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
