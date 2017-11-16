# VinDsl Conky Setup
![Screenshot](desktop.png?raw=true "Screenshot")

This is a curated package of the VinDsl Conky setup that works for Ubuntu 16.04 on 1.9.0 on a screen resolution of 2048x1152.  The way that any of these conky setups work they are somewhat dependent on the exact screen resolution that you run them at.  There are a lot of hard code offsets within the .conkyrc that will have to be tweaked if you want to run it at a different resolution.

## Getting Started
### Conky Version
This conky setup does not work on any version of conky post 1.9.x.  Here is how I back ported to conky 1.9 on Ubuntu (the first line removes any existing conky and my be unnecessary):
```
sudo apt-get remove --purge conky-std conky-all
wget http://security.ubuntu.com/ubuntu/pool/universe/c/conky/conky-all_1.9.0-6build1_amd64.deb
sudo apt-get install gdebi
sudo gdebi conky-all_1.9.0-6build1_amd64.deb
sudo apt-mark hold conky-all
```

### Copying files into place
After you clone the repo you have to copy all the files into your home directory.  The following files and directories must be in ~/
1. .conkyrc
2. .fonts (directory)
3. .conky (directory)


