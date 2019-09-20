defmodule Exp.Action.Record.Start do
    alias Exp.Action.State
    alias Exp.Format.DateTime, as: ExpDateTime
    alias Exp.Format.CLI

    require Logger
    
    
    # {:ok, remind_time} = Time.new(remind["hours"], remind["minutes"], 0)  
    
    # Something was wrong with the reminder, return the error message
    def start(_, {:error, msg} = remind), do: remind

    # Timer and reminder
    def start(true, {:ok, remind}) do

    end

    # No timer, just remind
    def start(_, {:ok, remind}) do

    end

    # No reminder, no timer, just set time and wait for user to stop
    @doc """
        Depending on passed parameters sets configuration that gets persisted.
    """
    def start(_, _) do
        is_recording? = State.get_config(:is_recording)
        if !is_recording? do
            now = ExpDateTime.now()
            state_updated? = State.put_config(:time_started, now)
            state_updated? = State.put_config(:is_recording, true)

            if state_updated? == :ok do
                CLI.ok("Started recording, waiting for you to stop ...")
            else
                CLI.error("Couldn't update :start_time in config.exs")
            end 
        else
            CLI.warn("You are currently already recording. Stop you'r recording first.")
        end
    end

end