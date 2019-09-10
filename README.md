[![Build Status](https://travis-ci.com/ExLeonem/exp.svg?branch=master)](https://travis-ci.com/ExLeonem/exp)
[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/exp/badge.svg)](https://coveralls.io/github/ExLeonem/exp)
![](https://img.shields.io/badge/elixir-1.9.1-blue)


<div style="text-align:center">
  <img src="./.favicon.png">
</div>


#  EXP CLI -Track you'r time
A tool to track the time you spend working on a project or anything else.


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
- [ ] Connect to 3rd party applications to collect additional data
  - [ ] Github Commits (time and message)
  - [ ] Quire/Google Task etc.
- [ ] Statistics 
- [x] Configuration
  - [x] Setting Parameters
  - [x] Getting Parameters
- [ ] Query entries
  - [x] Complete List
  - [x] Last Entry
  - [ ] By filter
- [x] Saving entries through CLI
  - [x] start/stop mechanic
  - [x] save instantly complete entry
- [ ] Reminder/Timer functionality 
- [ ] DETS Flush
- [ ] Export DETS Data
  - [x] CSV
  - [ ] JSON
  - [ ] XML
- [ ] Import DETS Data


## Configuration Parameters

Name          | writeable?  |  Description
---           | ---         | ---
is-recording  | false       | Indicates if application currently is recording the time. Switches by calling the [stop](#Commands) command.
block-length  | true        | Indicates the length of 
remind        | true        | Set timout to prompt user current state
output-format | true        | Default output format to use on `write` command
last-entry    | false       | DateTime of last entry written to the entry store



## Commands

To start recording a new entry just type:`exp start`.
To stop the recording call `exp stop`.

### General Commands
Name            | Description                                                      | Implemented 
---             | ---                                                              | ---
start           | Starts recording an entry (Sets time when recording started)     | &#9745;
stop            | Stops the recording and writes entry to DETS                     | &#9745;
[add](#Add)     | Writing an an entry directly into DETS                           | &#9745; 
[show](#Show)   | Prints recorded entries.                                         | &#9745; <!--Checked-->
[get](#Get)     | Get information on current configuration                         | &#9745;
[set](#Set)     | Setting configuration attributes                                 | &#9745;
[write](#Write) | Writes out currently saved entries from DETS into a given format | &#9744;
[stat](#Stat])  | Show statistics                                                  | &#9744; <!--Unchecked-->



### Add


Flag            | Description
---             | ---
-s, --start     | Start of the entry `HH:mm` 
-t, --title     | Title of the entry
-tg, --tag      | Add tags to the entry `exp add - "something" -tg tag1,tag2,tag3`     


### Show
Passing no flag at all will default to -a, --all

Flag          | Description
---           | ---
-l, --last    | Output the last recorded entry.
-a, --all     | Output all entries
-f, --filter  | Filter output with passed query


### Get
Request the current set values of configuration parameters. All parameters usable as flags are listed in the [configuration parameter list](#Configuration_Parameters) section.

Example: `exp get --block-length`


### Set
Setting default/configuration parameters.

Example: `exp set --block-length 1:30 --output-format csv`

Flag              | Type      |   Description
---               | ---       | ---
--block-length    | string    | Default time for block when using CLI as a pomodoro watch in Format `HH:mm`
--output-format   | string    | Setting the default output format for entry export, supported formats: `csv` and `json`


### Contribution
Contribution is very much appreciated. If you are interested to contribute just write me a Mail.
If you have any ideas how to extend this thing. Just open an issue.

<!-- #### Project Structure -->



<!-- #### Donation -->
