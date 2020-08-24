<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:atom="http://www.w3.org/2005/Atom"
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
  <xsl:param name="book-atom"
    select="
      if (matches($atom-id,'reference-book'))
      then document(resolve-uri(concat('/sgrworks/reference-book/',$book-id,'.atom'),base-uri(.)))
      else document(resolve-uri(concat('/sgrworks/book/',$book-id,'.atom'),base-uri(.)))"/>
  <xsl:param name="cover-source"
    select="
      if (matches($atom-id,'reference-book'))
      then document(resolve-uri(concat('/sgrworks/reference-book/',$book-id,'/cover/supplementary-material1.source.xml'),base-uri(.)))
      else document(resolve-uri(concat('/sgrworks/book/',$book-id,'/cover/supplementary-material1.source.xml'),base-uri(.)))"/>
  
  <xsl:variable name="source" as="document-node()"
    select="
      doc(resolve-uri(
        $atom/atom:link[@rel eq 'alternate'][@c:role eq 'http://schema.highwire.org/variant/source'][@type eq 'application/xml']/@href,
        base-uri(.)))"/>

  <xsl:variable name="item-type" select="$atom//atom:category[@scheme eq 'http://schema.highwire.org/ItemSet/Item#type']/@term"/>
  
  <xsl:variable name="meta.relative-url" select="concat('content/',substring-before(string-join(tokenize($atom-id,'/')[position() gt 2],'/'),'.atom'))"/>
  
  <xsl:variable name="meta.pdf-url">
    <xsl:variable name="binary" select="$source//self-uri[@content-type eq 'pdf']/@xlink:href"/>
    <xsl:if test="exists($binary)">
      <!-- e.g. https://www.accessengineeringlibrary.com/binary/mheaeworks/918dbc7489b2baca/12ca065444373e29d186ce724965986e735fb80815bff198f8352f9180a69e68/book-summary.pdf -->
      <xsl:sequence select="replace($binary,'binary:/','binary')"/>
    </xsl:if>
  </xsl:variable>
  
  <xsl:variable name="meta.full-url">
    <!-- See https://jira.highwire.org/browse/PLATFORM1-2236 for $item-type mapping -->
    <xsl:if test="$item-type = ('book','chapter','clinical-guideline','part','patient-education','prescribing-guideline','quick-reference','reference-book','section','toc-section')">
      <xsl:sequence select="concat($meta.relative-url,'.full')"/>
    </xsl:if>
  </xsl:variable>
  
  <xsl:variable name="meta.abstract-url">
    <xsl:if test="$source//abstract">
      <xsl:sequence select="concat($meta.relative-url,'.abstract')"/>
    </xsl:if>
  </xsl:variable>

  <xsl:template match="/">
    <html>
      <!-- hw metadata -->
      <meta name="HW.identifier" content="{$atom-id}"/>
      <meta name="citation_publication_date" content="{$released}"/>
      <!-- <meta name="citation_access" content=""/> -->
      <!-- <meta name="citation_fulltext_world_readable" content=""/> -->
      <meta name="citation_public_url" content="{$meta.relative-url}"/>
      <xsl:if test="not($meta.full-url = '')">
        <meta name="citation_full_html_url" content="{$meta.full-url}"/>
      </xsl:if>
      <xsl:if test="not($meta.abstract-url = '')">
        <meta name="citation_abstract_html_url" content="{$meta.abstract-url}"/>
      </xsl:if>
      <xsl:if test="not($meta.pdf-url = '')">
        <meta name="citation_pdf_url" content="{$meta.pdf-url}"/>
      </xsl:if>
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
    <!-- WRONG: /sites/default/files/styles/cover_content_metadata/binary/sgrworks/0539b1496b12d864/99d2856a6f3fd74405c110115cc8ca7ecae287a90e73f80273334521b0183a4e/cover.jpg -->
    <!-- should be: http://connect.springerpub.com/binary/sgrworks/bad9880d2672e836/48dd71541a89768a73de708419493ab4c5ab35afa409c9511795c3cb3625ce1e/cover.jpg -->
    <meta property="og:image">
      <xsl:attribute name="content">
        <!-- <xsl:text>/sites/default/files/styles/cover_content_metadata/binary/</xsl:text> -->
	<xsl:text>binary/</xsl:text>
	<xsl:value-of select="substring-after($cover-source/supplementary-material/@xlink:href,'binary://')"/>
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template name="og_url">
    <xsl:variable name="url" select="concat('content/',substring-before(replace($atom-id,'^/\w+/',''),'.atom'))"/>
    <meta property="og:url" content="{$url}"/>
  </xsl:template>
  
  

</xsl:stylesheet>
