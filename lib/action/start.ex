defmodule Pow.Action.Record.Start do
    alias Pow.Action.State
    alias Pow.Persist.Timer
    
    
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
    def start(_, _) do
        if !Timer.alive? do
            Timer.start_link
        end
        
        # Currently process not recording, start new one and set parameters
        if !Timer.recording? do
            now = Time.utc_now()
            state_updated? = State.put_config(:start_time, now)

            if state_updated? == :ok do
                Timer.start # starting timer to record
                {:ok, "Started recording, waiting for you to stop ..."}               
            else
                {:error, "Couldn't update :start_time in config.exs"}
            end 
        else
            {:error, "You are currently already recording. Stop you'r recording first."}
        end
    end


    def loop(false), do: nil
    def loop(true) do
        
    end
end