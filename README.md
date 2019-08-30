[![Build Status](https://travis-ci.com/ExLeonem/exp.svg?branch=master)](https://travis-ci.com/ExLeonem/exp)

#  EXP CLI - Track you'r time
The EXP CLI a tool for tracking the time you spend working on a project or learning. 


## Table of Contents
- [Installation](#Installation)
- [Roadmap](#Roadmap)
- [Commands](#Commands)
- [Contributing](#Contributing)


## Installation
There are no existing dependencies to other libraries.
To use the CLI Erlang/Elixir needs to be installed loally. Other than that

1. Clone the Repo
`git clone https://github.com/ExLeonem/exp.git`

2. CD into the Repo
3. Execute `mix escript.build` (Building the binary)
4. Adding the place where the binary is to the Path


**Note:** The directory where the binary is needs to be writeable, because the CLI will be persisting entries into a DETS File.

<!-- If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exp, "~> 0.1.0"}
  ]
end
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exp](https://hexdocs.pm/exp). -->

## Roadmap

- [ ] Custom Entry fields
- [ ] Statistics 
- [ ] Configuration
  - [ ] Setting Parameters
  - [ ] Getting Parameters
- [ ] Query entries
  - [x] Complete List
  - [x] Last Entry
  - [ ] By filter
- [ ] Saving entries through CLI
  - [x] start/stop mechanic
  - [ ] save entry
- [ ] Reminder/Timer functionality 
- [ ] DETS Flush
- [ ] Write out DETS Data
  - [ ] CSV
  - [ ] JSON
  - [ ] XML



## Commands

To start recording a new entry just type:`exp start`.
To stop the recording call `exp stop`.

### General Commands
Name         | Description                                                      | Implemented 
---          | ---                                                              | ---
start        | Starts recording an entry (Sets time when recording started)     | [x]
stop         | Stops the recording and writes entry to DETS                     | [x]
add          | Writing an an entry directly into DETS                           | [ ]
show         | Prints recorded entries.                                         | [x]
get          | Get information on current configuration                         | [ ]
set          | Setting configuration attributes                                 | [ ]
write        | Writes out currently saved entries from DETS into a given format | [ ] 
stat         | Show statistics                                                  | [ ]



### Show-Command
Passing no flag at all will default to -a, --all

Flag          | Description
---           | ---
-l, --last    | Output the last recorded entry.
-a, --all     | Output all entries
-f, --filter  | Filter output with passed query


### Contributing
For the moment just hook me up.


