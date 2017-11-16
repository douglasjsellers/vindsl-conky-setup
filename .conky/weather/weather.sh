#!/bin/bash

# weather.sh

#######################################################
# @Author: Hardik Mehta <hard.mehta@gmail.com>  (2009-2010)
# @Hackor: VinDSL <perfect.pecker@excite.co.uk> (2011)
# 
# @version: 2.0   optimized/code cleanup (VinDSL)
#                 removed line feed variables from most style sheets (VinDSL)
#                 embedded line feeds allow .conkyrc to control spacing/alignment
#                 added current forecast date in weather.xslt (VinDSL)
# @version: 1.2   rewrite to accommodate metric stats (VinDSL)
#                 added fcTemp.Metric.xslt (VinDSL)
#                 added fcTemp.Imperial.xslt (VinDSL)  
#                 added conditionsTempBig.Metric.xslt (VinDSL)
#                 added conditionsTempBig.Imperial.xslt (VinDSL)  
# @version: 1.1   code cleanup/added icon (VinDSL) 
# @version: 1.0   added fcTempToday.xslt (VinDSL)
# @version: 0.9   added currentConditionBig.xslt (VinDSL) 
# @version: 0.8   bug fix (VinDSL) 
# @version: 0.7   code cleanup (VinDSL) 
# @version: 0.6   added currentTempBig (VinDSL) 
# @version: 0.5   added comments (VinDSL) 
# @version: 0.4   code cleanup (VinDSL)
# @version: 0.3   initial hack (VinDSL)
# @version: 0.2   optimized 
# @version: 0.1   basic script
#
#######################################################
# .conkyrc format:
# ${execi 1800 /path/to/weather/weather.sh "location" option } Note: do not use ~/weather/weather.sh shortcut
#
# .conkyrc examples:
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" }     - prints current conditions
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" ccb}  - prints current condition (big format)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" ccti} - prints today's high/low temps (imperial)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" cctm} - prints today's high/low temps (metric)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" cp}   - prints symbol for current condition
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" ctbi} - prints current temp (big format - imperial)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" ctbm} - prints current temp (big format - metric)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" dl}   - prints list of days for forecast
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" fcp}  - prints symbols for forecast conditions
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" fcti} - prints forecast high/low temps (imperial)
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" fctm} - prints forecast high/low temps (metric)
#
# NOTE:  ++ Be sure to comment/uncomment the necessary CURLURL string
#           for Imperial or Metric weather stats (as noted below).
#
#        ++ Always delete your old weatherInfo.xml cache file, when
#           changing between Imperial and Metric weather stats.
#
#######################################################
####
##
# Don't get xml file if created within 30 minutes
UPDATE=1800

# Local cURL location (cURL required)
CURLCMD="/usr/bin/curl -s"

# Local xsltcmd location (xsltproc required)
XSLTCMD=/usr/bin/xsltproc

# Where this script and the XSLT lives
RUNDIR=`dirname $0`

# Where the weatherInfo.xml file lives
conditions_xml="${RUNDIR}/weatherConditions.xml"
forecast_xml="${RUNDIR}/weatherForecast.xml"
tenday_xml="${RUNDIR}/weatherForecastTenDay.xml"

wunderground_key="your key here"

# Location ID string
# Parsed from .conkyrc
LOCID=$1

# Conditions string
# Parsed from weatherInfo.xml
CONDITIONS=$2

# cURL the Google Weather API (Imperial - Fahrenheit)
CONDITIONS_CURL_URL="http://api.wunderground.com/api/${wunderground_key}/conditions/q/${LOCID}.xml"
FORECAST_CURL_URL="http://api.wunderground.com/api/${wunderground_key}/forecast/q/${LOCID}.xml"
TENDAY_FORECAST_CURL_URL="http://api.wunderground.com/api/${wunderground_key}/forecast10day/q/${LOCID}.xml"

# cURL the Google Weather API (Metric - Celsius)
# CONDITIONS_CURL_URL="http://www.google.com/ig/api?weather=${LOCID}&hl=en-gb"

# The XSLT to use when translating the response
if [ "$CONDITIONS" = "ccb" ];
then
    XSLT=$RUNDIR/currentConditionBig.xslt
    XML=$conditions_xml
elif [ "$CONDITIONS" = "ctbi" ];
then
    XSLT=$RUNDIR/currentTempBig.Imperial.xslt
    XML=$conditions_xml    
elif [ "$CONDITIONS" = "ctbm" ];
then
    XSLT=$RUNDIR/currentTempBig.Metric.xslt
    XML=$conditions_xml
elif [ "$CONDITIONS" = "cp" ];
then
    XSLT=$RUNDIR/conditions.xslt
    XML=$conditions_xml
elif [ "$CONDITIONS" = "dl" ];
then
    XSLT=$RUNDIR/fcDayList.xslt
    XML=$tenday_xml
elif [ "$CONDITIONS" = "fcp" ];
then
    XSLT=$RUNDIR/fcConditions.xslt
    XML=$tenday_xml
elif [ "$CONDITIONS" = "ctti" ];
then
    XSLT=$RUNDIR/fcTempToday.Imperial.xslt
    XML=$forecast_xml    
elif [ "$CONDITIONS" = "cttm" ];
then
    XSLT=$RUNDIR/fcTempToday.Metric.xslt
    XML=$conditions_xml    
elif [ "$CONDITIONS" = "fcti" ];
then
    XSLT=$RUNDIR/fcTemp.Imperial.xslt
    XML=$tenday_xml
elif [ "$CONDITIONS" = "fctm" ];
then
    XSLT=$RUNDIR/fcTemp.Metric.xslt
    XML=$tenday_xml
else
    XSLT=$RUNDIR/weather.xslt
    XML=$conditions_xml    
fi

################################################################
# You probably don't need to modify anything below this point. #
################################################################
####
##  Optimization. 
#   We cache the xml in a file and don't get the file
#   from internet if it is less than 30 minutes old

function get_file () 
{
    # echo "get file called"
    # check if the file exists
    if [ -e $conditions_xml ];
    then
        size=`stat -c %s $conditions_xml`
        if [ $size -ge  1000 ];
        then
            now=`date -u +%s`
            created=`stat -c %Y $conditions_xml`
            age=`expr $now - $created`
        else
            age=`expr $UPDATE + 1`
        fi
    else
        # if the file doesn't exist create it
        # and set the age older than update time
        touch $conditions_xml
        age=`expr $UPDATE + 1`
    fi
    # echo $age
    # get the file if it is older than update time
    if [ $age -ge $UPDATE ];
    then
        $CURLCMD -o $conditions_xml "$CONDITIONS_CURL_URL"
        $CURLCMD -o $forecast_xml "$FORECAST_CURL_URL"
        $CURLCMD -o $tenday_xml "$TENDAY_FORECAST_CURL_URL"
        
    fi
    # echo "get file ended"
}

get_file
eval "$XSLTCMD $XSLT $XML"
