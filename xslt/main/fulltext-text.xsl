<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xi="https://www.w3.org/TR/xinclude/"
  exclude-result-prefixes="xlink mml xi">

  <!-- <xsl:import href="jats-html.xsl"/> -->

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="book">
	<xsl:apply-templates select="//front-matter"/>
	<xsl:apply-templates select="//book-back"/>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'part']">
	<xsl:apply-templates select="//body[not(child::*[self::xi:include])][parent::book-part[@book-part-type eq 'part']]"/>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'chapter']">
        <xsl:apply-templates select="//body"/>
        <xsl:apply-templates select="//back"/>
      </xsl:when>
      <xsl:otherwise/> <!-- @book-part-type=section -->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="book-part[@book-part-type eq 'chapter']">
    <xsl:apply-templates select="body"/>
    <xsl:apply-templates select="back"/>
  </xsl:template>

  <xsl:template match="front-matter">
    <xsl:apply-templates select="* except toc"/>
  </xsl:template>

  <xsl:template match="book-back">
    <xsl:apply-templates select="* except (book-part-meta,ref-list,index)"/>
  </xsl:template>

  <xsl:template match="sec[ref-list]"/>

  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="back">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
    <xsl:if test="not(matches(following-sibling::text(),'[\.?:;!-,]'))">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
