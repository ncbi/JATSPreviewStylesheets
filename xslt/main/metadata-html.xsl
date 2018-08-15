<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xi="https://www.w3.org/TR/xinclude/"
  xmlns:nlm="http://schema.highwire.org/NLM/Journal"
  xmlns:a="http://www.w3.org/2005/Atom"
  xmlns:c="http://schema.highwire.org/Compound"
  exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>
 
  <xsl:param name="atom-id" select="false()"/>
  <xsl:param name="atom" select="document(resolve-uri($atom-id,base-uri(.)))"/>
  <xsl:param name="released" select="false()"/>
  <xsl:param name="category" select="false()"/>
  <xsl:param name="atom-sequence" select="tokenize($atom-id, '/')"/>
  <xsl:param name="book-id">
    <xsl:choose>
      <xsl:when test="matches($atom-sequence[4],'.atom')">
        <xsl:value-of select="substring-before($atom-sequence[4],'.atom')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$atom-sequence[4]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="book-atom" select="if ($category eq 'reference-book') then document(resolve-uri(concat('/sgrworks/reference-book/',$book-id,'.atom'),base-uri(.)))
  	     		      	      else document(resolve-uri(concat('/sgrworks/book/',$book-id,'.atom'),base-uri(.)))"/>
  <xsl:param name="cover-source" select="if ($category eq 'reference-book') then document(resolve-uri(concat('/sgrworks/reference-book/',$book-id,'/cover/supplementary-material1.source.xml'),base-uri(.)))
  	     			 	 else document(resolve-uri(concat('/sgrworks/book/',$book-id,'/cover/supplementary-material1.source.xml'),base-uri(.)))"/>

  <xsl:template match="/">
    <html>
      <!-- hw metadata -->
      <meta name="HW.identifier" content="{$atom-id}"/>
      <meta name="citation_publication_date" content="{$released}"/>
      <!-- <meta name="citation_access" content=""/> -->
      <!-- <meta name="citation_fulltext_world_readable" content=""/> -->
      <xsl:apply-templates select="$book-atom//nlm:publisher/nlm:publisher-name" mode="hw"/>
      <xsl:apply-templates select="$book-atom//nlm:pub-id[@pub-id-type eq 'isbn']" mode="hw"/>
      <xsl:apply-templates select="(//book-title-group,//title-group)[1]" mode="hw"/>
      <xsl:apply-templates select="//contrib/name" mode="hw"/>
      <xsl:apply-templates select="//abstract" mode="hw"/>
      <!-- dublin core metadata -->
      <meta name="DC.Created" content="{$released}"/>
      <meta name="DC.Format" content="text/html"/>
      <meta name="DC.Type" content="text"/>
      <xsl:apply-templates select="(//book-title-group,//title-group)[1]" mode="dc"/>
      <xsl:apply-templates select="//abstract" mode="dc"/>
      <xsl:apply-templates select="$book-atom//nlm:publisher/nlm:publisher-name" mode="dc"/>
      <!-- open graph metadata -->
      <xsl:apply-templates select="(//book-title-group,//title-group)[1]" mode="og"/>		 <!-- og:title -->
      <meta property="og:type" content="book"/>       		       		   		 <!-- og:type  -->
      <xsl:apply-templates select="$book-atom//nlm:pub-id[@pub-id-type eq 'isbn']" mode="og"/> 	 <!--    book:isbn -->
      <meta property="book:release_date" content="{$released}"/>       	  	   		 <!--    book:release_date -->
      <xsl:call-template name="og_image"/>							 <!-- og:image -->
      <xsl:call-template name="og_url"/>							 <!-- og:url -->
      <xsl:apply-templates select="//abstract" mode="og"/>					 <!-- og:description -->
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
    <meta property="book:isbn" content="{$isbn}"/>
  </xsl:template>

  <xsl:template match="book-title-group" mode="hw">
    <xsl:variable name="title" select="book-title"/>
    <meta name="citation_title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="title-group" mode="hw">
    <xsl:variable name="title" select="title"/>
    <meta name="citation_title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="book-title-group" mode="dc">
    <xsl:variable name="title" select="book-title"/>
    <meta name="DC.Title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="title-group" mode="dc">
    <xsl:variable name="title" select="title"/>
    <meta name="DC.Title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="book-title-group" mode="og">
    <xsl:variable name="title" select="book-title"/>
    <meta property="og:title" content="{$title}"/>
  </xsl:template>

  <xsl:template match="title-group" mode="og">
    <xsl:variable name="title" select="title"/>
    <meta property="og:title" content="{$title}"/>
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

  <xsl:template match="abstract" mode="og">
    <xsl:variable name="abstract" select="."/>
    <meta property="og:description" content="{$abstract}"/>
  </xsl:template>

  <xsl:template name="og_image">
    <!-- /sites/default/files/styles/cover_content_metadata/binary/sgrworks/0539b1496b12d864/99d2856a6f3fd74405c110115cc8ca7ecae287a90e73f80273334521b0183a4e/cover.jpg -->
    <meta property="og:image">
      <xsl:attribute name="content">
        <xsl:text>/sites/default/files/styles/cover_content_metadata/binary/</xsl:text>
	<xsl:value-of select="substring-after($cover-source/supplementary-material/@xlink:href,'binary://')"/>
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template name="og_url">
    <xsl:variable name="url" select="concat('/content/',substring-before(replace($atom-id,'^/\w+/',''),'.atom'))"/>
    <meta property="og:url" content="{$url}"/>
  </xsl:template>

</xsl:stylesheet>
