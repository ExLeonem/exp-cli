defmodule Exp.Action.File do
    alias Exp.Format.FileOutput

    @moduledoc """
        Export of saved entries into a specific format.

    """

    @doc """
        Write File in a specific format to the Filesystem.

        Parameters:
        - format: Fileformat [:csv | :json | :xml]
        - opts: Additional options to set
            [
                filter: fn (entry) -> Which entries to write? Passing a time span end
                dir: "To wich directory to write"
                name: "Filename"
            ]

    """
    def write_out(format \\ :csv, opts \\ [])
    def write_out(:csv = format_type, _opts) do
        
    end

    def write_out(:json, _opts) do

    end

    def write_out(:xml, _opts) do
        
    end

end