defmodule Exp.Args.File do
    require Logger
    alias Exp.Action.File

    @usage_write """

        +++++++++ Write Command +++++++++ 

        Description:

            Writes recorded data to the filesystem. Tries to extract filename from path,
            uses default value: time_data if not successfull.

            The default format data is write

        Usage:

            exp write -o /home/<user>/Desktop/test.csv

            exp write --dir /home/<user>/Desktop -f csv

        Flags:

            --output, -o    - Full path includes file name and extension.
            --format, -f    - File format [:csv, :json, :yaml]
            --dir, -d       - Directory where to write file to.
            --name, -n      - Filename with extension
            --flush         - Flush DETS tables. (Removes recorded data)

    
    """

    @parser_config [
        alias: [
            o: :output, # Full path with filename and extension
            f: :format, # File extension
            d: :dir, # Only directory uses default file-name
            n: :name, # Only name, writes to current directory
            h: :help
        ],
        strict: [
            output: :string, # 
            format: :string, # 
            dir: :string,
            name: :string,
            flush: :boolean,
            help: :boolean
        ]
    ]

    def parse(:write, argv) do
        argv
        |> OptionParser.parse(@parser_config)
        |> process_flags
        |> File.write
    end
    

    @doc """
        
    """
    def process_flags({[], [], []}), do: {:error, "You supplied no arguments. Type exp write --help to get help."}
    def process_flags({[], _, _}), do: {:error, "Invalid arguments parsed. Type exp write --help to get usage information."}
    def process_flags({argv, rest, invalid}) do

        cond do
            !Enum.empty?(rest) -> {:error, "Invalid arguments parsed. Type exp write --help to get usage information"}
            !Enum.empty?(invalid) -> {:error, "Error while parsing arguments. Type exp write --help to get usage information."}
            argv[:help]-> {:help, @usage_write}
            true -> {:ok, argv} 
        end
    end


end