defmodule Exp.Format.Types do
    alias Exp.Format.Config    
    @moduledoc """
        Utilities to format and generate types
    """

    # All keys are in field_required, because same base and no exclusion of keys
    @field_type Config.extract(:schema, :field)
    @field_required? Config.extract(:required, :field)
    @field_keys Config.extract(:keys, :field)


    @doc """
        Build entries dynamically.

        Returns tuple representing the entry to be written into the store.
    """
    def build_entry({_, rest, invalid}) when rest != [] or invalid != [], do: {:error, "Invalid parameters passed."}
    def build_entry({values, _, _}) do
        IO.inspect(values)
        iterate_fields(@field_keys, values)
    end

    @doc """
        Iterate over all field keys and build an entry as well as setting default values.

        Parameter:
        - fields: List of field keys as atoms `[:date, :title, :start, ...]` is getting read from config.exs
        - values: The passed values via CLI, as keyword list `[date: "22.10.2019", ...]`
        - acc: Accumulator adding up the values
        - next: Follow up function to use on next entry `&fun/3` must take same parameters as `&iterate_fields/3`

        Returns list of all values that can be further processed `["22.10.2019", "Some title", ...]` for example joined to :csv format etc.
    """
    
    def iterate_fields(fields, values, acc \\ [], opts \\ [])
    def iterate_fields([], _, acc, _), do: acc # Return the build entry value list
    def iterate_fields([:date = key| rest], values, acc, opts) do
        # field_value = values[key]
        
        result = process_field(values[key], :date)

        case result do
            {:ok, value} -> iterate_fields(rest, values, [value| values], opts)
            {:error, _} -> result
        end

        # next(rest, values, acc, next)    
    end

    # Catch end on next iteration and add another field
    def iterate_fields([:start = key| rest], values, acc, _opt) do
        
    end

    # def iterate_fields([:end = key| rest], values, acc, next)

    # No specific processing for given key, but key is required. Therefore return error if empty
    def iterate_fields([key| rest], values, acc, opt) do
        field_value = values[key]

        

        if !empty?(field_value) && @field_required?[key] == true do
            iterate_fields(rest, values, [field_value| acc], opt)
        else
            # Field is required, but no value was passed
            {:error, "There was no value passed for field: #{key}"}    
        end
    end


    @doc """
        Checks if given field value is empty.

        return true | false depending if field value is empty
    """
    def empty?(value) when value == "" or is_nil(value) or (is_list(value) and value == []) or (is_map(value) and value == %{}) , do: true
    def empty?(_), do: false


    @doc """
        Processes a field value. Check required, generate default if empty or return error.

        Returns tuple {:ok, value} | {:error, status}
    """
    def process_value(value, key, type \\ :string, opts \\ [])
    
    def process_value(value, key, :string, opts) do

        if @field_required?[key] do

            if !empty?(value) do
                # Field required and not empty

            else
                {:error, "Required field #{key} is empty."}
            end

        else
            # Default value for fields
            default = if empty?(opts[:default]), do: opts[:default], else: ""

            # Function to change format of field
            transform = if !is_nil(opts[:format]) && is_function(opts[:format]), do: opts[:format], else: &(&1)
        
            case !empty?(value) do
                {:ok, value}
            else
                {:ok, default}
            end 

        end

    end
 



    @doc """
        Check if the supplied value has the right format as specified
    """
    def check(value, type \\ :string)
    def check(value, :integer) do
        
    end
    
    def check(value, :date) do
        
    end

    def check(value, :string) do
        
    end

end