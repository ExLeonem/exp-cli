defmodule Pow.Persist.Timer do
    @moduledoc """
        Keeps track of recording state.
    """

    use Agent

    def start_link(is_recording \\ false) do
        Agent.start_link(fn -> is_recording end, name: __MODULE__)
    end

    def recording?() do
        Agent.get(__MODULE__, & &1)
    end

    def start() do
        Agent.update(__MODULE__, fn _ -> true end)
    end

    def stop() do
        Agent.update(__MODULE__, fn _ -> false end)
    end

    def shutdown() do
        Agent.stop(__MODULE__)
    end

    def alive?() do
        pid = Process.whereis(__MODULE__)
        if pid do
            Process.alive?(pid) 
        else
            false
        end
    end
end