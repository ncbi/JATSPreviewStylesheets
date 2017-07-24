<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xlink mml">

  <xsl:import href="jats-html.xsl"/>

  <!-- <xsl:output doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    encoding="UTF-8"/> -->

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <xsl:call-template name="make-html-header"/>
      <body>
        <xsl:apply-templates select="//abstract"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="abstract">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
