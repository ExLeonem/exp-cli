defmodule Exp.Args.File do
    require Logger
    alias Exp.Action.File

    @usage_write """

        ---------------------------------------------
        /////////////////// write /////////////////// 
        --------------------------------------------

        Description:

            Writes recorded data to the filesystem. Extracts all information from the given path.
            Possible file extensions are [csv | json | yaml | xml].

        Usage:

            exp write -o /home/<user>/Desktop/test.csv

        Options:

            --output, -o    - Full path includes file name and extension.
            --flush, -f     - Flushes the DETS Tables
        
    
    """

    # Add flag: --new --> only write new data till last write
    @parser_config [
        alias: [
            o: :output, # Full path with filename and extension
            f: :flush,
            h: :help
        ],
        strict: [
            output: :string, # 
            flush: :boolean,
            help: :boolean
        ]
    ]

    def parse(:write, argv) do
        argv
        |> OptionParser.parse(@parser_config)
        |> get_args
        |> help_user?
        |> File.write
    end


    def help_user?({:error, _reason} = result), do: result 
    def help_user?({:ok, args}) do
        if Keyword.has_key?(args, :help) && args[:help] do
            {:help, @usage_write} 
        else
            {:ok, args}
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
            extension == "" -> {:error, "You'r file needs an extension when you use the --output flag, like /Desktop/test.csv"}
        end

    end
    
    def get_args({[],[],[]}), do: {:error, "You passed an insufficient amount of parameter to the command. Need help? Just type exp write -h"}
    def get_args({argv, [], []}), do: {:ok, argv}
    def get_args({_, _rest, []}), do: {:error, "You passed some unneseccary parameters. Type exp write -h to get information about the usage."}
    def get_args({_, _, _invalid}), do: {:error, "You used invalid arguments. Type exp write -h to get information about the usage."}

end