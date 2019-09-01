defmodule Exp.Args.Record do
  alias Exp.Action.Record
  alias Exp.Format.Config
  require Logger

  @moduledoc """

    Parses parameters to start/stop time recording

  """

  @add_types [strict: Config.extract(:schema, :field), aliases: Config.extract(:alias, :field)]
  @doc """

  """
  def parse(:add, argv) do
    argv
    |> OptionParser.parse(@add_types)
    |> Config.build_entry
    |> Record.add
  end


  @start_types Config.extract(:start, :command)
  @doc """

  """
  def parse(:start, argv) do
    argv
    |> OptionParser.parse(@start_types)
    |> Record.start
  end

  @doc """

  """
  def parse(:stop, _), do: Record.stop
  def parse(_, _), do: {:error, "", []}

end
