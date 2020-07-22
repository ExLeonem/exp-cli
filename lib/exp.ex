defmodule Exp.CLI do
  alias Exp.Args.Main, as: ArgParser
  alias Exp.Action.State
  @moduledoc """
    Work watch collecting time doing things.
  """


  def hello_world() do
    
  end


   @doc """
    Main entry point for the cli
  """
  def main(args \\ []) do
    status = State.start_link()
    case status do
      :ok ->
        args |> ArgParser.parse
        State.shutdown()  
      {:error, reason} -> IO.puts(reason)
    end
  end

end
