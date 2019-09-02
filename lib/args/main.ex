defmodule Exp.Args.Main do
  # alias Pow.Action.Main, as: Action
  alias Exp.Args.Record
  alias Exp.Args.State
  alias Exp.Args.Display
  require Logger

  @moduledoc """
    Dispatch parserd arguments to needed modules
    Main Parser, parses top level options and passes left options to more specific parser.
  """

  @help """

    ++++++++++++ EXP CLI +++++++++++++++++++

    For information for a specific task use [option] [--help | -h].


    Usage:

      ./exp [option] [value|s]


    Option:
      
      add     - adding a new entry
      start   - start recording
      stop    - stop recording
      set     - cli configuration
      get     - get current cli config information
      show    - query inserted information
      write   - write currently persisted data from dets to file system
      help    - print usage information
    """

  def parse(argv) do
    argv
    |> cast_key
    |> process
  end

  # prepend switches to first argument if needed
  def cast_key([key| rest]) do
    {String.to_atom(key), rest}
  end

  # Process the acquired options
  def process({key, argv}) do
    dispatch(key, argv)
    |> process_result
  end

  @doc """
    Process the parsed parameters first match triggers specialized processing
  """
  def dispatch([], _), do: get_help() # either no parameters passed or any valid found
  def dispatch(:add, argv), do: Record.parse(:add, argv)
  def dispatch(:start, argv), do: Record.parse(:start, argv)
  def dispatch(:stop, argv), do: Record.parse(:stop, argv)
  def dispatch(:set, argv), do: State.parse(:set, argv)
  def dispatch(:get, argv), do: State.parse(:get, argv)
  def dispatch(:show, argv), do: Display.parse(:show, argv)
  def dispatch(:write, argv), do: Persist.parse(:write, argv)
  def dispatch(_, _), do: get_help() # defaulting to on :help as well as invalid flags

  # Iterate parsed parameters
  def dispatch([_| t], argv) do
    dispatch(t, argv)
  end


  # Return help information
  defp get_help(help \\ @help) do
    {:help, help}
  end

  defp process_result(result = {_, msg}) do
    IO.puts(msg) # Don't remove this !!!!
    result
  end

end