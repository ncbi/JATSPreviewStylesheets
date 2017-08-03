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
        <div class="book">
	  <xsl:apply-templates select="//front-matter"/>
	  <xsl:apply-templates select="//book-back"/>
	</div>
      </xsl:when>
      <xsl:when test="book-part">
        <div>
	  <xsl:attribute name="class" select="book-part/@book-part-type"/>
	  <xsl:apply-templates select="//body"/>
	  <xsl:apply-templates select="//back"/>
	</div>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="front-matter">
    <div class="front-matter">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="book-back">
    <div class="book-back">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="back">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
