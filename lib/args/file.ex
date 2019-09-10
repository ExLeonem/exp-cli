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
        |> get_args
        |> preprocess_args
    end


    def preprocess_args({:error, })
    def preprocess_args({:ok, args}) do
        
        if Keyword.has_key?(args, :help) do
            {:help, @usage_write} 
        else

            # Check what is filled in args and should be further used
            cond do
                true -> {:ok, "Under development"}
            end

        end
    end

    
    @doc """
        Checks the value passed with the -o option.

        Returns tuple in form {:ok, {path, format}} | {:error, reason}
    """
    def extract_path_information(path) do
        extension = Path.extname(path)
        dir_path = Path.dirname(path)

        cond do
            extension != "" && File.dir?(dir_path) -> {:ok, {path, extension}}
            extension == "" -> {:error, can}
        end

    end


    
    def get_args({[],[],[]}), do: {:error, "You passed an insufficient amount of parameter to the command. Need help? Just type exp write -h"}
    def get_args({argv, [], []}), do: {:ok, argv}
    def get_args({_, _rest, []}), do: {:error, "You passed some unneseccary parameters. Type exp write -h to get information about the usage."}
    def get_args({_, _, _invalid}), do: {:error, "You used invalid arguments. Type exp write -h to get information about the usage."}

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