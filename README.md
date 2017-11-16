# VinDsl Conky Setup
![Screenshot](desktop.png?raw=true "Screenshot")

This is a curated package of the VinDsl Conky setup that works for Ubuntu 16.04 on 1.9.0 on a screen resolution of 2048x1152.  The way that any of these conky setups work they are somewhat dependent on the exact screen resolution that you run them at.  There are a lot of hard code offsets within the .conkyrc that will have to be tweaked if you want to run it at a different resolution.

Additional setup information can be found on [this](https://ubuntuforums.org/showthread.php?t=1771033) ubuntu forums thread.

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

### Clear Font Cache
Once you have copied all the fonts into place you have to clear your font cache for them to be located.

```
fc-cache -fv
```

### Install Screen Ruler
Most likely, to get everything perfectly positioned you will need screenruler.

```
sudo apt-get install screenruler
```

### Setting up Weather
If you want to make the weather section you will need a weather underground api key (free).  You can sign up and get a key [here](https://www.wunderground.com/weather/api/).

Once you have a key you need to edit ~/.conky/weather/weather.sh.  Around line 73 there is a variable called wunderground_key that needs to be set to your api key:

```
wunderground_key="your key here"
```

Now you need to set the weather location.  All of the rendering information about the weather widget is at the end of the *.conkyrc* file.  Right now all of the weather fetching is done based on zip code.  To enter your zip code edit this section of code:
```
##################################
##     WEATHER (Imperial)       ##
##################################
${voffset 4}${font DroidSans:bold:size=8.25}${color4}WEATHER${offset 8}${color8}${voffset -2}${hr 2}${font}
${voffset 0}${offset 25}${font RadioSpace:size=34}${color3}${execi 1800 ~/.conky/weather/weather.sh "91411" ctbi}${font}${voffset -28}${goto 5}${font Weather:size=42}${color3}y${font}
${voffset -50}${offset 28}${font Ubuntu:size=8.63}${color5}${execi 1800 ~/.conky/weather/weather.sh "91411" ctti}${font}
${voffset -49}${font KRARound:size=36}${color3}${goto 215}I${font}
${voffset 6}${font Ubuntu:size=23}${color5}${alignc -2}${execi 1800 ~/.conky/weather/weather.sh "91411" ccb}${font}
${voffset 10}${font DroidSansFallback:size=8.63}${color3}${execi 1800 ~/.conky/weather/weather.sh "91411"}${font}
${voffset -60}${font ConkyWeather:size=48}${color6}${alignc -55}${execi 1800 ~/.conky/weather/weather.sh "91411" cp}${font}
${voffset 0}${font DroidSansMono:bold:size=8.62}${color4}${offset 40}${execi 1800 ~/.conky/weather/weather.sh "91411" dl}${font}
${voffset 0}${font ConkyWeather:size=37.9}${color3}${offset 26}${execi 1800 ~/.conky/weather/weather.sh "91411" fcp}${font}
${voffset 0}${font DroidSansFallback:bold:size=8.62}${color4}${offset 28}${execi 1800 ~/.conky/weather/weather.sh "91411" fcti}${font}
```

In this case the zip code is set to 91411.  To adjust that replace all of the instances in this section of 91411 with your zip code.  If you wish to make this support something other than zip codes this can be done by editing the *.conky/weather/weather.sh* file and adjusting the way that the weather underground api urls are built.  This is left as an exercise for the reader.
