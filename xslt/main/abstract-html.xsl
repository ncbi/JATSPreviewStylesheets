<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <xsl:import href="jats-html.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="book-part[@book-part-type eq 'part'][chapter]">
        <div class="part">
	  <xsl:apply-templates select="//abstract"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'chapter']">
        <xsl:apply-templates select="//abstract[parent::book-part-meta][1]"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:apply-templates select="//abstract[not(ancestor::book-back)]"/> -->
        <xsl:apply-templates select="/descendant::abstract[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="abstract">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
