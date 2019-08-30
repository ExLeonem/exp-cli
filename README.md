[![Build Status](https://travis-ci.com/ExLeonem/exp.svg?branch=master)](https://travis-ci.com/ExLeonem/exp)
![](https://img.shields.io/badge/elixir-1.9.1-blue)


#  EXP CLI - Track you'r time
The EXP CLI a tool for tracking the time you spend working on a project or learning. 


## Table of Contents
- [Installation](#Installation)
- [Roadmap](#Roadmap)
- [Configuration Parameters](#Configuration_Parameters)
- [Commands](#Commands)
  - [Add](#Add)
  - [Show](#Show)
  - [Get](#Get)
  - [Set](#Set)
- [Contribution](#Contribution)


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

## Roadmap/Ideas

- [ ] Native Application 
- [ ] Collect additional Data
  - [ ] Github Commits (time and message)
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
  - [ ] save instantly complete entry
- [ ] Reminder/Timer functionality 
- [ ] DETS Flush
- [ ] Write out DETS Data
  - [ ] CSV
  - [ ] JSON
  - [ ] XML


## Configuration Parameters

Name          | writeable?  |  Description
---           | ---         | ---
is-recording  | false       | Indicates if application currently is recording the time. Switches by calling the [stop](#Commands) command.
block-length  | true        | Indicates the length of 
timer         | false       | 
remind        | false       |
output-format | true        |
last-entry    | false       |



## Commands

To start recording a new entry just type:`exp start`.
To stop the recording call `exp stop`.

### General Commands
Name            | Description                                                      | Implemented 
---             | ---                                                              | ---
start           | Starts recording an entry (Sets time when recording started)     | <ul><li>[x]</li></ul>
stop            | Stops the recording and writes entry to DETS                     | <ul><li>[x]</li></ul>
[add](#Add)     | Writing an an entry directly into DETS                           | <ul><li>[ ]</li></ul>
[show](#Show)   | Prints recorded entries.                                         | <ul><li>[x]</li></ul>
[get](#Get)     | Get information on current configuration                         | <ul><li>[ ]</li></ul>
[set](#Set)     | Setting configuration attributes                                 | <ul><li>[ ]</li></ul>
[write](#Write) | Writes out currently saved entries from DETS into a given format | <ul><li>[ ]</li></ul> 
[stat](#Stat])  | Show statistics                                                  | <ul><li>[ ]</li></ul>



###Show
Passing no flag at all will default to -a, --all

Flag          | Description
---           | ---
-l, --last    | Output the last recorded entry.
-a, --all     | Output all entries
-f, --filter  | Filter output with passed query


###Get
Request the current set values of configuration parameters. All parameters usable as flags are listed in the [configuration parameter list](#Configuration_Parameters) section.

Example: `exp get --block-length`


###Set
Setting default/configuration parameters.

Example: `exp set --block-length 1:30 --output-format csv`

Flag              | Type      |   Description
---               | ---       | ---
--block-length    | string    | Default time for block when using CLI as a pomodoro watch in Format `HH:mm`
--output-format   | string    | Setting the default output format for entry export, supported formats: `csv` and `json`




### Contribution
If you are interested to contribute just write me a PM.


