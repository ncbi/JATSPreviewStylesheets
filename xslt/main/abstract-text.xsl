<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <!-- <xsl:import href="jats-html.xsl"/> -->

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="book-part[@book-part-type eq 'part']">
        <xsl:apply-templates select="//abstract"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//abstract[not(ancestor::book-back)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="abstract">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
