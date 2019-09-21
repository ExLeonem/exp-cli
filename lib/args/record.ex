defmodule Exp.Args.Record do
  alias Exp.Action.Record
  alias Exp.Format.Config
  alias Exp.Format.Types
  require Logger

  @moduledoc """

    Parses parameters to start/stop time recording

  """

  @add_types [strict: Config.extract(:schema, :field), aliases: Config.extract(:alias, :field)]
  @add_help_switch [strict: [help: :boolean], aliases: [h: :help]]
  @add_help """

    -------------------------------------------
    /////////////////// add /////////////////// 
    -------------------------------------------

    Description:

        Adds a new entry to the entry store.

    Usage:

      exp add --start 20:20 --title "Sample tilte" --tags tag1,tag2,tag3

    Options:
      --date,  -d   - The date in which you've done the work, dd-MM-YYYY
      --start, -s   - Time you started the work, in format: hh:mm (required!)
      --end,   -e   - Time you finished the work, in format hh:mm (default to now)
      --title, -t   - A description or title of what you did (required!)
      --tag         - A list of tags you want to add: tag1,tag2,tag3
  
  """
  
  @doc """

  """
  def parse(:add, argv) do
    {captured, rest, _errors} = argv |> OptionParser.parse(@add_help_switch)

    if Keyword.has_key?(captured, :help) do
      {:help, @add_help}
    else
      argv
      |> OptionParser.parse(@add_types)
      |> Types.build_entry
      |> Record.add
    end

  end


  @start_types Config.extract(:start, :command)
  @doc """

  """
  def parse(:start, argv) do
    argv
    |> OptionParser.parse(@start_types)
    |> Record.start
  end

  @stop_types Config.extract(:stop, :command)
  @doc """

  """
  def parse(:stop, argv) do
    argv
    |> OptionParser.parse(@stop_types)
    |> Record.stop
  end 

end
