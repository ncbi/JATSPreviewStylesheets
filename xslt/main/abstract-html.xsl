<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <xsl:import href="jats-html.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//abstract"/>
  </xsl:template>

  <xsl:template match="abstract">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
