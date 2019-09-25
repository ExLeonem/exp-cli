defmodule Exp.Format.CLI do
    alias IO.ANSI, as: ANSI
    alias Exp.Format.CLI.Symbol

    @moduledoc """
        Formatting the CLI output. 
    """

    # TODO: use the IO.ANSI module to format the output

    def regular(message, status, icon) do
        config = [
            type: status,
            default_icon: "",
            icon_color: "",
            msg_color: ""
        ]

        create_message(message, icon, config)
    end


    def ok(message, icon \\ "") do
        config = [
            type: :ok, 
            default_icon: get_icon(:check), 
            icon_color: ANSI.light_green, 
            msg_color: ANSI.light_white
        ]
        create_message(message, icon, config)
    end

    def error(message, icon \\ "") do
        config = [
            type: :error, 
            default_icon: get_icon(:cross), 
            icon_color: ANSI.red, 
            msg_color: ANSI.light_white
        ]
        create_message(message, icon, config)
    end

    def warn(message, icon \\ "") do
        config = [
            type: :error, 
            default_icon: get_icon(:light), 
            icon_color: ANSI.yellow, 
            msg_color: ANSI.light_white
        ]
        create_message(message, icon, config)
    end

    def create_message(message, icon, config) do
        icon = if icon != "", do: get_icon(icon), else: config[:default_icon]
        msg = "\n\s\s" <> config[:icon_color] <> icon <> "\s\s" <> config[:msg_color] <> message <> "\n"
        {config[:type], msg}
    end

    
    def get_icon(:light), do: Symbol.light_n
    def get_icon(:check), do: Symbol.check
    def get_icon(:add), do: "+"
    def get_icon(:cross), do: Symbol.cross
    def get_icon(:none), do: ""
    def get_icon(:clock), do: Symbol.clock
    

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

        def clock(font \\ :light)
        def clock(:light), do: "🕑"
        def clock(:bold), do: "🕑"

    end

end