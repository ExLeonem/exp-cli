[![Build Status](https://travis-ci.org/ExLeonem/exp-cli.svg?branch=master)](https://travis-ci.org/ExLeonem/exp-cli)
[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/exp-cli/badge.svg?branch=master)](https://coveralls.io/github/ExLeonem/exp-cli?branch=master)
![](https://img.shields.io/badge/elixir-1.9.1-blue)


![banner](.banner.png)


#  EXP CLI -Track you'r time
A tool to track the time you spend working on a project.


## Table of Contents
- [Installation](#Installation)
<!-- - [Roadmap](#Roadmap) -->
- [Configuration Parameters](#Configuration_Parameters)
- [Commands](#Commands)
  - [Add](#Add)
  - [Show](#Show)
  - [Get](#Get)
  - [Set](#Set)
  - [Export](#Export)
- [Contribution](#Contribution)


## Installation
There are no existing dependencies to other libraries.
However a prequisite for the use is Elixir in version >= 1.8.
To Use the CLI you can download the binary or build it locally and afterwards add it to you'r path.

## How to build locally?
If you want to use this project as a base for something or just further develop it.

1. Clone the Repo with`git clone https://github.com/ExLeonem/exp.git`
2. CD into the Repo
3. Execute `mix deps.get && mix escript.build`alternativly you can configure the dev dependencies
4. Adding the place where the binary is to the Path
5. And you are ready to go

**Note:** The directory of the binary needs to be writeable because the CLI will persists the entries into files.


<!-- ## Roadmap
- [x] Configuration
  - [x] Setting Parameters
  - [x] Getting Parameters
- [ ] Query entries
  - [x] Complete List
  - [x] Last Entry
  - [ ] By filter
- [x] Delete
  - [x] last entry
  - [x] all entries
  - [ ] filter term
- [ ] Time tracking
  - [x] start/stop mechanic
  - [x] save instantly complete entry
  - [ ] start/stop pomodoro watch
- [x] Export Entries
  - [x] CSV
  - [x] JSON -->
  <!-- - [ ] logfmt? -->



## Configuration Parameters

Name          | writeable?  |  Description
---           | ---         | ---
is-recording          | false       | Indicates if application currently is recording the time. Switches by calling the [stop](#Commands) command.
default-block-length  | true        | The block length for the pomodoro timer
default-storage-path  | true        | The directory where the entries are written to
output-format         | true        | Default output format to use on `write` command
last-entry            | false       | DateTime of last entry written to the entry store


## Commands

To start recording a new entry just type:`exp start`.
To stop the recording timer call `exp stop -t "Give your record a title"` .

### General Commands
Name                  | Description                                                      | Implemented 
---                   | ---                                                              | ---
start                 | Starts recording the time                                        | &#9745;
stop                  | Stops the recording and writes an entry                          | &#9745;
status                | Returns the duration since recording                             | &#9745;
[add](#Add)           | Writing an entry instantly                                       | &#9745; 
[show](#Show)         | Prints recorded entries.                                         | &#9745; <!--Checked-->
[delete](#Delete)     | Deletion of entries                                              | &#9745;
[get](#Get)           | Get information on current configuration                         | &#9745;
[set](#Set)           | Setting configuration attributes                                 | &#9745;
[-x](#Export)             | Export of saved entries into another format in csv or json   | &#9745;
-v, --version         | Prints the current CLI version                                   | &#9745;

<!-- &#9745; <!-- unchecked > -->

<!-- ### Start

 Start to record time `exp start`
 Start a pomodoro timer `exp start -p`

Flag            | Description
---             | ---
--pomodoro, -p  | Starts a pomodoro timer -->



### Add
Add a complete entry. In essence is equal to recording with start/stop.

If no stop flag is given the end is assumed to be the moment you add the entry. You can use a date on the start and end tags as well
to calculate the time usage over multiple days.

Examples:

 `exp add -s 15:10 `

 `exp add -s 12:12 -t "I worked on my project" -g tag1,tag2,tag3`

  `exp add -s "10-10-2019 10:10" -e "11-10-2019 15:00" --title "hello world"`   

Flag            | Required? | Description
---             |---        | ---
-s, --start     | true      | Start of the entry formatted as`HH:MM`, `DD-MM-YYYY HH:MM` or `DD-MM-YYYY`. The missing parts will be filled with the current DateTime
-e, --end       | false     | End of the recording. Allowed formats are the same as in `--start`
-t, --title     | true      | Title of the entry
-g, --tag       | false     | Add tags to the entry 


### Show
Passing no flag at all will default to -a, --all

Flag          | Description
---           | ---
-l, --last    | Print the last recorded entry.
-a, --all     | Prints all entries to the terminal.
-f, --filter  | Filter all entries by given filter and print them to the terminal.


## Delete
You can use followin command to the delete an persistet entry.

Examples:

  `exp delete -l `

  `exp delete --all`

Flag          | Description
---           | ---
-l, --last    | Delete the last entry
-a, --all     | Delete all entries
-f, --filter  | Delete entries by filter term



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


### Export
Export the recorded data to a specific Format.
The given path must already be existent. Suported output formats are currently **csv** and **json**. 

Example: `exp -x /path/file.csv`


### Contribution
Contribution is very much appreciated. If you are interested to contribute just write me a Mail.
If you have any ideas how to extend this thing. Just open an issue.

<!-- #### Project Structure -->



<!-- #### Donation -->
