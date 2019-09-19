defmodule Exp.Format.CLIOutput do
    alias IO.ANSI, as: ANSI

    @moduledoc """
        Formatting the CLI output. 
    """

    # TODO: use the IO.ANSI module to format the output

    

    def indicate(symbol, message, type \\ :ok)
    def indicate(symbol, message, :ok) do
        msg = " " <> ANSI.light_green <> symbol <> ANSI.white <> " " <> message 
        {:ok, msg}
    end

    def indicate(symbol, message, :error) do
        msg = " " <> ANSI.red <> symbol <> " " <> ANI.white <> message
        {:error, msg}
    end


    defmodule Symbol do


        def light_n(font \\ :light)
        def light_n(:light), do: "⚡"
        def light_n(:bold), do: "🗲"

        def check(font \\ :light)
        def check(:light), do: "✓"
        def check(:bold), do: "✔"

        def cross(font \\ :light)
        def cross(:light), do: "྾"
        def cross(:bold), do: "🞬"

    end

end