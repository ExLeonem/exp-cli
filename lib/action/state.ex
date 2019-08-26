defmodule Pow.Action.State do
  use Agent
  require Logger
  @moduledoc """
    Handles application state read/writes of config/entries
  """

  @config_table :config_store
  @entry_table :entry_store

  @entry_keys [
    :datetime, # timestamp when entry was written
    :title,
    :tags,
    :duration 
  ]

  @default_config [
    block_length: "1:30", # learning block length
    is_recording: false, # timer is currently recording
    timer: nil,
    remind: nil,
    time_started: nil,
    default_format: :csv # write out format
  ]

  def start_link() do
      {:ok, config_table} = open_table(@config_table)
      {:ok, entry_table} = open_table(@entry_table)

      # Parameterlist either not set or corrupted, reset, TODO: Compare keys, length prone for manipulation
      if length(get_config(:all_keys, config_table)) != length(@default_config) do
        init_config(config_table)
      end

      # Agent loads/keeps tables open, writes/reads tables
      Agent.start_link(fn -> {config_table, entry_table} end, name: __MODULE__)
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
    {_, table} = Agent.get(__MODULE__, & &1)
    case type do
      :new -> :dets.insert_new(table, entry)
      :replace -> :dets.insert(table, entry)
      _ -> raise ArgumentError, message: "Unknown action: #{type}"
    end
  end

  def put_config(key, value) do
    # check if config is in @default config key list then write
    table = get_table(@config_table)
    :dets.insert(table, {key, value})
  end

  def get_config(key \\ :all_keys, table \\ nil)
  def get_config(:all_keys, table) do
    table = if is_nil(table), do: get_table(@config_table), else: table
    key_list = Keyword.keys(@default_config)
    :dets.match_object(table, {:"$1", :"$2"})
  end 
  def get_config(key, table) do
    table = if is_nil(table), do: get_table(@config_table), else: table
    # :dets.match_object(table, {key, :"$2"}) # REVIEW: Which one to choose
    :dets.lookup(table, key)
  end

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
    path = Application.get_env(:pow, :env_path)

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


  """
    
  """
  @doc """
    Initialize default arguments if not existent in dets table
  """
  def init_config(table \\ nil) do
    table = if is_nil(table), do: get_table(@config_table), else: table

    :dets.init_table(table, fn :read -> {@default_config, fn :read -> :end_of_input end} end)
  end

end

