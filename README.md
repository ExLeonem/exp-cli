[![Build Status](https://travis-ci.org/ExLeonem/exp-cli.svg?branch=master)](https://travis-ci.org/ExLeonem/exp-cli)
[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/exp-cli/badge.svg?branch=master)](https://coveralls.io/github/ExLeonem/exp-cli?branch=master)
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


**Note:** The directory of the binary needs to be writeable because the CLI will persists entries into dets files.

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
- [x] Configuration
  - [x] Setting Parameters
  - [x] Getting Parameters
- [ ] Query entries
  - [x] Complete List
  - [x] Last Entry
  - [ ] By filter
- [ ] Delete entries
- [ ] Modify entries
- [ ] Time tracking
  - [x] start/stop mechanic
  - [x] save instantly complete entry
  - [ ] start/stop pomodoro watch
- [ ] Export Entries
  - [x] CSV
  - [ ] JSON
  <!-- - [ ] logfmt? -->
- [ ] Import Entries
  - [ ] CSV
  - [ ] JSON
  <!-- - [ ] logfmt -->



## Configuration Parameters

Name          | writeable?  |  Description
---           | ---         | ---
is-recording          | false       | Indicates if application currently is recording the time. Switches by calling the [stop](#Commands) command.
default-block-length  | true        | The block length for the pomodoro timer
default-storage-path  | true        | The directory where the entries are written to
output-format         | true        | Default output format to use on `write` command
last-entry            | false       | DateTime of last entry written to the entry store
<!-- remind                | true        | Set timout to prompt user current state -->


## Commands

To start recording a new entry just type:`exp start`.
To stop the recording timer call `exp stop` .

### General Commands
Name                  | Description                                                      | Implemented 
---                   | ---                                                              | ---
start                 | Starts recording the time                                        | &#9745;
stop                  | Stops the recording and writes an entry                          | &#9745;
status                | Returns the duration since recording                             | &#9744;
[add](#Add)           | Writing an entry instantly                                       | &#9745; 
[show](#Show)         | Prints recorded entries.                                         | &#9745; <!--Checked-->
[get](#Get)           | Get information on current configuration                         | &#9745;
[set](#Set)           | Setting configuration attributes                                 | &#9745;
[-x](#-x)             | Export of saved entries into another format in csv or json       | &#9744;
[sync](#Sync)         | Upload data to the remote application                            | &#9744;
<!-- [import](#import)     | Import a file to the list of current entries                     | &#9744; -->
<!-- [stat](#Stat])  | Show statistics                                                  | &#9744; Unchecked -->
<!-- [remote](#Remote) | Adding a remote application                                    | &#9744; -->


<!-- ### Start

 Start to record time `exp start`
 Start a pomodoro timer `exp start -p`

Flag            | Description
---             | ---
--pomodoro, -p  | Starts a pomodoro timer -->



### Add
Add a new complete entry at once. Equal to recording with start/stop.
If no stop flag is given it assumed that you just finished yet.

Examples:

 `exp add -s 15:10 `

 `exp add -s 12:12 -t "something" -tg tag1,tag2,tag3`     

Flag            | Required? | Description
---             |---        | ---
-s, --start     | true      | Start of the entry `HH:mm` 
-t, --title     | false     | Title of the entry
-tg, --tag      | false     | Add tags to the entry 


### Show
Passing no flag at all will default to -a, --all

Flag          | Description
---           | ---
-l, --last    | Print the last recorded entry.
-a, --all     | Prints all entries to the terminal.
-f, --filter  | Filter all entries by given filter and print them to the terminal.


### Get
Request the current set values of configuration parameters. All parameters usable as flags are listed in the [configuration parameter list](#Configuration_Parameters) section.

Examples: 
  
  `exp get --block-length`

  `exp get --block-length --is-recording`

### Set
Setting default/configuration parameters.

Example: `exp set --block-length 1:30 --output-format csv`

Flag              | Type      |   Description
---               | ---       | ---
--block-length    | string    | Default time for block when using CLI as a pomodoro watch in Format `HH:mm`
--output-format   | string    | Setting the default output format for entry export, supported formats: `csv` and `json`


### -x
Export the recorded data to a specific Format.
The given path must already be existent. Available output formats are csv and json. 

Example: `exp -x /path/file.csv`


<!-- ### Import

Example: `exp -i /path/file.csv` -->


### Sync
Synchronizing data with the remote web application.
This command will prompt for you'r credentials.

Example: `exp sync`



### Contribution
Contribution is very much appreciated. If you are interested to contribute just write me a Mail.
If you have any ideas how to extend this thing. Just open an issue.

<!-- #### Project Structure -->



<!-- #### Donation -->
