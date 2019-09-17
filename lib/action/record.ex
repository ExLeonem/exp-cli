defmodule Exp.Action.Record do
  alias Exp.Action.State
  alias Exp.Format.Types
  alias Exp.Action.Record.Start
  alias Exp.Format.Config
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
        ArgumentError -> {:error, "Only values of Form hh:mm are applyable to parameter remind."}
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
      --tag         - A list of tags you want to add: tag1,tag2,tag3

  """
  # Stop recording, shutdown process & write to file if circumstances right
  def stop({_valid, rest, _invalid}) when rest != [], do: {:error, "You passed some non-existing flags. Check exp stop -h"}
  def stop({_valid, _rest, invalid}) when invalid != [], do: {:error, "You passed some invalid flags. Check exp stop -h"}
  def stop({valid_keys, _, _}) do

    is_recording? = State.get_config(:is_recording)
    if is_recording? do

      # Get time information
      now = DateTime.utc_now()
      date_time_write = DateTime.utc_now()
      time_started = State.get_config(:time_started)

      # Fill time keys and assemble the entry
      params = valid_keys 
        |> Keyword.put(:date, date_time_write) 
        |> Keyword.put(:start, time_started) 
        |> Keyword.put(:end, now)
        
      entry = Types.build_entry({params, [], []})

      case entry do
        {:ok, entry} -> 
          processed_entry = entry |> Enum.reverse |> List.to_tuple 
          State.set_config([is_recording: false, last_entry: processed_entry])
          State.write_entry(processed_entry)
          {:ok, "\nEntry successfully written."}
        {:error, reason} -> entry
      end

      # Write to dets tables
      # State.set_config([is_recording: false, last_entry: entry])
      # {:ok, "\nEntry successfully written."}
    else
      {:error, "It seems like you aren't recording anything. Start recording first to stop something."}
    end
  end

  def add({:ok, entry}) do

      entry
      |> Enum.reverse
      |> List.to_tuple
      |> State.write_entry

      {:ok, "\Entry successfully written"}
  end
  def add(entry), do: entry


  # -----------------------------
  # Utility functions
  # -----------------------------
  
  def calculate_time(start_time, end_time) do
    seconds = Time.diff(end_time, start_time)
    minutes = div(seconds, 60)
    hours = div(minutes, 60)
    days = div(hours, 24)

    if days != 0 do
      {days, rem(hours, 24), rem(minutes, 60), rem(seconds, 60)}
    else
      # Return tuple of calculated time units
      {hours, rem(minutes, 60), rem(seconds, 60)}
    end
  end

  def format_time({hours, minutes, seconds}) do
    "#{hours}:#{minutes}:#{seconds}"
  end

  def format_time({days, hours, minutes, seconds}) do
    "#{days}-days, #{hours}:#{minutes}:#{seconds}"
  end



  @doc """
    Prompts the user for an argument using the passed checker function
  """
  def request_user_argument(prompt, checker \\ nil, io \\ IO) when is_function(checker) or nil do
    if checker != nil do
      value = io.gets(prompt)

      # Loop till user input is truthy
      if !apply(checker, [value]) do
        request_user_argument(prompt, checker, io)
      else
        value
      end
    else
      io.gets(prompt)
    end
  end
  def request_user_argument(_, _, _), do: raise ArgumentError, message: "Invalid argument checker for function request_user_argument."


  @doc """
    Returns tuple of Form {Time.utc_now(), "hh_mm_ss"}
  """
  def get_entry_name() do
    now = Time.utc_now()
    {now, "#{now.hour}_#{now.minute}_#{now.second}"}
  end 

  @doc """
    Returns tupel of Form {Date.utc_now(), "yy_mm_dd"}
  """
  def get_file_name() do
    today = Date.utc_today()
    {today, "#{today.year}_#{today.month}_#{today.day}"}
  end


  # @doc """
  #   Sort 
  # """
  # def sort_by_fields(key_value_pairs) do

  # end


  @doc """
    !deprecated
    Not in use here

    Returns boolean. File exists do true else false
  """
  def file_exists?(file_name) do
    env_path = State.get_config(:env_path)
    if File.exists?(env_path) && File.dir?(env_path) do
      true
    else
      false
    end
  end

end

