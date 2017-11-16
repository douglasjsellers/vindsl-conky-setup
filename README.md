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

### Start Conky
At this point you should start conky and see what happens

```
sudo killall conky ; conky
```

### Fixing Defects
At this point, most likely, you will see some defects in the way that it is rendered.  Mainly there are two kinds of positioning errors.

#### Badly Positioned Bar Charts
To fix this issue you need to edit ~/.conky/bargraph_small.lua.  Each of the bars is represneted like this:
```
		{	--[ Graph for CPU1 ]--
			name="cpu",
			arg="cpu1",
			max=100,
			alarm=50,
			alarm_colour={0xFF0000,0.72},
			bg_colour={0xFFFFFF,0.25},
			fg_colour={0x00FF00,0.55},
			mid_colour={{0.45,0xFFFF00,0.70}},
			x=92,y=210,
			blocks=65,
			space=1,
			height=2,width=5,
			angle=90,
			smooth=true
			},
```
What you want to adjust is the x and y coordinates.  The easiest way to solve these issues is to fire up screenruler, measure from the top of the screen down to the location you want the particular chat bar to be and then enter that number as the y.  Then it is easiest to just fiddlle with the x number to get it placed perfectly rather than trying to measure.  You will probably have to do that for each of the bar charts.

#### Positioning Everything Else
The rest of the positioning is controlled by the *voffset* and the *offset* parameters of the particular widgets in the *.conkyrc* file.  The different widgets are commented well.  Just start from the top and work your way down, adjusting it to look more or less like the screen shot at the start of this guide.  
