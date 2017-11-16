<!-- conditions.xslt

This XSLT is used to translate an XML response from the www.google.com/ig/ XML API.

This style sheet fetches data for the CURRENT WEATHER CONDITION ICON in the Conky Weather Section, e.g.

++ Works in conjunction with the conditionsInclude.xslt file

NOTE:   ++ You probably won't need to modify anything in this style sheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
  <xsl:include href="conditionsInclude.xslt"/>
  <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
  <xsl:template match="response">
    <xsl:apply-templates select="current_observation"/>
  </xsl:template>

  <xsl:template match="current_observation">
    <xsl:call-template name="get-condition-symbol">
      <xsl:with-param name="condition">
        <xsl:value-of select="weather"/><!-- Fetches current conditions from Google API -->
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
