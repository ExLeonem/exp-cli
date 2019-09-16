defmodule Exp.Action.State do
  use Agent
  alias Exp.Format.Config
  require Logger
  @moduledoc """
    Handles application state read/writes of config and entries.
    In general all interaction with used DETS tables.
  """

  # DETS table names
  @config_table :config_store
  @entry_table :entry_store

  # Load default values for configuration into keyword list (config.exs)
  @default_config Config.extract(:defaults)
  @config_keys Keyword.keys(@default_config)

  @doc """
    Starts the StateAgent.
  """
  def start_link() do 
    try do
      default_path = @default_config[:default_storage_path]
      changed_to_dir = File.cd(default_path)

      if changed_to_dir != :ok, do: raise ArgumentError, message: "Failed to switch to #{default_path}"
      {:ok, config_table} = open_table(@config_table)

      # Parameterlist either not set or corrupted, reset, TODO: Compare keys, length prone for manipulation
      if length(get_config(:all_keys, config_table)) != length(@default_config) do
        init_config(config_table)
      end

      storage_path = get_config(:default_storage_path, config_table)
      
      # switch where to save entries to.
      changed_to_dir = File.cd(storage_path)
      if changed_to_dir != :ok, do: raise ArgumentError, message: "Couldn't switch to #{storage_path}. Is the directory existent at all?"
      {:ok, entry_table} = open_table(@entry_table)

      # Agent loads/keeps tables open, writes/reads tables
      Agent.start_link(fn -> {config_table, entry_table} end, name: __MODULE__)
      :ok
    rescue
      e in ArgumentError -> {:error, e[:message]}

    end
  end




  def open_table(table_name) do
    :dets.open_file(table_name, [type: :set, access: :read_write])
  end

  def close_table(table_name) do
    :dets.close(table_name)
  end

  def get_table(table_name) do
    {config, entries} = Agent.get(__MODULE__, & &1)
    case table_name do
      @config_table -> config
      @entry_table -> entries
      _ -> raise ArgumentError, message: "Unknown table: #{table_name}"
    end
  end

  def write_entry(entry, type \\ :new) do
    table = get_table(@entry_table)
    case type do
      :new -> :dets.insert_new(table, entry)
      :replace -> :dets.insert(table, entry)
      _ -> raise ArgumentError, message: "Unknown action: #{type}"
    end
  end
  
  def get_entries(filter \\ [])
  def get_entries([]) do
    table = get_table(@entry_table)
    # :dets.match_object(table, {:"$1", :"$2", :"$3"})
    :dets.match(table, :"$1") # returns all entries
  end
  def get_entries(filter) do
    
  end

  def get_entry(query) do
    :dets.select(@entry_store, query)
  end

  @doc """
    Returns the last entry written to the dets store.
  """
  def get_last_entry() do
    # REVIEW: Not a solution for big datasets (maybe Streams?)
    last_entry = get_config(:last_entry)
    if !is_nil(last_entry) do
      [last_entry]
    else
      []
    end
  end

  @doc """
    Updated the configuration parameter on key with given value.
  """
  def put_config(key, value) do
    # check if config is in @default config key list then write
    table = get_table(@config_table)
    :dets.insert(table, {key, value})
  end 

  @doc """
      Gets the current configuration parameter under given key.
      
      Returns [key: value]
  """
  def get_config(key \\ :all_keys, table \\ nil, aggr \\ [])
  def get_config(:all_keys, table, aggr) do
    table = if is_nil(table), do: get_table(@config_table), else: table
    key_list = Keyword.keys(@default_config)
    :dets.match_object(table, {:"$1", :"$2"})
  end 

  # Getting list of config param names as atoms [:default_config, :remind]
  def get_config([], _, aggr), do: {:ok, aggr}
  def get_config([config_key| rest], table, aggr) do
  
    result = get_config(config_key)
    case result do
      {:error, _} -> result
      _ -> get_config(rest, table, [result| aggr])
    end
  end

  def get_config(key, table, _) when is_atom(key) do
    table = if is_nil(table), do: get_table(@config_table), else: table
    # :dets.match_object(table, {key, :"$2"}) # REVIEW: Which one to choose
    :dets.lookup(table, key) |> Keyword.get(key)
  end


  @doc """
    Update multiple configuration parameters.
    Input has to be a Keyword list of the form: [config_param_key: value]
  """
  def set_config([]), do: :ok

  # Check if valid path
  def set_config([{:"default_storage_path", value} = result | t]) do
    if File.exists?(value) && File.dir?(value) do
      put_config(:"default_storage_path", value)
      set_config(t)
    else
      {:error, "Path is not a valid directory."}
    end
  end

  def set_config([{key, value} | t]) do
    if key in @config_keys do
      put_config(key, value)
    end
    set_config(t)
  end



  @doc """
    Flush table contents. (Deleting Table contents)
  """
  def flush(table_name) do
    get_table(table_name)
    |> :dets.delete_all_objects
  end

  @doc """
    Shutdown Agent and close dets tables.
  """
  def shutdown() do
    close_table(@config_table)
    close_table(@entry_table)
    Agent.stop(__MODULE__)
  end



  # -----------------------------
  # Additional Functions
  # -----------------------------

  @doc """
    Creates the directory where data is stored.

    @param path: directory where to store data
  """
  def create_dir() do
    path = Application.get_env(:exp, :env_path)

    # Create Directory write Config else try writing only config
    if(!File.exists?(path)) do
      File.mkdir(path)
    else 

      # Only write config if directory already exists
      if(!File.dir?(path)) do
        {:error, "Theres already a directory named ExpTime in #{path}. Try using the --create option"}
      else 
        :ok
      end
    end
  end


  @doc """
    Initialize default arguments if not existent in dets table
  """
  def init_config(table \\ nil) do
    table = if is_nil(table), do: get_table(@config_table), else: table

    :dets.init_table(table, fn :read -> {@default_config, fn :read -> :end_of_input end} end)
  end

end

