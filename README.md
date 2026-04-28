<p align="center">
    <img src="tbcselect.svg" width="30%">
</p>

# TBCSelector

I really created this small script for myself as I was tired of editing Tor Browser files manually, but since it works, I decided to add few things to it and share.

This scripts allow in simple way to choose exit nodes (countries) you would like to use with Tor Browser. Instead of editing files manually from command line, this script allows to do is using GUI.

## Requirements 

Main requirements to run this script is Linux with Graphics environment, bash and [Yad](https://yad-guide.ingk.se/). If you run Linux Debian, Ubuntu or systems based on one of these distributions (like Linux Mint), you will have to install newer version of Yad as this one available in repositories is old ( 0.40.0-1 or 7.2-1) and not all functions will work. I recommend to use version 14.2 which can be downloaded from Yad GitHub repository https://github.com/v1cont/yad.

## Installation

To install TBCSelector, clone this GitHub repository and run installation script `install.sh`.
This will place TBCSelector required files in `./local/bin`,`./local/share/tbcselect`,`./config/tbcselect` and `Desktop` directory of user from which it has been run.

After installation, you can run script by clicking on its icon located on your desktop or running command `tbcselect.sh` from command line.