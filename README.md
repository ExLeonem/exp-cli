[![Build Status](https://travis-ci.org/ExLeonem/exp-cli.svg?branch=master)](https://travis-ci.org/ExLeonem/exp-cli)
[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/exp-cli/badge.svg?branch=master)](https://coveralls.io/github/ExLeonem/exp-cli?branch=master)
![](https://img.shields.io/badge/elixir-1.9.1-blue)


<div style="margin:0; padding:0;">
  <svg width="100%" height="200" viewBox="0 0 1000 600" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="600" fill="#1A30FF"/>
    <path d="M233.673 175L224.317 175L205 187.783V197.258L223.864 184.775H224.317L224.317 306.5L233.673 306.5L233.673 175Z" fill="white"/>
    <path d="M283.059 175L273.702 175L254.386 187.783V197.258L273.25 184.775H273.702L273.702 306.5H283.059L283.059 175Z" fill="white"/>
    <path d="M311.921 242.149C315.656 242.149 318.712 239.104 318.712 235.382C318.712 231.66 315.656 228.614 311.921 228.614C308.186 228.614 305.13 231.66 305.13 235.382C305.13 239.104 308.186 242.149 311.921 242.149ZM311.921 203.198C315.656 203.198 318.712 200.153 318.712 196.431C318.712 192.708 315.656 189.663 311.921 189.663C308.186 189.663 305.13 192.708 305.13 196.431C305.13 200.153 308.186 203.198 311.921 203.198Z" fill="white"/>
    <path d="M361.703 175H352.346L333.029 187.783V197.258L351.893 184.775H352.346L352.346 306.5H361.703L361.703 175Z" fill="white"/>
    <path d="M411.088 175H401.732L382.415 187.783V197.258L401.279 184.775H401.732L401.732 306.5H411.088L411.088 175Z" fill="white"/>
    <path d="M311.921 242.149C315.656 242.149 318.712 239.104 318.712 235.382C318.712 231.66 315.656 228.614 311.921 228.614C308.186 228.614 305.13 231.66 305.13 235.382C305.13 239.104 308.186 242.149 311.921 242.149ZM311.921 203.198C315.656 203.198 318.712 200.153 318.712 196.431C318.712 192.708 315.656 189.663 311.921 189.663C308.186 189.663 305.13 192.708 305.13 196.431C305.13 200.153 308.186 203.198 311.921 203.198Z" fill="white"/>
    <path d="M521 306H600.826V291.928H536.812V247.408H595.725V233.336H536.812V189.072H599.806V175H521V306Z" fill="white"/>
    <path d="M635.957 175H617.34L659.421 240.5L617.34 306H635.957L669.622 252.525H670.642L704.307 306H722.924L681.864 240.5L722.924 175H704.307L670.642 229.498H669.622L635.957 175Z" fill="white"/>
    <path d="M743.503 306H759.315V258.154H787.879C818.292 258.154 832 239.604 832 216.449C832 193.294 818.292 175 787.624 175H743.503V306ZM759.315 244.082V189.072H787.114C808.345 189.072 816.443 200.714 816.443 216.449C816.443 232.185 808.345 244.082 787.369 244.082H759.315Z" fill="white"/>
  </svg>

</div>


#  EXP CLI -Track you'r time
A tool to track the time you spend working on a project.


## Table of Contents
- [Installation](#Installation)
- [Roadmap](#Roadmap)
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
- [x] Export Entries
  - [x] CSV
  - [x] JSON
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
[delete](#Delete)     | Deletion of entries                                              | &#9744;
[get](#Get)           | Get information on current configuration                         | &#9745;
[set](#Set)           | Setting configuration attributes                                 | &#9745;
[-x](#Export)             | Export of saved entries into another format in csv or json   | &#9745;
-v, --version         | Prints the current CLI version                                   | &#9745;


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
The given path must already be existent. Suported output formats are currently csv and json. 

Example: `exp -x /path/file.csv`


### Contribution
Contribution is very much appreciated. If you are interested to contribute just write me a Mail.
If you have any ideas how to extend this thing. Just open an issue.

<!-- #### Project Structure -->



<!-- #### Donation -->
