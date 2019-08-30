defmodule Pow.MixProject do
  use Mix.Project

  def project do
    [
      app: :exp,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def escript() do
    [main_module: Pow.CLI]
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
      {:rename, "~>0.1.0", only: :dev},
      {:benchee, "~>1.0", only: :dev},
      {:excoveralls, "~>0.11.2", only: :dev}
    ]
  end
end
