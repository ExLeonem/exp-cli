defmodule Pow.CLI do
  alias Pow.Args.Main, as: ArgParser
  alias Pow.Action.State
  @moduledoc """
    Work watch collecting time doing things.
  """



   @doc """
    Main entry point for the cli
  """
  def main(args \\ []) do
    State.start_link()
    args |> ArgParser.parse
    State.shutdown()
  end

end
