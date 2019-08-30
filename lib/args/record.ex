defmodule Exp.Args.Record do
  alias Exp.Action.Record
  require Logger

  @moduledoc """

    Parses parameters to start/stop time recording

  """

  @start_options [
    aliases: [
      timer: :t,
      remind: :r
    ],
    strict: [
      timer: :string,
      remind: :string
    ]
  ]

  def parse(:start, argv) do
    argv
    |> OptionParser.parse(@start_options)
    |> Record.start
  end

  def parse(:stop, _), do: Record.stop
  def parse(_, _), do: {:error, "", []}

end
