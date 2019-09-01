defmodule Exp.Args.Record do
  alias Exp.Action.Record
  alias Exp.Format.Types
  require Logger

  @moduledoc """

    Parses parameters to start/stop time recording

  """

  @add_types [strict: Types.extract(:schema, :fields), aliases: Types.extract(:alias, :fields)]
  @doc """

  """
  def parse(:add, argv) do
    argv
    |> OptionParser.parse(@add_types)
    |> Record.add()
  end


  @start_types Types.extract(:start, :command)
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
