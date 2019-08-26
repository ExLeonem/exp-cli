defmodule Pow.Action.State do
  use Agent
  require Logger
  @moduledoc """
    Configuration of the CLI. Writing reading parameters.
  """

  """
    config :pow,
    format: :csv,
    chunk_size: "1:30",
    env_path: Path.join([System.user_home(), "Desktop", "PowTime"]),
    timer: "",
    record: false, 
    start_time: nil # Set everytime new when recording
  """

  @config_table :config_store
  @entry_table :entry_store

  def start_link() do
      {:ok, config_table} = get_config_table()
      {:ok, entry_table} = get_entry_table()

      # Agent loads/keeps tables open, writes/reads tables
      Agent.start_link(fn -> {config_table, entry_table} end, name: __MODULE__)
  end


  def get_config_table() do
      :dets.open_file(@config_table, [type: :set, access: :read_write])
  end

  def get_entry_table() do
      :dets.open_file(@entry_table, [type: :set, access: :read_write])
  end

  def write_entry(entry) do
    {_, table} = Agent.get(__MODULE__, & &1)
    :dets.insert_new(table, entry)
  end



  def read_config(key) do
    {table, _} = Agent.get(__MODULE__, & &1)

    query = :ets.fun2ms(fn ({en_key, en_value} = entry) when key == en_key -> entry end)
    :dets.select(table, query)
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
end

