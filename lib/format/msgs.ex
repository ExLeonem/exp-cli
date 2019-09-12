defmodule Exp.Format.Msgs do
    @moduledoc """
        Formatting the output messages for results of commands.
    """



    def to_string(nil), do: "nil"
    def to_string(""), do: "nil"
    def to_string(value) when is_binary(value), do: value
    def to_string(value), do: Kernel.to_string(value)


end