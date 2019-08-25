defmodule Pow.Args.Main do
  # alias Pow.Action.Main, as: Action
  alias Pow.Args.Record
  alias Pow.Args.State #

  @moduledoc """
    Dispatch parserd arguments to needed modules
    Main Parser, parses top level options and passes left options to more specific parser.
  """

  @help """

    ++++++++++++ Pomodoro Watcher +++++++++++++++++++

    For information for a specific task use [option] [--help | -h].


    Usage:

      ./pow [option] [value|s]


    Option:

      start - start recording
      stop - stop recording
      abort - abort a timer or current recording
      set - cli configuration
      show - show current state information
      tag - tag the current tracking with keywords
      help - print usage information
      create - creates directory and sets variables to read configuration from

    """

  @aliases [
    cancel: :c,
    show: :s,
    tag: :t,
    help: :h
  ]


  @strict [
    start: :boolean,
    stop: :boolean,
    abort: :boolean,
    set: :boolean,
    show: :boolean,
    tag: :boolean,
    help: :boolean
  ]

  def parse(argv) do
    argv
    |> OptionParser.parse([aliases: @aliases, strict: @strict])
    |> process
  end

  # Process the acquired options
  def process({parsed, argv, _invalid}) do
    dispatch(parsed, argv)
  end


  @doc """
    Process the parsed parameters first match triggers specialized processing
  """
  def dispatch([], _), do: get_help() # either no parameters passed or any valid found
  def dispatch([{:start, true}| _], argv), do: Record.parse(:start, argv)
  def dispatch([{:stop, true}| _], argv), do: Record.parse(:stop, argv)
  def dispatch([{:set, true}| _], argv), do: State.parse(:set, argv)
  def dispatch([{:show, true}, _], argv), do: State.parse(:show, argv)
  def dispatch([{:tag, true}, _], argv), do: State.parse(:tag, argv)
  def dispatch([{:help, true}| _], _), do: get_help()

  # Iterate parsed parameters
  def dispatch([_| t], argv) do
    dispatch(t, argv)
  end


  # Return help information
  defp get_help() do
    {:help, @help, []}
  end

end
