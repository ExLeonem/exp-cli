# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :exp, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:exp, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

# Configuration keys and type


# Params: default application configuration, structure of single parameter [type, default_value, is_modifyable?]
# Commands: Each represents an top-level option and the flags that may be set for it
# Fields:  used on saving an entry the inner defnition: [type_of_field, is_required?, alias]. The :none atom specifies a field without alias.
config :exp,
    params: [
        block_length: [:string, "1:30", true],
        is_recording: [:boolean, false, false],
        remind: [:string, nil, true], # can be set but flag must be passed on start
        time_started: [:string, nil, false],
        output_format: [:string, :csv, true],
        last_entry: [:string, nil, false], # Is this needed at all? --> build complete entry and save here instead of interating over all entries?
        version: [:string, Mix.Project.config[:version], false],
        default_storage_path: [:string, File.cwd!, false],
        # supported_types: [:array, [:csv, :json, :xml, :yaml], false],
        # last_write: [:string, nil, false] # Last time data was writen to fs
        # default_path [:string, cwd(), true] # The default path were to write/read data to/from
    ],
    commands: [
        start: [
            aliases: [ timer: :t,remind: :r ],
            strict: [ timer: :string, remind: :string]
        ],
        stop: [
            aliases: [t: :title, g: :tag],
            strict: [title: :string, tag: :string]
        ]
    ],
    fields: [
        date: [:string, false, :none],
        start: [:string, true, :s], # ATTENTION: Start field must be followed by end field. 
        end: [:string, false, :e], 
        title: [:string, true, :t],
        tag: [:string, false, :none]
    ]

    