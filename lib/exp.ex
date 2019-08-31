defmodule Exp.CLI do
  alias Exp.Args.Main, as: ArgParser
  alias Exp.Action.State
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
