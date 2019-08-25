defmodule Pow.Action.State do
  require Logger
  @moduledoc """
    Configuration of the CLI. Writing reading parameters.
  """

  @var_env_name "pow_timer_env"
  @config_file_name ".config.json"
  @default_config %{"format" => "csv", "chunk_size" => "1:30"}
  @default_path Path.join([System.user_home(), "Desktop", "PowTimer"])

  @doc """
    Load configuration of directory where data is saved.
  """
  def get_config() do
      config_path = System.get_env(@var_env_name) # Where to write/to
      case config_path do
        nil -> create_default_config()
        _ -> config_path |> load_config
      end
  end


  @doc """
    Creates default Directory on Desktop. Puts configuration file inside
  """
  def create_default_config() do
    System.put_env(@var_env_name, @default_path)
    result = create_directory(@default_path)
    case result do
      :ok -> Path.join([@default_path, @config_file_name]) |> create_config
      _ -> result
    end
  end


  @doc """
    Creates the directory where data is stored.

    @param path: directory where to store data
  """
  def create_directory(path) do

    # Create Directory write Config else try writing only config
    if(!File.exists?(path)) do
      File.mkdir(path)
    else 

      # Only write config if directory already exists
      if(!File.dir?(path)) do
        {:error, "Theres already a directory named PowTime in #{path}. Try using the --create option"}
      else 
        :ok
      end
    end
  end

  @doc """
    Creates a configuration file in given path. Writes a hidden json file to the directory where data is saved.
    File name: config.json 

    @param path: directory where to find config.json
  """
  def create_config(path) do
    to_write = Poison.encode!(@default_config)

    # Create file and parse result in needed format
    create_file = fn(path, data)-> File.write(path, data) end

    if (!File.exists?(path)) do
      result = File.open(path, [:read, :write])

      if {:ok, _} = result do
          create_file.(path, to_write)
      else
        result
      end

    else
      create_file.(path, to_write)
    end   
  end


  # Load configuration file
  def load_config(path) do
      env_config = Path.join([path, @config_file_name])
      result = File.read(env_config)
      case result do
        {:ok, content} -> {:ok, Poison.decode!(content)}
        _ -> result
      end
  end


  def set_config(name, value) do
    # read current config
    
  end

  def set_workspace(path) do
    # set a new workspace
  end

end

