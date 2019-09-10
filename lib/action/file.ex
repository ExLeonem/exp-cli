defmodule Exp.Action.File do
    alias Exp.Format.FileOutput
    alias Exp.Format.Config

    @moduledoc """
        Export of saved entries into a specific format.

    """

    @field_names Config.extract(:keys, :field)
    @default_config [
        name: "time_data",
        dir: "./",
        format: :csv
    ]

    @doc """
        Write File in a specific format to the Filesystem.

        Parameters:
        - format: Fileformat [:csv | :json | :xml]
        - opts: Additional options to set
            [
                dir: "To wich directory to write"
                name: "Filename"
            ]

    """
    def write_out(opts) do

        result = get_write_config(opts)
        case result do
            {:ok, config} -> config |> exists? |> create |> fill
            {:error, _} -> result
        end
    end


    # ----------------------------
    # Utilities

    @doc """
        Check wether file/directory exists
    """
    def exists?(config) do
        {name, dir, format} = config |> Keyword.values |> List.to_tuple
        full_name = get_file_name(name, format)
        full_path = Path.join([dir, full_name])

        if File.exists?(dir) && File.dir?(dir) do
            {true, full_path}
        else
            # Create path that does not exist 
            result = File.mkdir(dir)

            case result do
                :ok -> {true, full_path}
                {:error, :eacces} -> {false, "Couldn't write directory because of lacking permission."}
                {:error, :eexist} -> {false, "Couldn't create Directory. There's already a directory named that way."}
                {:error, :enoent} -> {false, "Couldn't create Directory. A component of the path does not exist."}
                {:error, :enospc} -> {false, "Couldn't create Directory. There's no space left on the device."}
                {:error, :enotdir} -> {false, "Couldn't create Directory. A component of the path is not a directory."}
            end
            
        end

    end

    # Create the file pass result
    def create({true, full_path}), do: full_path |> File.open([:write, :append])
    def create({false, msg} = result), do: {:error, msg}
        
    @doc """

    """
    def fill({:error, msg} = result), do: result
    def fill() do
        
    end


    @doc """
        In either case returns a tuple with default configuration.

        Returns Tuple {:ok {filename, path}} | {:error, "passed parameter doesen't exist."}
    """

    def get_write_config()
    def get_write_config([], acc), do: acc
    def get_write_config([{key, value} | rest]) do
        
    end


    def get_file_name(name, format) when (is_atom(format) or is_binary(format)) and is_binary(name) do
        ext = format |> to_string
        "#{name}.#{ext}"
    end
    def get_file_name(name, format), do: raise ArgumentError, message: "Error in function &get_file_name/2. Expected parameters of type atom and string. Got something else."

end