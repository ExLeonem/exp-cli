defmodule Exp.Action.Record do
  alias Exp.Action.State
  alias Exp.Format.Types
  alias Exp.Action.Record.Start
  alias Exp.Format.Config
  alias Exp.Format.CLI
  alias Exp.Format.DateTime, as: ExpDateTime
  require Logger

  @moduledoc """
    Records/stops recording of time.
  """

  @usage_start """

    -------------------------------------------
    /////////////////// start /////////////////
    -------------------------------------------

    Description:

        Starts a recording/pomodoro timer.

    Usage:

      exp stop --title "Sample tilte" --tags tag1,tag2,tag3

    Options:
      --timer, -t   - start a timer with specified, pass time in format hh:mm
      --remind, -r  - reminds user of current progress every hh:mm

  """
  
  @doc """

  """
  def start({argv, _, _}) do
    # Print either help or start recording
    if argv[:help] do
      {:help, @usage_start}
    else
      remind = if argv[:remind], do: parse_remind(argv[:remind]), else: nil
      Start.start(argv[:timer], remind)
    end
  end


  @doc """
    parse the value passed as reminder.
  """
  def parse_remind(string_value) do
    try do
      [hours, minutes| r] = string_value 
        |> String.split(":") 
        |> Enum.map(&String.to_integer/1)

      [hours: hours, minutes: minutes]
    rescue
        ArgumentError -> CLI.error("Only values of Form hh:mm are applyable to parameter remind.")
    end

  end


  @usage_stop """

    -------------------------------------------
    /////////////////// stop /////////////////// 
    -------------------------------------------

    Description:

        Finishes a recording and writes an entry to the store.

    Usage:

      exp stop --title "Sample tilte" --tags tag1,tag2,tag3

    Options:
      --title, -t   - A description or title of what you did (required!)
      --tag, -g     - A list of tags you want to add: tag1,tag2,tag3

  """
  # Stop recording, shutdown process & write to file if circumstances right
  def stop({_valid, rest, _invalid}) when rest != [], do: {:error, "You passed some non-existing flags. Check exp stop -h"}
  def stop({_valid, _rest, invalid}) when invalid != [], do: {:error, "You passed some invalid flags. Check exp stop -h"}
  def stop({valid_keys, _, _}) do

    is_recording? = State.get_config(:is_recording)
    if is_recording? do

      # Get time information
      now = ExpDateTime.now()
      time_started = State.get_config(:time_started)


      # Fill time keys and assemble the entry
      params = valid_keys 
        |> Keyword.put(:date, now) 
        |> Keyword.put(:start, time_started) 
        |> Keyword.put(:end, now)
        
      entry = Types.build_entry({params, [], []})


      case entry do
        {:ok, entry} -> 
          processed_entry = entry |> Enum.reverse |> List.to_tuple 
          State.set_config([is_recording: false, last_entry: processed_entry])
          State.write_entry(processed_entry)
          CLI.ok("Entry successfully written.")
        {:error, reason} -> CLI.error(reason)
      end

      # Write to dets tables
      # State.set_config([is_recording: false, last_entry: entry])
      # {:ok, "\nEntry successfully written."}
    else
      CLI.error("It seems like you aren't recording anything. Start recording first to stop something.")
    end
  end

  def add({:ok, entry}) do

      entry
      |> Enum.reverse
      |> List.to_tuple
      |> State.write_entry

      # {:ok, "\Entry successfully written"}
      CLI.ok("Entry successfully written")
  end
  def add(entry), do: entry

end

