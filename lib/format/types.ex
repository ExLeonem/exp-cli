defmodule Exp.Format.Types do
    require Logger
    @moduledoc """
        Formatting different datatypes like time etc.
    """


    @doc """
        Sets the switch types of a switch definition to the same value.
    """
    def set_type(flags, type \\ :boolean)
    def set_type(flags, type) when type in [:boolean, :count, :integer, :float, :string] do
        flags
        |> Enum.map(fn {key, _} -> {key, type} end)
    end
    def set_type(_, _), do: raise ArgumentError, message: "Only list allowed for flags in set_list_types()."



    # Actions on config.exs

    @doc """
        Returns either a schema for the options parser, or a keyword list of config parameter and default value.
    """
    def extract(action) do

        transform = case action do
            :schema -> fn {key, [type, _, _]} -> {key, type} end
            :defaults -> fn {key, [_, default, _]} -> {key, default} end
            :write -> fn {key, [_, _, write?]} -> {key, write?} end
            :keys -> fn {key, _} -> key end 
            _ -> fn params -> params end
        end

        Application.get_env(:exp, :params, nil)|> Enum.map(transform)
    end

end