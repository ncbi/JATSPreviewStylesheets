<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <xsl:import href="jats-html.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:if test="//fig | //table-wrap">
      <div class="floats">
        <xsl:apply-templates select="//fig"/>
	<xsl:apply-templates select="//table-wrap"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="fig">
    <div class="fig">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="table-wrap">
    <div class="table">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
