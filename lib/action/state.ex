defmodule Pow.Action.State do
  require Logger
  @moduledoc """
    Configuration of the CLI. Writing reading parameters.
  """

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


  def get_config(key) do
    Application.get_env(:pow, key)
  end

  def put_config(key, value) do
    Application.put_env(:pow, key, value, persistent: true)
  end

end

