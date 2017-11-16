<!-- fcTemp.Imperial.xslt

This XSLT is used to translate an XML response from the www.google.com/ig/ XML API.

This style sheet shows all HIGH/LOW FORECAST IMPERIAL TEMPS in the Conky Weather Section, e.g.
the high/low imperial temperatures that are listed at the bottom of the 3-day forecast.

The first line (forecast day list) in the 3-day forecast is handled by: fcDayList.xslt

The second line (condition icons) in the 3-day forecast is handled by: fcConditions.xslt

Adjust the number of empty spaces (as noted below) to align the horizontal spacing of the
high/low forecast imperial temperatures on your desktop.  This works in conjunction with the
font size that you chose to use in your .conkyrc file, and will require some patience to setup.  :)

This is a base adjustment.  Once you get the horizontal alignment into the ballpark, the rest
of the spacing & alignment will be handled, as usual, by making adjustments to the Weather Section
in your .conkyrc file.

NOTE:   ++ Enable the following line, in the weather.sh file, for Imperial Stats:

# cURL the Google Weather API (Imperial - Fahrenheit)
CURLURL="http://www.google.com/ig/api?weather=${LOCID}&hl=en"
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
  <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
  <xsl:template match="response">
    <xsl:apply-templates select="forecast"/>
  </xsl:template>

  <xsl:template match="forecast">
    <xsl:variable name="fahrenheit"><xsl:text>º</xsl:text></xsl:variable>    
    <xsl:for-each select="simpleforecast/forecastdays/forecastday"><!-- Fetches all available Forecasts -->
      <xsl:choose>
        <xsl:when test="position() = 2"><!-- Choose Forecasts for the next three days only -->
          <xsl:value-of select="high/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="low/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
        </xsl:when>
        <xsl:when test="position() = 3"><!-- Choose Forecasts for the next three days only -->
          <xsl:text>        </xsl:text><!-- 8 spaces. Add/subtract spaces for proper Forecast Day alignment -->                                   
          <xsl:value-of select="high/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="low/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
        </xsl:when>
        <xsl:when test="position() = 4"><!-- Choose Forecasts for the next three days only -->
          <xsl:text>      </xsl:text><!-- 8 spaces. Add/subtract spaces for proper Forecast Day alignment -->                                   
          <xsl:value-of select="high/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="low/fahrenheit"/> <xsl:value-of select="$fahrenheit"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
