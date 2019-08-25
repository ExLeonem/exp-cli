defmodule Pow.CLI do
  alias Pow.Args.Main, as: ArgParser
  @moduledoc """
    Work watch collecting time doing things.
  """



   @doc """
    Main entry point for the cli
  """
  def main(args \\ []) do
    args |> ArgParser.parse
  end

end
