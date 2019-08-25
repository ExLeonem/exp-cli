defmodule Pow.Action.Record do
  alias Pow.Action.State
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
  def start(argv) do
    if argv[:timer] do

    
      if argv[:remind] do

      end

    end
  end


  def stop() do
    # Check if today already file created
    date = Date.utc_today()
    date_formatted = "#{date.year}_#{date.month}_#{date.day}"
    Logger.debug(date_formatted)

    # Check and insert last row
    time = Time.utc_now()
    time_formatted = "#{time.hour}_"
    Logger.debug(time_formatted)



  end


  def today_file_exists?() do
    
  end

end

