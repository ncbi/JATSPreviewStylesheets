<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xi="https://www.w3.org/TR/xinclude/"
  xmlns:ali="http://www.niso.org/schemas/ali/1.0/"
  exclude-result-prefixes="xlink mml xi ali">

  <xsl:import href="jats-ASCE7-html.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="book">
        <div class="book">
          <xsl:apply-templates select="//front-matter"/>
          <xsl:if test="//book-meta/book-id[@book-id-type eq 'publisher-id'] eq 'bps'">
            <xsl:apply-templates select="//body"/>
          </xsl:if>
          <xsl:apply-templates select="//book-back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'part']">
        <div class="part">
          <xsl:apply-templates select="book-part/book-part-meta/permissions/ali:free_to_read" mode="free_to_read"/>
        <xsl:apply-templates select="//body[not(child::*[self::xi:include])][parent::book-part[@book-part-type eq 'part']]"/>
        <!-- <xsl:apply-templates select="//book-part[@book-part-type eq 'chapter']"/> -->
      </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'section']">
        <div class="section">
          <xsl:apply-templates select="book-part/book-part-meta/permissions/ali:free_to_read" mode="free_to_read"/>
          <xsl:apply-templates select="//body[not(child::*[self::xi:include])][parent::book-part[@book-part-type eq 'section']]"/>
        </div>
      </xsl:when>
      <!-- <xsl:when test="book-part[@book-part-type eq 'chapter']"> -->
      <xsl:when test="book-part[matches(@book-part-type, '^[Cc]hapter$')]">
        <div class="chapter">
          <xsl:apply-templates select="book-part/book-part-meta/permissions/ali:free_to_read" mode="free_to_read"/>
          <xsl:apply-templates select="book-part/body"/>
          <xsl:apply-templates select="book-part/back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[matches(@book-part-type,'^case[\s-]study$')]">
        <div class="case-study">
          <xsl:apply-templates select="book-part/body"/>
          <xsl:apply-templates select="book-part/back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'introduction']">
        <div class="introduction">
          <xsl:apply-templates select="book-part/body"/>
          <xsl:apply-templates select="book-part/back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'conclusion']">
        <div class="conclusion">
          <xsl:apply-templates select="book-part/body"/>
          <xsl:apply-templates select="book-part/back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@book-part-type eq 'reference']">
        <div class="reference-topic">
          <xsl:apply-templates select="book-part/body"/>
          <xsl:apply-templates select="book-part/back"/>
        </div>
      </xsl:when>
      <xsl:when test="book-part[@specific-use eq 'published-online']">
        <div class="back-matter">
          <xsl:apply-templates select="book-part/body"/>
        </div>
      </xsl:when>
      <xsl:when test="article">
        <div class="article">
          <xsl:apply-templates select="article/body"/>
          <xsl:apply-templates select="article/back"/>
        </div>
      </xsl:when>
      <xsl:when test="ack | dedication | preface | appendix | foreword | book-app | glossary | ref-list | foreword | front-matter-part"> 
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="contains(base-uri(.),'/bpsworks/') and book-part[@id and @book-part-type]">
        <div class="{book-part/@book-part-type}">
          <div id="{concat('print_',@id)}">
          <xsl:apply-templates/>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="sec[count(ancestor::sec) &lt; 4]">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="/fig|/table-wrap">
        <xsl:apply-templates/>
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
