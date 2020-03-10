<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <xsl:import href="jats-html.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="book">
        <xsl:apply-templates select="(//contrib-group[parent::book-meta])[1]" mode="contrib-group"/>
      </xsl:when>
      <xsl:when test="book-part">
        <xsl:apply-templates select="(//contrib-group[parent::book-part-meta])[1]" mode="contrib-group"/>
      </xsl:when>
      <xsl:when test="article">
        <xsl:apply-templates select="(//contrib-group[parent::article-meta])[1]" mode="contrib-group"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
