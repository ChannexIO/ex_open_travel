defmodule ExOpenTravel.MixProject do
  use Mix.Project

  @version "0.3.4"

  def project do
    [
      app: :ex_open_travel,
      version: @version,
      build_path: "./_build",
      config_path: "./config/config.exs",
      deps_path: "./deps",
      lockfile: "./mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      name: "ExOpenTravel",
      source_url: "https://github.com/ChannexIO/ex_open_travel",
      docs: docs(),
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :detergentex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sweet_xml, "~> 0.6.6"},
      {:xml_builder, "~> 2.1"},
      {:http_client, github: "ChannexIO/http_client", tag: "v0.3.0"},
      {:elixir_uuid, "~> 1.2"},
      {:exsom, "~> 0.1.0"},
      {:detergentex, "0.0.5"},
      {:ex_doc, "~> 0.21", only: :dev}
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "OpenTravel API Extension for Elixir"
  end

  defp package do
    [
      name: "ex_open_travel",
      files: ~w(lib config .formatter.exs mix.exs README.md LICENSE),
      maintainers: ["Andrew Judis Yudin"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ChannexIO/ex_open_travel"}
    ]
  end
end
