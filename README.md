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

## Installing Yad from sources

If you found yourself in situation that your Linux distribution have only older version of Yad in its repositories, you can always compile Yad from sources. I work since many years on Linux Mint and unfortunately Yad version available in repositories is 0.40.0 which mean this was only way to get newer version.
I tested compiled version under Linux Mint 22.3 and I think it works as expected.

Generally I don't like to have too much mess on my system so usually I use Virtual Machine or Docker for compilation process but of course it is not always possible.

Below are described two methods which allowed me to get installed newest version of Yad on my Linux Mint (Ubuntu Noble base).

### Compiling and installing from source

1. Install required packages
```
sudo apt-get install -y build-essential libwebkit2gtk-4.1-dev libgtk-3-dev libglib2.0-dev libgtksourceview-3.0-dev libgspell-1-dev autotools-dev intltool pkg-config debhelper git
```
2. Clone Yad GitHub repository
```
git clone https://github.com/v1cont/yad.git yad_build
```
3. Compile
```
cd yad_build
autoreconf -ivf
./configure
make
sudo make install
```

### Build Yad .deb package using Docker

At the end of this process, you will get Yad .deb package which you will install on your system (my preferred method).

1. Install Docker if you don't have it
2. Find version/codename of your system.
```
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 24.04.4 LTS
Release:	24.04
Codename:	noble
```
or on systems based on Ubuntu 
```
$ cat /etc/upstream-release/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu Noble Numbat"
```
In this situation (mine situation) base Ubuntu system have version 24.04 and its codename is noble

3. Run building Yad .deb package
To make this process painless I created bash script which will build Yad .deb package inside Docker container.

```
docker run -it --rm -v $PWD:/yad_build -e UUID=$(id -u) -e GGID=$(id -g) ubuntu:noble /yad_build/buildyad.sh
```
Remember to change your base docker images "ubuntu:noble" to corresponding to your distribution and codename.

4. Install Yad
After building process will finish, you will find new `yad_14.2.0-0.1_amd64.deb` package in `yad_build` directory. To install newly created package run:
```
sudo apt install -y ./yad_14.2.0-0.1_amd64.deb
```

5. Test installed Yad
```
$ yad --version
14.200 (GTK+ 3.24.41)
```

### Customization of Yad's .deb package building file
To get correct version of Yad's package to be created (based on information located in NEWS file) I had to do some small modification to few files in `debian` directory. If new version of Yad will be publish, changes in `buildyad.sh` script will be necessary to reflect this change.
