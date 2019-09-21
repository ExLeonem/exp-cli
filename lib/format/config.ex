defmodule Exp.Format.Config do
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



    @doc """    
        Uses the config.exs to extract specific sections out of it.
        
        ## Parameter
        - action: The type of action to execute, as an atom
        - config_type: [:params, :command, :fields]
        - options: Keywordlist of options, depending on config_type

        ### fields
        Following values are returned for specific actions.

            - schema: returns a definition that can be used by an OptionParser
            - required: 
            - alias: 
            - keys: returns a list of keys [key1, key2, key3]

        Returns the prepared config defintions
    """
    def extract(action, config_type \\ :param, options \\ [])
    # Extracts default application configuration parameter
    def extract(action, :param, _) do

        transform = case action do
            :schema -> fn {key, [type, _, _]} -> {key, type} end
            :defaults -> fn {key, [_, default, _]} -> {key, default} end
            :write -> fn {key, [_, _, write?]} -> {key, write?} end
            :keys -> fn {key, _} -> key end 
            _ -> fn params -> params end
        end

        Application.get_env(:exp, :params, nil) |> Enum.map(transform)
    end

    def extract(action, :command, _) do
        command_params = Application.get_env(:exp, :commands, nil)
        if !is_nil(command_params) && Keyword.has_key?(command_params, action) do
            command_params[action]
        else
            []
        end
    end

    def extract(action, :field, options) do

        if !is_list(options) do
            raise ArgumentError, message: "Parameter options must be a Keyword list."
        end

        tmp_exclude = if options[:exclude] != nil, do: options[:exclude], else: [] # fields to exclude
        to_exclude = tmp_exclude ++ [:none]

        # Transform field definitions from config.exs
        transform = case action do
            :schema -> fn {name, [type, _, _]} -> {name, type} end
            :required -> fn {name, [_, required?, _]} -> {name, required?} end
            :alias -> fn {name, [_, _, alias]} -> {alias, name} end
            :keys -> fn {name, _} -> name end
            _ -> raise ArgumentError, message: "Unknown action passed."
        end
        
        if !is_list(to_exclude) do
            raise ArgumentError, message: "Exclude option is not a list of atoms."
        end

        # Function to filter fields
        exclude =  if !Enum.empty?(to_exclude) do
            fn {name, _} -> name not in to_exclude
                name -> name not in to_exclude
                end
        else
            &(&1) 
        end

        filtered = Application.get_env(:exp, :fields)
        |> Enum.map(transform)
        |> Enum.filter(exclude)

    end

end