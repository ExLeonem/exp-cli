defmodule Exp.Format.Types do
    require Logger
    @moduledoc """
        Formatting different datatypes like time etc.
    """







    @doc """
        Modifies the type of a list of keys/flags to be equal.
    """
    def set_type(flags, type \\ :boolean)
    def set_type(flags, type) do
        flags
        |> Enum.map(fn {key, _} -> {key, type} end)
    end
    def set_type(_, _), do: raise ArgumentError, message: "Only list allowed for flags in set_list_types()."

    # Actions on config.exs

    @doc """
        Returns either a schema for the options parser, or a keyword list of config parameter and default value.
    """
    def extract(:schema) do
        Application.get_env(:exp, :params, nil)
        |> Enum.map(fn {key, [type, _, _]} -> {key, type} end)
    end

    def extract(:defaults) do
        Application.get_env(:exp, :params, nil)
        |> Enum.map(fn {key, [_, default, _]} -> {key, default} end)
    end

    def extract(:write) do
        Application.get_env(:exp, :params, nil)
        |> Enum.map(fn {key, [_, _, write?]} -> {key, write?} end)
    end


end