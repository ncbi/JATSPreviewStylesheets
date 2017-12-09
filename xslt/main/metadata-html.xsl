<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xi="https://www.w3.org/TR/xinclude/"
  xmlns:nlm="http://schema.highwire.org/NLM/Journal"
  exclude-result-prefixes="xlink mml xi nlm">

  <xsl:output encoding="UTF-8"/>
 
  <xsl:param name="atom-id" select="false()"/>
  <xsl:param name="released" select="false()"/>
  <xsl:param name="atom-sequence" select="tokenize($atom-id, '/')"/>
  <xsl:param name="book-id" select="$atom-sequence[4]"/>
  <xsl:param name="book-atom" select="document(concat('http://sass.highwire.org/sgrworks/book/',$book-id,'.atom'))"/>

  <xsl:template match="/">
    <html>
      <!-- hw metadata -->
      <meta name="HW.identifier" content="{$atom-id}"/>
      <meta name="citation_publication_date" content="{$released}"/>
      <meta name="citation_access" content=""/>
      <meta name="citation_fulltext_world_readable" content=""/>
      <xsl:apply-templates select="$book-atom//nlm:publisher/nlm:publisher-name" mode="hw"/>
      <xsl:apply-templates select="$book-atom//nlm:pub-id[@pub-id-type eq 'isbn']" mode="hw"/>
      <xsl:apply-templates select="//title-group" mode="hw"/>
      <xsl:apply-templates select="//contrib/name" mode="hw"/>
      <xsl:apply-templates select="//abstract" mode="hw"/>
      <!-- dublin core metadata -->
      <meta name="DC.Created" content=""/>
      <meta name="DC.Format" content="text/html"/>
      <meta name="DC.Type" content=""/>
      <xsl:apply-templates select="//abstract" mode="dc"/>
      <xsl:apply-templates select="$book-atom//nlm:publisher/nlm:publisher-name" mode="dc"/>
      <!-- open graph metadata -->
      <xsl:apply-templates select="$book-atom//nlm:pub-id[@pub-id-type eq 'isbn']" mode="og"/>
      <meta name="book:release_date" content="{$released}"/>
    </html>
  </xsl:template>

  <xsl:template match="nlm:publisher-name" mode="hw">
    <xsl:variable name="publisher-name" select="."/>
    <meta name="citation_publisher" content="{$publisher-name}"/>
  </xsl:template>

  <xsl:template match="nlm:publisher-name" mode="dc">
    <xsl:variable name="publisher-name" select="."/>
    <meta name="DC.Publisher" content="{$publisher-name}"/>
  </xsl:template>

  <xsl:template match="nlm:pub-id[@pub-id-type eq 'isbn']" mode="hw">
    <xsl:variable name="isbn" select="."/>
    <meta name="citation_isbn" content="{$isbn}"/>
  </xsl:template>

  <xsl:template match="nlm:pub-id[@pub-id-type eq 'isbn']" mode="og">
    <xsl:variable name="isbn" select="."/>
    <meta name="book:isbn" content="{$isbn}"/>
  </xsl:template>

  <xsl:template match="title-group" mode="hw">
    <xsl:variable name="title" select="title"/>
    <meta name="citation_title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="title-group" mode="dc">
    <xsl:variable name="title" select="title"/>
    <meta name="DC.Title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="name" mode="hw">
    <xsl:variable name="surname" select="surname"/>
    <xsl:variable name="given-names" select="given-names"/>
    <meta name="citation_author" content="{$given-names} {$surname}"/>
  </xsl:template>

  <xsl:template match="abstract" mode="hw">
    <meta name="citation_abstract">
      <xsl:attribute name="content"><xsl:apply-templates mode="hw.abstract"/></xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template match="*" mode="hw.abstract">
    <xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="hw.abstract"/>
    <xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="abstract" mode="dc">
    <xsl:variable name="abstract" select="."/>
    <meta name="DC.Description" content="{$abstract}"/>
  </xsl:template>

</xsl:stylesheet>
