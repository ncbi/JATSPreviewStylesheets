<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:c="http://schema.highwire.org/Compound"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="#all">
  
  <xsl:output method="xhtml" omit-xml-declaration="yes"
    encoding="utf-8" indent="no"
    include-content-type="no"/>

  <xsl:param name="runtime-params">
    <base-dir>
      <xsl:value-of
        select="replace(base-uri(/), '/[^/]+$','')"/>     
    </base-dir>
  </xsl:param>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="atom:entry">
        <xsl:variable name="source" as="document-node()" select="doc(resolve-uri(atom:entry/atom:link[@rel eq 'alternate'][@c:role eq 'http://schema.highwire.org/variant/source'][@type eq 'application/xml']/@href,base-uri(.)))"/>
        <xsl:variable name="html-output" as="document-node()"
          select="
          saxon:transform(
          saxon:compile-stylesheet(doc('../../xslt/main/contribgroup-html.xsl')),
          $source,
          $runtime-params/* )"/>
        <xsl:sequence select="$html-output"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
