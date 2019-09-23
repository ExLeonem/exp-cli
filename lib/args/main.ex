defmodule Exp.Args.Main do
  # alias Pow.Action.Main, as: Action
  alias Exp.Args.Record
  alias Exp.Args.State
  alias Exp.Args.Display
  alias Exp.Args.File
  require Logger

  @moduledoc """
    Dispatch parserd arguments to needed modules
    Main Parser, parses top level options and passes left options to more specific parser.
  """



  # Additionals
  # status -> current recording status (time-already recording)
  # clear -> reset recording
  @usage """
    -------------------------------------------------
    /////////////////// EXP-CLI ⌚ ///////////////////
    -------------------------------------------------

    For information about a specific command use exp [option] [--help | -h].


    Usage:

      ./exp [option] [value|s]


    Commands:
      
      start       - start recording
      stop        - stop recording
      status      - Shows the current progression.
      add         - adding a new entry
      set         - cli configuration
      get         - get current cli config information
      show        - query inserted information
      -x          - Export data to the given path, available formats are csv | json
      -h, --help  - print usage information

    """

  def parse(argv) do
    argv
    |> cast_key
    |> process
  end

  # prepend switches to first argument if needed
  def cast_key([]), do: []
  def cast_key([key| rest]) do
    {String.to_atom(key), rest}
  end

  # Process the acquired options
  def process(options) when not is_tuple(options), do: {:error, "I need some arguments to work. Check out exp --help to get more information."} |> process_result
  def process({key, argv}) do
    dispatch(key, argv)
    |> process_result
  end

  @doc """
    Process the parsed parameters first match triggers specialized processing
  """
  def dispatch(:add, argv), do: Record.parse(:add, argv)
  def dispatch(:start, argv), do: Record.parse(:start, argv)
  def dispatch(:stop, argv), do: Record.parse(:stop, argv)
  def dispatch(:set, argv), do: State.parse(:set, argv)
  def dispatch(:get, argv), do: State.parse(:get, argv)
  def dispatch(:status, argv), do: State.parse(:status, argv)
  def dispatch(:show, argv), do: Display.parse(:show, argv)
  def dispatch(first_key, argv) when first_key in [:"-x", :"--export"], do: File.parse(:write, argv)
  def dispatch(_, []), do: {:help, @usage} # either no parameters passed or any valid found
  def dispatch(first_key, argv) when first_key in [:"-h", :"--help"], do: {:help, @usage}
  def dispatch(_, _), do: {:error, "You passed something I can't process. Check my manual with exp -h"}

  def process_result(result = {_, msg}) do
    IO.puts(msg) # Don't remove this !!!!
    result
  end

end
