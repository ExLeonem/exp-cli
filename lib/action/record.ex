defmodule Pow.Action.Record do
  alias Pow.Action.State
  alias Pow.Action.Record.Start
  require Logger

  @moduledoc """
    Records/stops recording of time.
  """

  @start_help """
    How to record and set a timer with the start.

    Starting to record as follows ...

      pow start [options]

    Options:
      -t, --timer - start a timer with specified, pass time in format hh:mm
      -r, --remind - reminds user of current progress every hh:mm
  """
  
  @doc """

  """
  def start({argv, _, _}) do
    # Print either help or start recording
    if argv[:help] do
      {:help, @start_help}
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
      [hours, minutes| t] = string_value 
        |> String.split(":") 
        |> Enum.map(&String.to_integer/1)

      [hours: hours, minutes: minutes]
    rescue
        ArgumentError -> {:error, "Only values of Form hh:mm are applyable to parameter remind."}
    end

  end


  # Stop recording, shutdown process & write to file if circumstances right
  def stop(io \\ IO) do

    config = State.get_config(:is_recording)
    if config[:is_recording] do
      now = Time.utc_now()
      config_time = State.get_config(:time_started)
      

      # Check if today already file created & create one if needed
      title = request_user_argument("Enter a title or description for the entry... \n", &is_binary/1, io)
      time_flag = calculate_time(config_time[:time_started], now) |> format_time

      State.write_entry({DateTime.utc_now(), time_flag, title})
      State.put_config(:is_recording, false)
      {:ok, "+++++\nEntry written.\n+++++"}
    else
      {:error, "It seems like you aren't recording anything. Start recording first to stop something."}
    end
  end

  
  def calculate_time(start_time, end_time) do
    seconds = Time.diff(end_time, start_time)
    minutes = div(seconds, 60)
    hours = div(minutes, 60)

    # Return tuple of calculated time units
    {hours, rem(minutes, 60), rem(seconds, 60)}
  end

  def format_time({hours, minutes, seconds}) do
    "#{hours}:#{minutes}:#{seconds}"
  end

  def format_content(content_array, format, agg \\ "")

  def format_content([], :csv, agg), do: agg
  def format_content([h| []], :csv, agg), do: agg <> h
  def format_content([h| t], :csv, agg) do
    tmp_result = agg <> h <> ","
    format_content(t, :csv, tmp_result)
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

  @doc """
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

