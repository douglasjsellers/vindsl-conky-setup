<!-- currentConditionBig.xslt

This XSLT is used to translate an XML response from the www.google.com/ig/ XML API.

This style sheet shows the CURRENT WEATHER TEMPERATURE (big format) in the Conky Weather Section, e.g.

++ Determines the current weather condition, for use in the Conky Weather header

NOTE:   ++ You probably won't need to modify anything in this style sheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" > 
  <xsl:output method="text" disable-output-escaping="yes"/>
  <xsl:template match="response">
    <xsl:apply-templates select="current_observation"/>
  </xsl:template>
  
  <xsl:template match="current_observation">
    <xsl:value-of select="weather" /><!-- Fetches current conditions from Google API -->
  </xsl:template>
</xsl:stylesheet>
