<?xml version="1.0"?>
<!-- ============================================================= -->
<!--  MODULE:    HTML Preview of NISO JATS Publishing 1.0 XML      -->
<!--  DATE:      May-June 2012                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--  SYSTEM:    NCBI Archiving and Interchange Journal Articles   -->
<!--                                                               -->
<!--  PURPOSE:   Provide an HTML preview of a journal article,     -->
<!--             in a form suitable for reading.                   -->
<!--                                                               -->
<!--  PROCESSOR DEPENDENCIES:                                      -->
<!--             None: standard XSLT 1.0                           -->
<!--             Tested using Saxon 6.5, Tranformiix (Firefox),    -->
<!--               Saxon 9.4.0.3                                   -->
<!--                                                               -->
<!--  COMPONENTS REQUIRED:                                         -->
<!--             1) This stylesheet                                -->
<!--             2) CSS styles defined in jats-preview.css         -->
<!--                (to be placed with the results)                -->
<!--                                                               -->
<!--  INPUT:     An XML document valid to (any of) the             -->
<!--             NISO JATS 1.0, NLM/NCBI Journal Publishing 3.0,   -->
<!--             or NLM/NCBI Journal Publishing 2.3 DTDs.          -->
<!--             (May also work with older variants,               -->
<!--             and note further assumptions and limitations      -->
<!--             below.)                                           -->
<!--                                                               -->
<!--  OUTPUT:    HTML (XHTML if a postprocessor is used)           -->
<!--                                                               -->
<!--  CREATED FOR:                                                 -->
<!--             Digital Archive of Journal Articles               -->
<!--             National Center for Biotechnology Information (NCBI)     -->
<!--             National Library of Medicine (NLM)                -->
<!--                                                               -->
<!--  CREATED BY:                                                  -->
<!--             Wendell Piez (based on HTML design by             -->
<!--             Kate Hamilton and Debbie Lapeyre, 2004),          -->
<!--             Mulberry Technologies, Inc.                       -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- 
  This work is in the public domain and may be reproduced, published or 
  otherwise used without the permission of the National Library of Medicine (NLM).
  
  We request only that the NLM is cited as the source of the work.
  
  Although all reasonable efforts have been taken to ensure the accuracy and 
  reliability of the software and data, the NLM and the U.S. Government  do 
  not and cannot warrant the performance or results that may be obtained  by
  using this software or data. The NLM and the U.S. Government disclaim all 
  warranties, express or implied, including warranties of performance, 
  merchantability or fitness for any particular purpose.
-->
<!-- ============================================================= -->

<!-- Change history                                                -->

<!-- From jpub3-html.xsl v3.0 to jats-html.xsl v1.0:
  
Calls to 'normalize-space($node)' where $node is not a string are
expressed as 'normalize-space(string($node)) in order to provide
type safety in some XSLT 2.0 processors.

Support for certain elements in NLM Blue v2.3 is added to provide
backward compatibility:
  floats-wrap (same as floats-group)
  chem-struct-wrapper (same as chem-struct-wrap)
  custom-meta-wrap (same as custom-meta-group)
  floats-wrap (same as floats-group)
  gloss-group (same as glossary)
  citation
  contract-num
  contract-sponsor
  grant-num
  grant-sponsor

Support is added for looser structures for title-group elements
in 2.3 (title, trans-title, trans-subtitle etc.) Same for 2.3
tagging of permissions info (copyright-statement, copyright-year,
license) and funding/contract info (contract-num, contract-sponsor,
grant-num, grant-sponsor).

Elements newly permitted in JATS journal-meta
(contrib-group, aff, aff-alternatives) are supported.

New elements in NISO JATS v1.0 are supported:
  aff-alternatives
  citation-alternatives
  collab-alternatives
  trans-title-group (with @xml:lang)
  contrib-id
  count>
  issn-l
  nested-kwd

Added support for @pub-id-type='arXiv'

Named anchor logic extended to support "alternatives" wrappers
for aff, contrib, citation etc.

Footer text is emended, with name of transformation (stylesheet
or pipeline) parameterized.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ali="http://www.niso.org/schemas/ali/1.0/"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:hwp="http://schema.highwire.org/Journal" xmlns:l="http://schema.highwire.org/Linking"
  xmlns:atom="http://www.w3.org/2005/Atom" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schema.highwire.org/Compound"
  exclude-result-prefixes="xlink mml xs ali c">


  <!--<xsl:output method="xml" indent="no" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>-->


  <xsl:output doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" encoding="UTF-8"/>

  <xsl:strip-space elements="*"/>

  <!-- Space is preserved in all elements allowing #PCDATA -->
  <xsl:preserve-space
    elements="abbrev abbrev-journal-title access-date addr-line
              aff alt-text alt-title article-id article-title
              attrib award-id bold chapter-title chem-struct
              collab comment compound-kwd-part compound-subject-part
              conf-acronym conf-date conf-loc conf-name conf-num
              conf-sponsor conf-theme contrib-id copyright-holder
              copyright-statement copyright-year corresp country
              date-in-citation day def-head degrees disp-formula
              edition elocation-id email etal ext-link fax fpage
              funding-source funding-statement given-names glyph-data
              gov inline-formula inline-supplementary-material
              institution isbn issn-l issn issue issue-id issue-part
              issue-sponsor issue-title italic journal-id
              journal-subtitle journal-title kwd label license-p
              long-desc lpage meta-name meta-value mixed-citation
              monospace month named-content object-id on-behalf-of
              overline p page-range part-title patent person-group
              phone prefix preformat price principal-award-recipient
              principal-investigator product pub-id publisher-loc
              publisher-name related-article related-object role
              roman sans-serif sc season self-uri series series-text
              series-title sig sig-block size source speaker std
              strike string-name styled-content std-organization
              sub subject subtitle suffix sup supplement surname
              target td term term-head tex-math textual-form th
              time-stamp title trans-source trans-subtitle trans-title
              underline uri verse-line volume volume-id volume-series
              xref year

              mml:annotation mml:ci mml:cn mml:csymbol mml:mi mml:mn 
              mml:mo mml:ms mml:mtext"/>


  <xsl:param name="transform" select="'jats-html.xsl'"/>

  <xsl:param name="css" select="'jats-preview.css'"/>

  <xsl:param name="report-warnings" select="'no'"/>

  <xsl:variable name="verbose" select="$report-warnings = 'yes'"/>
  <xsl:variable name="standardname" select="tokenize(substring-after(base-uri(),'/standard'),'/')[2]"/>
  <xsl:variable name="queryurl" select="doc(concat('http://atom-dev.highwire.org/svc.atom?query-form=search&amp;canned-query=/hwc/list-resources.xqy&amp;type=pattern&amp;pattern=/tmsworks/standard/',$standardname,'*.atom'))"/>
  
  <!-- Keys -->

  <!-- To reduce dependency on a DTD for processing, we declare
       a key to use instead of the id() function. -->
  <xsl:key name="element-by-id" match="*[@id]" use="@id"/>

  <!-- Enabling retrieval of cross-references to objects -->
  <xsl:key name="xref-by-rid" match="xref" use="@rid"/>

  <!-- ============================================================= -->
  <!--  ROOT TEMPLATE - HANDLES HTML FRAMEWORK                       -->
  <!-- ============================================================= -->

  <xsl:template match="/">
    <html>
      <!-- HTML header -->
      <xsl:call-template name="make-html-header"/>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="make-html-header">
    <head>
      <title>
        <xsl:variable name="authors">
          <xsl:call-template name="author-string"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space(string($authors))"/>
        <xsl:if test="normalize-space(string($authors))">: </xsl:if>
        <!-- <xsl:value-of
          select="/article/front/article-meta/title-group/article-title[1]"/> -->
        <xsl:value-of select="/book/book-meta/book-title-group/book-title"/>
        <xsl:if test="/book/book-meta/book-title-group/subtitle">
          <xsl:text>: </xsl:text>
          <xsl:value-of select="/book/book-meta/book-title-group/subtitle"/>
        </xsl:if>
        <xsl:if test="/book-part/book-part-meta/title-group/label">
          <xsl:value-of select="/book-part/book-part-meta/title-group/label"/>
          <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:value-of select="/book-part/book-part-meta/title-group/title[1]"/>
        <xsl:value-of select="/sec/title[1]"/>
      </title>
      <link rel="stylesheet" type="text/css" href="{$css}"/>
      <!-- XXX check: any other header stuff? XXX -->
    </head>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  TOP LEVEL                                                    -->
  <!-- ============================================================= -->

  <!--
      content model for article:
         (front,body?,back?,floats-group?,(sub-article*|response*))
      
      content model for sub-article:
         ((front|front-stub),body?,back?,floats-group?,
          (sub-article*|response*))
      
      content model for response:
         ((front|front-stub),body?,back?,floats-group?) -->

  <xsl:template match="article">
    <xsl:call-template name="make-article"/>
  </xsl:template>

  <xsl:template match="sub-article | response">
    <hr class="part-rule"/>
    <xsl:call-template name="make-article"/>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  "make-article" for the document architecture                 -->
  <!-- ============================================================= -->

  <xsl:template name="make-article">
    <!-- Generates a series of (flattened) divs for contents of any
	       article, sub-article or response -->

    <!-- variable to be used in div id's to keep them unique -->
    <xsl:variable name="this-article">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>

    <div id="{$this-article}-front" class="front">
      <xsl:apply-templates select="front | front-stub"/>
    </div>

    <!-- body -->
    <xsl:for-each select="body">
      <div id="{$this-article}-body" class="body">
        <xsl:apply-templates/>
      </div>
    </xsl:for-each>

    <xsl:if test="back | $loose-footnotes">
      <!-- $loose-footnotes is defined below as any footnotes outside
           front matter or fn-group -->
      <div id="{$this-article}-back" class="back">
        <xsl:call-template name="make-back"/>
      </div>
    </xsl:if>

    <xsl:for-each select="floats-group | floats-wrap">
      <!-- floats-wrap is from 2.3 -->
      <div id="{$this-article}-floats" class="back">
        <xsl:call-template name="main-title">
          <xsl:with-param name="contents">
            <span class="generated">Floating objects</span>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
      </div>
    </xsl:for-each>

    <!-- more metadata goes in the footer -->
    <div id="{$this-article}-footer" class="footer">
      <xsl:call-template name="footer-branding"/>
    </div>

    <!-- sub-article or response (recursively calls
		     this template) -->
    <xsl:apply-templates select="sub-article | response"/>

  </xsl:template>

  <xsl:template match="front | front-stub | book-meta">
    <!-- First Table: journal and article metadata -->
    <!-- HW NOTE: for now we're going to forget all this 'two-column table' stuff.
                  skip down to the contrib-group template for the good stuff. SPRINGRSC3-213. Dax 7/18/17 -->
    <!-- <div class="metadata two-column table">
      <div class="row">
        <!-/- Cell 1: journal information -/->
        <xsl:for-each select="journal-meta">
          <!-/- (journal-id+, journal-title-group*, (contrib-group | aff | aff-alternatives)*,
                issn+, issn-l?, isbn*, publisher?, notes*, self-uri*)         -/->
          <div class="cell">
            <h4 class="generated">
              <xsl:text>Journal Information</xsl:text>
            </h4>
            <div class="metadata-group">
              <xsl:apply-templates select="journal-id | journal-title-group" mode="metadata"/>
              <!-/- the following may appear in 2.3 -/->
              <xsl:apply-templates mode="metadata" select="journal-title | journal-subtitle | trans-title | trans-subtitle | abbrev-journal-title"/>
              <!-/- contrib-group, aff, aff-alternatives, author-notes -/->
              <xsl:apply-templates mode="metadata"
                select="contrib-group"/>
              <xsl:if test="aff | aff-alternatives | author-notes">
                <div class="metadata-group">
                  <xsl:apply-templates mode="metadata"
                    select="aff | aff-alternatives | author-notes"/>
                </div>
              </xsl:if>
              <xsl:apply-templates select="issn | issn-l | isbn | publisher | notes | self-uri" mode="metadata"/>
            </div>
          </div>
        </xsl:for-each>

        <!-/- Cell 2: Article information -/->
        <xsl:for-each select="article-meta | self::front-stub">
          <!-/- content model:
				    (article-id*, article-categories?, title-group,
				     (contrib-group | aff)*, 
             author-notes?, pub-date+, volume?, volume-id*,
             volume-series?, issue?, issue-id*, issue-title*,
             issue-sponsor*, issue-part?, isbn*, supplement?, 
             ((fpage, lpage?, page-range?) | elocation-id)?, 
             (email | ext-link | uri | product | 
              supplementary-material)*, 
             history?, permissions?, self-uri*, related-article*, 
             abstract*, trans-abstract*, 
             kwd-group*, funding-group*, conference*, counts?,
             custom-meta-group?)
            
            These are handled as follows:

            In the "Article Information" header cell:
              article-id
              pub-date
              volume
              volume-id
              volume-series
              issue
              issue-id
              issue-title
              issue-sponsor
              issue-part
              isbn
              supplement
              fpage
              lpage
              page-range
              elocation-id
              email
              ext-link
              uri
              product
              history
              permissions
              self-uri
              related-article
              funding-group
              conference

            In the "Article title" cell:
              title-group
              contrib-group
              aff
              author-notes
              abstract
              trans-abstract

            In the metadata footer
              article-categories
              supplementary-material
              kwd-group
              counts
              custom-meta-group

				  -/->

          <div class="cell">
            <h4 class="generated">
              <xsl:text>Article Information</xsl:text>
            </h4>
            <div class="metadata-group">

              <xsl:apply-templates mode="metadata"
                select="email | ext-link | uri | self-uri"/>

              <xsl:apply-templates mode="metadata" select="product"/>

              <!-/- only in 2.3 -/->
              <xsl:apply-templates mode="metadata" select="copyright-statement |
                copyright-year | license"/>
              
              <xsl:apply-templates mode="metadata" select="permissions"/>
              
              <xsl:apply-templates mode="metadata" select="history/date"/>

              <xsl:apply-templates mode="metadata" select="pub-date"/>

              <xsl:call-template name="volume-info">
                <!-/- handles volume?, volume-id*, volume-series? -/->
              </xsl:call-template>

              <xsl:call-template name="issue-info">
                <!-/- handles issue?, issue-id*, issue-title*,
                     issue-sponsor*, issue-part? -/->
              </xsl:call-template>

              <xsl:call-template name="page-info">
                <!-/- handles (fpage, lpage?, page-range?) -/->
              </xsl:call-template>

              <xsl:apply-templates mode="metadata" select="elocation-id"/>

              <xsl:apply-templates mode="metadata" select="isbn"/>

              <xsl:apply-templates mode="metadata"
                select="supplement | related-article | conference"/>

              <xsl:apply-templates mode="metadata" select="article-id"/>

              <!-/- only in 2.3 -/->
              <xsl:apply-templates mode="metadata" select="contract-num | contract-sponsor |
                grant-num | grant-sponsor"/>
                
              <xsl:apply-templates mode="metadata" select="funding-group/*">
                <!-/- includes (award-group*, funding-statement*,
                     open-access?) -/->
              </xsl:apply-templates>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </div> -->

    <!-- the good stuff -->
    <xsl:apply-templates select="contrib-group[parent::book-meta or parent::article-meta]"/>

    <hr class="part-rule"/>

    <!-- change context to front/article-meta (again) -->
    <xsl:for-each select="article-meta | self::front-stub">
      <div class="metadata centered">
        <xsl:apply-templates mode="metadata" select="title-group"/>
      </div>
      <!-- contrib-group, aff, aff-alternatives, author-notes -->
      <xsl:apply-templates mode="metadata" select="contrib-group"/>
      <!-- back in article-meta or front-stub context -->
      <xsl:if test="aff | aff-alternatives | author-notes">
        <div class="metadata two-column table">
          <div class="row">
            <div class="cell empty"/>
            <div class="cell">
              <div class="metadata-group">
                <xsl:apply-templates mode="metadata" select="aff | aff-alternatives | author-notes"
                />
              </div>
            </div>
          </div>
        </div>
      </xsl:if>

      <!-- abstract(s) -->
      <xsl:if test="abstract | trans-abstract">
        <!-- rule separates title+authors from abstract(s) -->
        <hr class="section-rule"/>

        <xsl:for-each select="abstract | trans-abstract">
          <!-- title in left column, content (paras, secs) in right -->
          <div class="metadata two-column table">
            <div class="row">
              <div class="cell" style="text-align: right">
                <h4 class="callout-title">
                  <xsl:apply-templates select="title/node()"/>
                  <xsl:if test="not(normalize-space(string(title)))">
                    <span class="generated">
                      <xsl:if test="self::trans-abstract">Translated </xsl:if>
                      <xsl:text>Abstract</xsl:text>
                    </span>
                  </xsl:if>
                </h4>
              </div>
              <div class="cell">
                <xsl:apply-templates select="*[not(self::title)]"/>
              </div>
            </div>
          </div>
        </xsl:for-each>
        <!-- end of abstract or trans-abstract -->
      </xsl:if>
      <!-- end of dealing with abstracts -->
    </xsl:for-each>
    <xsl:for-each select="notes">
      <div class="metadata">
        <xsl:apply-templates mode="metadata" select="."/>
      </div>
    </xsl:for-each>
    <hr class="part-rule"/>

    <!-- end of big front-matter pull -->
  </xsl:template>
  
  
  <!-- ====================== FREE_TO_READ ========================= -->
  <xsl:template match="ali:free_to_read" mode="free_to_read">
    <span class="free_to_read">
      <!-- unhandled element: free_to_read -->
    </span>
  </xsl:template>

  <!-- HW addition -->
  <xsl:template
    match="contrib-group[parent::book-meta or parent::book-part-meta or parent::article-meta][contrib[@contrib-type eq 'author']]"
    mode="contrib-group">
    <div class="contrib-group-authors">
      <ul class="contributor-list">
        <xsl:apply-templates select="contrib[@contrib-type eq 'author']" mode="#current"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template
    match="contrib-group[parent::book-meta or parent::article-meta][contrib[@contrib-type eq 'editor']]"
    mode="contrib-group">
    <div class="contrib-group-editors">
      <span class="contributor-list-label">Edited by:</span>
      <ul class="contributor-list">
        <xsl:apply-templates select="contrib[@contrib-type eq 'editor']" mode="contrib-group"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="contrib[matches(@contrib-type, '(author|editor)')]" mode="contrib-group">
    <li class="contrib">
      <xsl:choose>
        <xsl:when test="contrib-id[@contrib-id-type eq 'orcid']">
          <a href="javascript://" class="orcid" role="button" tabindex="0" data-container="body"
            data-toggle="popover" data-placement="right" data-trigger="focus" title=""
            data-html="true">
            <xsl:attribute name="data-content">
              <xsl:apply-templates select="contrib-id" mode="#current"/>
              <xsl:apply-templates select="bio" mode="bio-and-orcid"/>
            </xsl:attribute>
            <xsl:attribute name="data-original-title" select="'Author Bio'"/>
            <xsl:apply-templates select="name, string-name, degrees" mode="#current"/>
          </a>
        </xsl:when>
        <xsl:when test="bio">
          <a href="javascript://" role="button" tabindex="0" data-container="body"
            data-toggle="popover" data-placement="right" data-trigger="focus" title=""
            data-html="true">
            <xsl:attribute name="data-content">
              <xsl:apply-templates select="bio" mode="#current"/>
            </xsl:attribute>
            <xsl:attribute name="data-original-title" select="'Author Bio'"/>
            <!-- <xsl:apply-templates select="* except (bio, x, aff)" mode="#current"/> -->
            <xsl:apply-templates select="name, string-name, degrees" mode="#current"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="address">
              <a href="javascript://" role="button" tabindex="0" data-container="body"
                data-toggle="popover" data-placement="right" data-trigger="focus" title=""
                data-html="true">
                <xsl:attribute name="data-content">
                  <xsl:apply-templates select="address" mode="#current"/>
                </xsl:attribute>
                <xsl:attribute name="data-original-title" select="'Author Bio'"/>
                <xsl:apply-templates select="name, string-name, degrees" mode="#current"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <!-- <xsl:apply-templates select="* except (x, aff)" mode="#current"/> -->
              <xsl:apply-templates select="name, string-name, degrees, collab" mode="#current"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="name" mode="contrib-group">
    <xsl:apply-templates select="* except (x)" mode="#current"/>
  </xsl:template>

  <xsl:template match="surname" mode="contrib-group">
    <xsl:apply-templates select="node() except (x)"/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="given-names" mode="contrib-group">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="degrees" mode="contrib-group">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates mode="current"/>
  </xsl:template>

  <xsl:template match="contrib-id" mode="contrib-group"><![CDATA[<div><a href="]]><xsl:value-of
      select="."/><![CDATA[" class="orcid" target="_blank">]]><xsl:apply-templates
      select="../name, ../degrees" mode="#current"/><![CDATA[</a></div>]]></xsl:template>

  <xsl:template match="bio" mode="contrib-group">
    <xsl:apply-templates mode="bio"/>
  </xsl:template>

  <xsl:template match="bio" mode="bio-and-orcid"><![CDATA[ <div>]]><xsl:apply-templates mode="bio"
    /><![CDATA[</div>]]></xsl:template>

  <xsl:template match="p" mode="bio">
    <xsl:apply-templates mode="bio"/>
  </xsl:template>

  <xsl:template match="fig" mode="bio"/>

  <xsl:template match="bold" mode="bio">
    <xsl:text>&lt;strong&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/strong&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="abstract" mode="abstract">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="kwd-group[parent::book-meta]">
    <div>
      <xsl:attribute name="class" separator=" "
        select="
          'kwd-group',
          if (@kwd-group-type) then
            @kwd-group-type
          else
            ()"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="kwd">
    <span class="kwd">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="contrib">
    <div class="contrib">
      <xsl:if test="name | degrees">
        <p>
          <xsl:apply-templates select="name, degrees"/>
        </p>
      </xsl:if>
      <xsl:if test="role">
        <p>
          <xsl:apply-templates select="role"/>
        </p>
      </xsl:if>
      <xsl:apply-templates
        select="* except (name, degrees, role, addr-line[italic/xref[matches(@xlink:href, 'atom')]], x)"/>
      <xsl:if test="address/addr-line[italic/xref[matches(@xlink:href, 'atom')]]">
        <!-- <p><xsl:apply-templates select="address/addr-line[italic/xref[matches(@xlink:href,'atom')]]"/></p> -->
        <xsl:apply-templates select="address/addr-line[italic/xref[matches(@xlink:href, 'atom')]]"/>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- <xsl:template match="name">
    <span class="name">
      <xsl:apply-templates/>
    </span>
  </xsl:template> -->

  <xsl:template match="surname">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::given-names">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="given-names">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="degrees">
    <xsl:text>, </xsl:text>
    <span class="degrees">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="role">
    <span class="role">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="address">
    <address>
      <xsl:for-each select="* except addr-line[italic/xref[matches(@xlink:href, 'atom')]]">
        <div>
          <xsl:apply-templates/>
        </div>
      </xsl:for-each>
    </address>
  </xsl:template>

  <xsl:template match="address" mode="contrib-group">
    <xsl:for-each select="*"><xsl:apply-templates/><![CDATA[<br />]]></xsl:for-each>
  </xsl:template>

  <xsl:template match="addr-line[italic/xref[matches(@xlink:href, 'atom')]]" priority="1">
    <div class="italic">
      <xsl:apply-templates mode="addr-line"/>
    </div>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  METADATA PROCESSING                                          -->
  <!-- ============================================================= -->

  <!--  Includes mode "metadata" for front matter, along with 
      "metadata-inline" for metadata elements collapsed into 
      inline sequences, plus associated named templates            -->

  <!-- WAS journal-meta content:
       journal-id+, journal-title-group*, issn+, isbn*, publisher?,
       notes? -->
  <!-- (journal-id+, journal-title-group*, (contrib-group | aff | aff-alternatives)*,
       issn+, issn-l?, isbn*, publisher?, notes*, self-uri*) -->
  <xsl:template match="journal-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Journal ID</xsl:text>
        <xsl:for-each select="@journal-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="journal-title-group" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  <xsl:template match="issn" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>ISSN</xsl:text>
        <xsl:call-template name="append-pub-type"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="issn-l" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>ISSN-L</xsl:text>
        <xsl:call-template name="append-pub-type"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="isbn" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>ISBN</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="publisher" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Publisher</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="publisher-name" mode="metadata-inline"/>
        <xsl:apply-templates select="publisher-loc" mode="metadata-inline"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="publisher-name" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="publisher-loc" mode="metadata-inline">
    <span class="generated"> (</span>
    <xsl:apply-templates/>
    <span class="generated">)</span>
  </xsl:template>


  <xsl:template match="notes" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- journal-title-group content:
       (journal-title*, journal-subtitle*, trans-title-group*,
       abbrev-journal-title*) -->

  <xsl:template match="journal-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="journal-subtitle" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Subtitle</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="trans-title-group" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  <xsl:template match="abbrev-journal-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Abbreviated Title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- trans-title-group content: (trans-title, trans-subtitle*) -->

  <xsl:template match="trans-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Translated Title</xsl:text>
        <xsl:for-each select="(../@xml:lang | @xml:lang)[last()]">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="trans-subtitle" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Translated Subtitle</xsl:text>
        <xsl:for-each select="(../@xml:lang | @xml:lang)[last()]">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- article-meta content:
    (article-id*, article-categories?, title-group,
     (contrib-group | aff)*, author-notes?, pub-date+, volume?,
     volume-id*, volume-series?, issue?, issue-id*, 
     issue-title*, issue-sponsor*, issue-part?, isbn*, 
     supplement?, ((fpage, lpage?, page-range?) | elocation-id)?, 
     (email | ext-link | uri | product | supplementary-material)*, 
     history?, permissions?, self-uri*, related-article*,
     abstract*, trans-abstract*, 
     kwd-group*, funding-group*, conference*, counts?, 
     custom-meta-group?) -->

  <!-- In order of appearance... -->

  <xsl:template match="ext-link" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>External link</xsl:text>
        <xsl:for-each select="ext-link-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="email" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Email</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="uri" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">URI</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="self-uri" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Self URI</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <a href="{@xlink:href}">
          <xsl:choose>
            <xsl:when test="normalize-space(string(.))">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@xlink:href"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="product" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Product Information</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:choose>
          <xsl:when test="normalize-space(string(@xlink:href))">
            <a>
              <xsl:call-template name="assign-href"/>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="permissions" mode="metadata">
    <xsl:apply-templates select="copyright-statement" mode="metadata"/>
    <xsl:if test="copyright-year | copyright-holder">
      <xsl:call-template name="metadata-labeled-entry">
        <xsl:with-param name="label">Copyright</xsl:with-param>
        <xsl:with-param name="contents">
          <xsl:for-each select="copyright-year | copyright-holder">
            <xsl:apply-templates/>
            <xsl:if test="not(position() = last())">, </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="license" mode="metadata"/>
  </xsl:template>


  <xsl:template match="copyright-statement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Copyright statement</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="copyright-year" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Copyright</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="license" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">
        <xsl:text>License</xsl:text>
        <xsl:if test="@license-type | @xlink:href">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="@license-type"/>
            <xsl:if test="@xlink:href">
              <xsl:if test="@license-type">, </xsl:if>
              <a>
                <xsl:call-template name="assign-href"/>
                <xsl:value-of select="@xlink:href"/>
              </a>
            </xsl:if>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="history/date" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Date</xsl:text>
        <xsl:for-each select="@date-type">
          <xsl:choose>
            <xsl:when test=". = 'accepted'"> accepted</xsl:when>
            <xsl:when test=". = 'received'"> received</xsl:when>
            <xsl:when test=". = 'rev-request'"> revision requested</xsl:when>
            <xsl:when test=". = 'rev-recd'"> revision received</xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="format-date"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="pub-date" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Publication date</xsl:text>
        <xsl:call-template name="append-pub-type"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="format-date"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="volume-info">
    <!-- handles volume?, volume-id*, volume-series? -->
    <xsl:if test="volume | volume-id | volume-series">
      <xsl:choose>
        <xsl:when test="not(volume-id[2]) or not(volume)">
          <!-- if there are no multiple volume-id, or no volume, we make one line only -->
          <xsl:call-template name="metadata-labeled-entry">
            <xsl:with-param name="label">Volume</xsl:with-param>
            <xsl:with-param name="contents">
              <xsl:apply-templates select="volume | volume-series" mode="metadata-inline"/>
              <xsl:apply-templates select="volume-id" mode="metadata-inline"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="volume | volume-id | volume-series" mode="metadata"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <xsl:template match="volume | issue" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="volume-id | issue-id" mode="metadata-inline">
    <span class="generated">
      <xsl:text> (</xsl:text>
      <xsl:for-each select="@pub-id-type">
        <span class="data">
          <xsl:value-of select="."/>
        </span>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:text>ID: </xsl:text>
    </span>
    <xsl:apply-templates/>
    <span class="generated">)</span>
  </xsl:template>


  <xsl:template match="volume-series" mode="metadata-inline">
    <xsl:if test="preceding-sibling::volume">
      <span class="generated">,</span>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="volume" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Volume</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="volume-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Volume ID</xsl:text>
        <xsl:for-each select="@pub-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="volume-series" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Series</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="issue-info">
    <!-- handles issue?, issue-id*, issue-title*, issue-sponsor*, issue-part?, supplement? -->
    <xsl:variable name="issue-info"
      select="
        issue | issue-id | issue-title |
        issue-sponsor | issue-part"/>
    <xsl:choose>
      <xsl:when
        test="$issue-info and not(issue-id[2] | issue-title[2] | issue-sponsor | issue-part)">
        <!-- if there are only one issue, issue-id and issue-title and nothing else, we make one line only -->
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">Issue</xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:apply-templates select="issue | issue-title" mode="metadata-inline"/>
            <xsl:apply-templates select="issue-id" mode="metadata-inline"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$issue-info" mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="issue-title" mode="metadata-inline">
    <span class="generated">
      <xsl:if test="preceding-sibling::issue">,</xsl:if>
    </span>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="issue" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="issue-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Issue ID</xsl:text>
        <xsl:for-each select="@pub-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="issue-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="issue-sponsor" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="issue-part" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue part</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="page-info">
    <!-- handles (fpage, lpage?, page-range?) -->
    <xsl:if test="fpage | lpage | page-range">
      <xsl:call-template name="metadata-labeled-entry">
        <xsl:with-param name="label">
          <xsl:text>Page</xsl:text>
          <xsl:if
            test="
              normalize-space(string(lpage[not(. = ../fpage)]))
              or normalize-space(string(page-range))">
            <!-- we have multiple pages if lpage exists and is not equal fpage,
               or if we have a page-range -->
            <xsl:text>s</xsl:text>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="contents">
          <xsl:value-of select="fpage"/>
          <xsl:if test="normalize-space(string(lpage[not(. = ../fpage)]))">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="lpage"/>
          </xsl:if>
          <xsl:for-each select="page-range">
            <xsl:text> (pp. </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>)</xsl:text>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <xsl:template match="elocation-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Electronic Location Identifier</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- isbn is already matched in mode 'metadata' above -->

  <xsl:template match="supplement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Supplement Info</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="related-article | related-object" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Related </xsl:text>
        <xsl:choose>
          <xsl:when test="self::related-object">object</xsl:when>
          <xsl:otherwise>article</xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="@related-article-type | @object-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="translate(., '-', ' ')"/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:choose>
          <xsl:when test="normalize-space(string(@xlink:href))">
            <a>
              <xsl:call-template name="assign-href"/>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conference" mode="metadata">
    <!-- content model:
      (conf-date, 
       (conf-name | conf-acronym)+, 
       conf-num?, conf-loc?, conf-sponsor*, conf-theme?) -->
    <xsl:choose>
      <xsl:when
        test="
          not(conf-name[2] | conf-acronym[2] | conf-sponsor |
          conf-theme)">
        <!-- if there is no second name or acronym, and no sponsor
             or theme, we make one line only -->
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">Conference</xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:apply-templates select="conf-acronym | conf-name" mode="metadata-inline"/>
            <xsl:apply-templates select="conf-num" mode="metadata-inline"/>
            <xsl:if test="conf-date | conf-loc">
              <span class="generated"> (</span>
              <xsl:for-each select="conf-date | conf-loc">
                <xsl:if test="position() = 2">, </xsl:if>
                <xsl:apply-templates select="." mode="metadata-inline"/>
              </xsl:for-each>
              <span class="generated">)</span>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="conf-date" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference date</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-name" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-acronym" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-num" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference number</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-loc" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference location</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-sponsor" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-theme" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference theme</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="conf-name | conf-acronym" mode="metadata-inline">
    <!-- we only hit this template if there is at most one of each -->
    <xsl:variable name="following"
      select="preceding-sibling::conf-name | preceding-sibling::conf-acronym"/>
    <!-- if we come after the other, we go in parentheses -->
    <xsl:if test="$following">
      <span class="generated"> (</span>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="$following">
      <span class="generated">)</span>
    </xsl:if>
  </xsl:template>


  <xsl:template match="conf-num" mode="metadata-inline">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="conf-date | conf-loc" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="article-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:choose>
          <xsl:when test="@pub-id-type = 'art-access-id'">Accession ID</xsl:when>
          <xsl:when test="@pub-id-type = 'coden'">Coden</xsl:when>
          <xsl:when test="@pub-id-type = 'doi'">DOI</xsl:when>
          <xsl:when test="@pub-id-type = 'manuscript'">Manuscript ID</xsl:when>
          <xsl:when test="@pub-id-type = 'medline'">Medline ID</xsl:when>
          <xsl:when test="@pub-id-type = 'pii'">Publisher Item ID</xsl:when>
          <xsl:when test="@pub-id-type = 'pmid'">PubMed ID</xsl:when>
          <xsl:when test="@pub-id-type = 'publisher-id'">Publisher ID</xsl:when>
          <xsl:when test="@pub-id-type = 'sici'">Serial Item and Contribution ID</xsl:when>
          <xsl:when test="@pub-id-type = 'doaj'">DOAJ ID</xsl:when>
          <xsl:when test="@pub-id-type = 'arXiv'">arXiv.org ID</xsl:when>
          <xsl:otherwise>
            <xsl:text>Article Id</xsl:text>
            <xsl:for-each select="@pub-id-type">
              <xsl:text> (</xsl:text>
              <span class="data">
                <xsl:value-of select="."/>
              </span>
              <xsl:text>)</xsl:text>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="contract-num" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Contract</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="contract-sponsor" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Contract Sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="grant-num" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Grant Number</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="grant-sponsor" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Grant Sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="award-group" mode="metadata">
    <!-- includes (funding-source*, award-id*, principal-award-recipient*, principal-investigator*) -->
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  <xsl:template match="funding-source" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Funded by</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="award-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Award ID</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="principal-award-recipient" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Award Recipient</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="principal-investigator" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Principal Investigator</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="funding-statement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Funding</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="open-access" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Open Access</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="book-title-group" mode="metadata">
    <!-- content model:
    article-title, subtitle*, trans-title-group*, alt-title*, fn-group? -->
    <!-- trans-title and trans-subtitle included for 2.3 -->
    <xsl:apply-templates
      select="
        book-title | subtitle | trans-title-group |
        trans-title | trans-subtitle"
      mode="metadata"/>
    <xsl:if test="alt-title | fn-group">
      <div class="document-title-notes metadata-group">
        <xsl:apply-templates select="alt-title | fn-group" mode="metadata"/>
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template match="book-title-group/book-title" mode="metadata">
    <h1 class="document-title">
      <xsl:apply-templates/>
      <xsl:if test="../subtitle">:</xsl:if>
    </h1>
  </xsl:template>


  <xsl:template match="book-title-group/subtitle | trans-title-group/subtitle" mode="metadata">
    <h2 class="document-title">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>


  <xsl:template match="title-group/trans-title-group" mode="metadata">
    <!-- content model: (trans-title, trans-subtitle*) -->
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>

  <xsl:template match="title-group[parent::book-part-meta]/title[not(/book-part)]"/>
  <xsl:template match="title-group[parent::book-part-meta]/title[/book-part]">
    <h4 class="title">
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

  <xsl:template match="title-group[parent::book-part-meta]/label[not(/book-part)]"/>
  <xsl:template match="title-group[parent::book-part-meta]/label[/book-part]">
    <h3 class="label">
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="fpage[parent::book-part-meta]"/>
  <xsl:template match="lpage[parent::book-part-meta]"/>


  <xsl:template match="title-group/alt-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Alternative title</xsl:text>
        <xsl:for-each select="@alt-title-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="title-group/fn-group" mode="metadata">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template mode="metadata" match="journal-meta/contrib-group">
    <xsl:for-each select="contrib">
      <xsl:variable name="contrib-identification">
        <xsl:call-template name="contrib-identify"/>
      </xsl:variable>
      <!-- placing the div only if it has content -->
      <!-- the extra call to string() makes it type-safe in a type-aware
           XSLT 2.0 engine -->
      <xsl:if test="normalize-space(string($contrib-identification))">
        <xsl:copy-of select="$contrib-identification"/>
      </xsl:if>
      <xsl:variable name="contrib-info">
        <xsl:call-template name="contrib-info"/>
      </xsl:variable>
      <!-- placing the div only if it has content -->
      <xsl:if test="normalize-space(string($contrib-info))">
        <xsl:copy-of select="$contrib-info"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:if test="*[not(self::contrib | self::xref)]">

      <xsl:apply-templates mode="metadata" select="*[not(self::contrib | self::xref)]"/>

    </xsl:if>
  </xsl:template>

  <xsl:template mode="metadata" match="article-meta/contrib-group">
    <!-- content model of contrib-group:
        (contrib+, 
        (address | aff | author-comment | bio | email |
        ext-link | on-behalf-of | role | uri | xref)*) -->
    <!-- each contrib makes a row: name at left, details at right -->
    <xsl:for-each select="contrib">
      <!--  content model of contrib:
          ((contrib-id)*,
           (anonymous | collab | collab-alternatives | name | name-alternatives)*,
           (degrees)*,
           (address | aff | aff-alternatives | author-comment | bio | email |
            ext-link | on-behalf-of | role | uri | xref)*)       -->
      <div class="metadata two-column table">
        <div class="row">
          <div class="cell" style="text-align: right">
            <xsl:call-template name="contrib-identify">
              <!-- handles (contrib-id)*,
                (anonymous | collab | collab-alternatives |
                 name | name-alternatives | degrees | xref) -->
            </xsl:call-template>
          </div>
          <div class="cell">
            <xsl:call-template name="contrib-info">
              <!-- handles
                   (address | aff | author-comment | bio | email |
                    ext-link | on-behalf-of | role | uri) -->
            </xsl:call-template>
          </div>
        </div>
      </div>
    </xsl:for-each>
    <!-- end of contrib -->
    <xsl:variable name="misc-contrib-data" select="*[not(self::contrib | self::xref)]"/>
    <xsl:if test="$misc-contrib-data">
      <div class="metadata two-column table">
        <div class="row">
          <div class="cell">&#160;</div>
          <div class="cell">
            <div class="metadata-group">
              <xsl:apply-templates mode="metadata" select="$misc-contrib-data"/>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template name="contrib-identify">
    <!-- Placed in a left-hand pane  -->
    <!--handles
    (anonymous | collab | collab-alternatives |
    name | name-alternatives | degrees | xref)
    and @equal-contrib -->
    <div class="metadata-group">
      <xsl:for-each
        select="
          anonymous |
          collab | collab-alternatives/* | name | name-alternatives/*">
        <xsl:call-template name="metadata-entry">
          <xsl:with-param name="contents">
            <xsl:if test="position() = 1">
              <!-- a named anchor for the contrib goes with its
              first member -->
              <xsl:call-template name="named-anchor"/>
              <!-- so do any contrib-ids -->
              <xsl:apply-templates mode="metadata-inline" select="../contrib-id"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="metadata-inline"/>
            <xsl:if test="position() = last()">
              <xsl:apply-templates mode="metadata-inline" select="degrees | xref"/>
              <!-- xrefs in the parent contrib-group go with the last member
              of *each* contrib in the group -->
              <xsl:apply-templates mode="metadata-inline" select="following-sibling::xref"/>
            </xsl:if>

          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:if test="@equal-contrib = 'yes'">
        <xsl:call-template name="metadata-entry">
          <xsl:with-param name="contents">
            <span class="generated">(Equal contributor)</span>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>


  <xsl:template match="anonymous" mode="metadata-inline">
    <xsl:text>Anonymous</xsl:text>
  </xsl:template>


  <xsl:template match="
      collab |
      collab-alternatives/*" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="
      contrib/name |
      contrib/name-alternatives/*"
    mode="metadata-inline">
    <xsl:apply-templates select="."/>
  </xsl:template>


  <xsl:template match="degrees" mode="metadata-inline">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="xref" mode="metadata-inline">
    <!-- These are not expected to appear in mixed content, so
      brackets are provided -->
    <span class="generated">[</span>
    <xsl:apply-templates select="."/>
    <span class="generated">]</span>
  </xsl:template>

  <xsl:template match="contrib-id" mode="metadata-inline">
    <span class="generated">[</span>
    <xsl:apply-templates select="."/>
    <span class="generated">] </span>
  </xsl:template>


  <xsl:template name="contrib-info">
    <!-- Placed in a right-hand pane -->
    <div class="metadata-group">
      <xsl:apply-templates mode="metadata"
        select="
          address | aff | author-comment | bio | email |
          ext-link | on-behalf-of | role | uri"
      />
    </div>
  </xsl:template>


  <xsl:template mode="metadata" match="address[not(addr-line) or not(*[2])]">
    <!-- when we have no addr-line or a single child, we generate
         a single unlabelled line -->
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:call-template name="address-line"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- <xsl:template match="address" mode="metadata">
    <!-/- when we have an addr-line we generate an unlabelled block -/->
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template> -->


  <xsl:template mode="metadata" priority="2" match="address/*">
    <!-- being sure to override other templates for these
         element types -->
    <xsl:call-template name="metadata-entry"/>
  </xsl:template>


  <xsl:template match="aff" mode="metadata">
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="author-comment" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Comment</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="bio" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Bio</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="on-behalf-of" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">On behalf of</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="role" mode="metadata">
    <xsl:call-template name="metadata-entry"/>
  </xsl:template>


  <xsl:template match="author-notes" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Author notes</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="author-notes/corresp" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:call-template name="named-anchor"/>
        <xsl:text>Correspondence to</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="author-notes/fn | author-notes/p" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:apply-templates select="@fn-type"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="supplementary-material" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Supplementary material</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="article-categories" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  <xsl:template match="article-categories/subj-group" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Categories</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="subj-group" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  <xsl:template match="subj-group/subj-group" mode="metadata">
    <div class="metadata-area">
      <xsl:apply-templates mode="metadata"/>
    </div>
  </xsl:template>


  <xsl:template match="subj-group/subject" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Subject</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="series-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Series title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="series-text" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Series description</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="kwd-group" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">
        <xsl:apply-templates select="title | label" mode="metadata-inline"/>
        <xsl:if test="not(title | label)">Keywords</xsl:if>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="title" mode="metadata">
    <xsl:apply-templates select="."/>
  </xsl:template>


  <xsl:template match="kwd" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Keyword</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="nested-kwd" mode="metadata">
    <ul class="nested-kwd">
      <xsl:apply-templates mode="metadata"/>
    </ul>
  </xsl:template>

  <xsl:template match="nested-kwd/kwd" mode="metadata">
    <li class="kwd">
      <xsl:apply-templates/>
    </li>
  </xsl:template>


  <xsl:template match="compound-kwd" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Compound keyword</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="compound-kwd-part" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Keyword part</xsl:text>
        <xsl:for-each select="@content-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="counts" mode="metadata">
    <!-- fig-count?, table-count?, equation-count?, ref-count?,
         page-count?, word-count? -->
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Counts</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template mode="metadata"
    match="
      count | fig-count | table-count | equation-count |
      ref-count | page-count | word-count">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:apply-templates select="." mode="metadata-label"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="@count"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="count" mode="metadata-label">
    <xsl:text>Count</xsl:text>
    <xsl:for-each select="@count-type">
      <xsl:text> (</xsl:text>
      <span class="data">
        <xsl:value-of select="."/>
      </span>
      <xsl:text>)</xsl:text>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="fig-count" mode="metadata-label">Figures</xsl:template>


  <xsl:template match="table-count" mode="metadata-label">Tables</xsl:template>


  <xsl:template match="equation-count" mode="metadata-label">Equations</xsl:template>


  <xsl:template match="ref-count" mode="metadata-label">References</xsl:template>


  <xsl:template match="page-count" mode="metadata-label">Pages</xsl:template>


  <xsl:template match="word-count" mode="metadata-label">Words</xsl:template>


  <xsl:template mode="metadata" match="custom-meta-group | custom-meta-wrap">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Custom metadata</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="custom-meta" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <span class="data">
          <xsl:apply-templates select="meta-name" mode="metadata-inline"/>
        </span>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="meta-value" mode="metadata-inline"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="meta-name | meta-value" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  REGULAR (DEFAULT) MODE                                       -->
  <!-- ============================================================= -->


  <xsl:template match="sec">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks')">
        <div class="section">
          <div id="{concat('print_',@id)}">
            <xsl:call-template name="named-anchor"/>
            <xsl:apply-templates select="title[not(child::comment()='dummy-title')]"/>
            <div class="toc-content">
            <xsl:apply-templates select="sec-meta"/>
            <xsl:apply-templates mode="drop-title"/>
            </div>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section">
          <xsl:call-template name="named-anchor"/>
          <xsl:apply-templates select="title"/>
          <xsl:apply-templates select="sec-meta"/>
          <xsl:apply-templates mode="drop-title"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="boxed-text/sec">
    <div>
      <xsl:attribute name="class"
        select="
          if (question-wrap-group) then
            'section qna'
          else
            'section'"/>
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="*" mode="drop-title">
    <xsl:apply-templates select="."/>
  </xsl:template>


  <xsl:template match="title | sec-meta" mode="drop-title"/>


  <xsl:template match="app">
    <div class="section app">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  

  <xsl:template match="ref-list" name="ref-list">
    <div class="section references">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates select="*[not(self::ref | self::ref-list)]"/>
      <xsl:if test="ref">
        <ol class="ref-list table">
          <xsl:apply-templates select="ref"/>
        </ol>
      </xsl:if>
      <xsl:apply-templates select="ref-list"/>
    </div>
  </xsl:template>

  <xsl:template match="/ref-list/title"/> <!-- ignore title if ref-list is root element (springrsc3-526) -->
  <xsl:template match="ref-list[exists(ancestor::article) or exists(ancestor::book-part)]/title">
    <h2 class="ref-list title">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="sec-meta">
    <div class="section-metadata">
      <!-- includes contrib-group | permissions | kwd-group -->
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="sec-meta[not(ancestor::ack)]/contrib-group">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="sec-meta/kwd-group">
    <!-- matches only if contrib-group has only contrib children -->
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>



  <!-- ============================================================= -->
  <!--  Titles                                                       -->
  <!-- ============================================================= -->

  <xsl:template name="main-title" match="abstract/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h2 class="main-title">
        <xsl:copy-of select="$contents"/>
      </h2>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="section-title"
    match="abstract/*/title | back[title]/*/title | back[not(title)]/*/*/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h3 class="section-title">
        <xsl:copy-of select="$contents"/>
      </h3>
    </xsl:if>
  </xsl:template>
  <xsl:template match="back/app-group/app/title"><!-- SF 01190101 -->
    <h2 class="app-title">
      <xsl:if test="preceding-sibling::*[1][local-name()='label']">
        <xsl:value-of select="preceding-sibling::*[1][local-name()='label']"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template match="app/title">
    <h2 class="app-title">
      <xsl:if test="preceding-sibling::*[1][local-name()='label']">
        <xsl:value-of select="preceding-sibling::*[1][local-name()='label']"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  
  <xsl:template match="sec[@disp-level eq 'level1' or not(ancestor::sec)]/title">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks/') and (matches(child::comment()[1],'dummy-title$'))"></xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks/')">
        <div id="{concat('actioncontainer_',parent::sec/@id)}" class="toc-heading">
        <h2 class="section-title">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates select="*|text()|comment()|processing-instruction() except xref[@ref-type='section']"/>
        </h2>
          <div id="{concat('actions_',parent::sec/@id)}"  sectionData="{parent::sec/@id}" class="toc-actions">
            <xsl:attribute name="resourceDataPath">
              <xsl:call-template name="tmsresourcelink">
                <xsl:with-param name="resourceid"><xsl:value-of select="parent::sec/@id"/></xsl:with-param>
            </xsl:call-template>
            </xsl:attribute>
            
          <xsl:if test="child::xref[@ref-type='section']/@rid">
            <xsl:attribute name="commentaryData"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
            <xsl:attribute name="scrollto"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
            <xsl:if test="contains(base-uri(.),'/standard-chapter/') or contains(base-uri(.),'/back-matter/')">
              <xsl:attribute name="data-scroll">commentary-section</xsl:attribute>
            </xsl:if>
          </xsl:if>
        </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h2 class="section-title">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates/>
        </h2>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sec[@disp-level eq 'level2' or count(ancestor::sec) eq 1]/title">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks/') and (matches(child::comment()[1],'dummy-title$'))"></xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks/')">
        <div id="{concat('actioncontainer_',parent::sec/@id)}" class="toc-heading">
          <h3 class="section-title">
            <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
              <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
            </xsl:if>
            <xsl:apply-templates select="*|text()|comment()|processing-instruction() except xref[@ref-type='section']"/>
            </h3>
          <div id="{concat('actions_',parent::sec/@id)}"  sectionData="{parent::sec/@id}" class="toc-actions">
            <xsl:attribute name="resourceDataPath">
              <xsl:call-template name="tmsresourcelink">
                <xsl:with-param name="resourceid"><xsl:value-of select="parent::sec/@id"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
              <xsl:if test="child::xref[@ref-type='section']/@rid">
                <xsl:attribute name="commentaryData"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
                <xsl:attribute name="scrollto"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
                <xsl:if test="contains(base-uri(.),'/standard-chapter/')  or contains(base-uri(.),'/back-matter/')">
                  <xsl:attribute name="data-scroll">commentary-section</xsl:attribute>
                </xsl:if>
              </xsl:if>
            </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h3 class="section-title">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sec[@disp-level eq 'level3' or count(ancestor::sec) eq 2]/title">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks/') and (matches(child::comment()[1],'dummy-title$'))"></xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks/')">
        <div id="{concat('actioncontainer_',parent::sec/@id)}" class="toc-heading">
          <h4 class="section-title">
            <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
              <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
            </xsl:if>
            <xsl:apply-templates select="*|text()|comment()|processing-instruction() except xref[@ref-type='section']"/>
          </h4>
          <div id="{concat('actions_',parent::sec/@id)}"  sectionData="{parent::sec/@id}" class="toc-actions">
            <xsl:attribute name="resourceDataPath">
              <xsl:call-template name="tmsresourcelink">
                <xsl:with-param name="resourceid"><xsl:value-of select="parent::sec/@id"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
              <xsl:if test="child::xref[@ref-type='section']/@rid">
                <xsl:attribute name="commentaryData"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
                <xsl:attribute name="scrollto"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
                <xsl:if test="contains(base-uri(.),'/standard-chapter/')  or contains(base-uri(.),'/back-matter/')">
                  <xsl:attribute name="data-scroll">commentary-section</xsl:attribute>
                </xsl:if>
              </xsl:if>
            </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h4 class="section-title">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates/>
        </h4>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sec[@disp-level eq 'level4' or count(ancestor::sec) eq 3]/title">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks/') and (matches(child::comment()[1],'dummy-title$'))"></xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks/')">
        <div id="{concat('actioncontainer_',parent::sec/@id)}" class="toc-heading">
          <h5 class="section-title">
            <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
              <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
            </xsl:if>
            <xsl:apply-templates select="*|text()|comment()|processing-instruction() except xref[@ref-type='section']"/>
          </h5>
          <div id="{concat('actions_',parent::sec/@id)}"  sectionData="{parent::sec/@id}" class="toc-actions">
            <xsl:attribute name="resourceDataPath">
              <xsl:call-template name="tmsresourcelink">
                <xsl:with-param name="resourceid"><xsl:value-of select="parent::sec/@id"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:if test="child::xref[@ref-type='section']/@rid">
              <xsl:attribute name="commentaryData"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
              <xsl:attribute name="scrollto"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
              <xsl:if test="contains(base-uri(.),'/standard-chapter/') or contains(base-uri(.),'/back-matter/')">
                <xsl:attribute name="data-scroll">commentary-section</xsl:attribute>
              </xsl:if>
            </xsl:if>
            
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h5 class="section-title">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates/>
        </h5>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sec[count(ancestor::sec) gt 3]/title">
    <xsl:choose>
      <xsl:when test="contains(base-uri(.),'/tmsworks/') and (matches(child::comment()[1],'dummy-title$'))"></xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks/')">
        <div id="{concat('actioncontainer_',parent::sec/@id)}" class="toc-heading">
          <h6 class="section-title unmatched">
            <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
              <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
            </xsl:if>
            <xsl:apply-templates select="*|text()|comment()|processing-instruction() except xref[@ref-type='section']"/>
          </h6>
          <div id="{concat('actions_',parent::sec/@id)}"  sectionData="{parent::sec/@id}" class="toc-actions">
            <xsl:attribute name="resourceDataPath">
              <xsl:call-template name="tmsresourcelink">
                <xsl:with-param name="resourceid"><xsl:value-of select="parent::sec/@id"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:if test="child::xref[@ref-type='section']/@rid">
              <xsl:attribute name="commentaryData"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
              <xsl:attribute name="scrollto"><xsl:value-of select="child::xref[@ref-type='section']/@rid"/></xsl:attribute>
              <xsl:if test="contains(base-uri(.),'/standard-chapter/') or contains(base-uri(.),'/back-matter/')">
                <xsl:attribute name="data-scroll">commentary-section</xsl:attribute>
              </xsl:if>
            </xsl:if>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h6 class="section-title unmatched">
          <xsl:if test="preceding-sibling::label and contains(base-uri(.),'/tmsworks/')">
            <xsl:value-of select="concat(preceding-sibling::label,' ')"/>
          </xsl:if>
          <xsl:apply-templates/>
        </h6>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="subsection-title"
    match="abstract/*/*/title | back[title]/*/*/title | back[not(title)]/*/*/*/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h4 class="subsection-title">
        <xsl:copy-of select="$contents"/>
      </h4>
    </xsl:if>
  </xsl:template>


  <xsl:template name="block-title" priority="2"
    match="
      list/title | def-list/title | boxed-text/title |
      verse-group/title | glossary/title | gloss-group/title | kwd-group/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h4 class="block-title">
        <xsl:copy-of select="$contents"/>
      </h4>
    </xsl:if>
  </xsl:template>


  <!-- default: any other titles found -->
  <xsl:template match="book-title">
    <xsl:if test="normalize-space(string(.))">
      <h3 class="title">
        <xsl:apply-templates/>
      </h3>
    </xsl:if>
  </xsl:template>


  <xsl:template match="subtitle">
    <xsl:if test="normalize-space(string(.))">
      <h5 class="subtitle">
        <xsl:apply-templates/>
      </h5>
    </xsl:if>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  Figures, lists and block-level objectS                       -->
  <!-- ============================================================= -->


  <!-- <xsl:template match="address">
    <xsl:choose>
      <!-/- address appears as a sequence of inline elements if
           it has no addr-line and the parent may contain text -/->
      <xsl:when test="not(addr-line) and
        (parent::collab | parent::p | parent::license-p |
         parent::named-content | parent::styled-content)">
        <xsl:call-template name="address-line"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="address">
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->


  <xsl:template name="address-line">
    <!-- emits element children in a simple comma-delimited sequence -->
    <xsl:for-each select="*">
      <xsl:if test="position() &gt; 1">, </xsl:if>
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="address/*">
    <p class="address-line">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template
    match="
      array | disp-formula-group | fig-group |
      fn-group | license | long-desc | open-access | sig-block |
      table-wrap-foot | table-wrap-group">
    <div class="{local-name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="attrib">
    <p class="attrib">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="chem-struct-wrap | fig | table-wrap | chem-struct-wrapper">
    <!-- chem-struct-wrapper is from NLM 2.3 -->
    <xsl:variable name="gi">
      <xsl:choose>
        <xsl:when test="self::chem-struct-wrapper">chem-struct-wrap</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{$gi} panel">
      <xsl:apply-templates select="@id"/>
      <xsl:if test="not(@position != 'float')">
        <!-- the test respects @position='float' as the default -->
        <!-- <xsl:attribute name="style">display: float; clear: both</xsl:attribute> -->
      </xsl:if>
      <xsl:attribute name="data-parent-section"><xsl:text>#</xsl:text><xsl:value-of select="ancestor::sec[1]/@id"/></xsl:attribute>
      <!-- <xsl:call-template name="named-anchor"/> -->
      <!-- <xsl:apply-templates select="." mode="label"/> -->
      <xsl:if test="label">
        <xsl:apply-templates select="label" mode="hw-label"/>
      </xsl:if>
      <xsl:variable name="long-desc-id" as="xs:string?" select="if (exists(.//long-desc)) then (.//long-desc/@id,concat('long-desc-',generate-id(.)))[1] else ()"/>
      <xsl:apply-templates select="* except long-desc">
        <xsl:with-param name="long-desc-id" as="xs:string?" tunnel="yes" select="$long-desc-id"/>
      </xsl:apply-templates>
     <xsl:if test="$long-desc-id">
      <div class="long-desc" id="{$long-desc-id}">
          <xsl:for-each select=".//long-desc">
            <p><xsl:value-of select="."/></p>
          </xsl:for-each>
        </div>
      </xsl:if>
      <xsl:apply-templates mode="footnote"
        select="self::table-wrap//fn[not(ancestor::table-wrap-foot)]"/>
    </div>
  </xsl:template>

  <xsl:template match="boxed-text">
    <div class="boxed-text panel">
      <xsl:apply-templates select="@id"/>
      <xsl:if test="label">
        <xsl:apply-templates select="label" mode="hw-label"/>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="label" mode="hw-label">
    <xsl:choose>
      <xsl:when test="(parent::fig or parent::table-wrap) and contains(base-uri(.),'/tmsworks/')">
        
      </xsl:when>
      <xsl:otherwise>
        <div class="label">
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="caption">
    <div class="caption">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="caption/p">
    <div class="caption-title">
      <xsl:if test="contains(base-uri(.),'/tmsworks/')">
        <span class="label"><xsl:value-of select="../preceding-sibling::label"/><xsl:text> </xsl:text></span>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="caption/title">
    <div class="caption-title">
      <xsl:if test="contains(base-uri(.),'/tmsworks/')">
        <span class="label"><xsl:value-of select="../preceding-sibling::label"/><xsl:text> </xsl:text></span>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="disp-formula | statement">
    <div class="{local-name()} panel">
      <xsl:if test="local-name()='disp-formula'">
        <xsl:attribute name="data-parent-section"><xsl:text>#</xsl:text><xsl:value-of select="ancestor::sec[1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="glossary | gloss-group">
    <!-- gloss-group is from 2.3 -->
    <div class="glossary">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <!-- <xsl:if test="not(normalize-space(string(title)))">
        <xsl:call-template name="block-title">
          <xsl:with-param name="contents">
            <span class="generated">Glossary</span>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if> -->
      <xsl:apply-templates select="*[not(self::label | self::title)]"/>
    </div>
  </xsl:template>


  <xsl:template match="textual-form">
    <p class="textual-form">
      <span class="generated">[Textual form] </span>
      <xsl:apply-templates/>
    </p>
  </xsl:template>



  <xsl:template match="glossary/glossary | gloss-group/gloss-group">
    <!-- the same document shouldn't have both types -->
    <div class="glossary">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>



  <xsl:template match="graphic | inline-graphic">
    <xsl:param name="long-desc-id" as="xs:string?" tunnel="yes"/>
    <xsl:apply-templates select="* except long-desc"/>
    <img alt="{replace(tokenize(@xlink:href,'/')[last()],'\.[^\.]*$','')}">
      <xsl:if test="$long-desc-id">
        <xsl:attribute name="longdesc" select="concat('#',$long-desc-id)"/>
      </xsl:if>
      <xsl:for-each select="alt-text">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(string(.))"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:call-template name="assign-src"/>
    </img>
    <xsl:if test="local-name() = 'graphic' and contains(base-uri(),'/tmsworks/')">
      <div class="additional-markup"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="alt-text">
    <!-- handled with graphic or inline-graphic -->
  </xsl:template>


  <xsl:template match="list">
    <div class="list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <xsl:apply-templates select="." mode="list"/>
    </div>
  </xsl:template>


  <xsl:template priority="2" mode="list" match="list[@list-type = 'simple' or list-item/label]">
    <ul style="list-style-type: none">
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>


  <xsl:template match="list[@list-type = 'bullet' or not(@list-type)]" mode="list">
    <ul>
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>


  <xsl:template match="list" mode="list">
    <xsl:variable name="style">
      <xsl:choose>
        <xsl:when test="@list-type = 'alpha-lower'">lower-alpha</xsl:when>
        <xsl:when test="@list-type = 'alpha-upper'">upper-alpha</xsl:when>
        <xsl:when test="@list-type = 'roman-lower'">lower-roman</xsl:when>
        <xsl:when test="@list-type = 'roman-upper'">upper-roman</xsl:when>
        <xsl:otherwise>decimal</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <ol style="list-style-type: {$style}">
      <xsl:apply-templates select="list-item"/>
    </ol>
  </xsl:template>


  <xsl:template match="list-item">
    <li>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </li>
  </xsl:template>


  <xsl:template match="list-item/label">
    <!-- per HWPTRIAGE-4377, list-item/label was getting stripped out of fulltext, so removing conditional -->
    <!-- if the next sibling is a p, the label will be called as a run-in -->
    <!-- <xsl:if test="following-sibling::*[1][not(self::p)]"> -->
    <xsl:call-template name="label"/>
    <!-- </xsl:if> -->
  </xsl:template>


  <xsl:template match="media">
    <a>
      <xsl:call-template name="assign-id"/>
      <xsl:call-template name="assign-href"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match="p | license-p">
    <p>
      <xsl:if test="not(preceding-sibling::*)">
        <xsl:attribute name="class">first<xsl:value-of select="if(/*/@book-part-type='keywords') then(' keywords') else()"/></xsl:attribute>
      </xsl:if>
      
      <xsl:call-template name="assign-id"/>
      <xsl:if test="/*/@book-part-type='keywords' and preceding-sibling::p">
        <xsl:attribute name="class">keywords</xsl:attribute>
        <xsl:if test="preceding-sibling::p"><xsl:value-of select="'; '"/></xsl:if>
      </xsl:if>
      <xsl:apply-templates select="@content-type"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="@content-type">
    <!-- <span class="generated">[</span>
    <xsl:value-of select="."/>
    <span class="generated">] </span> -->
  </xsl:template>


  <xsl:template match="list-item/p[not(preceding-sibling::*[not(self::label)])]">
    <p>
      <!-- <xsl:call-template name="assign-id"/> -->
      <!-- <xsl:for-each select="preceding-sibling::label">
        <span class="label">
          <xsl:apply-templates/>
        </span>
      <xsl:text> </xsl:text>
      </xsl:for-each> -->
      <xsl:if test="ancestor::list[1][@list-type='simple'] and contains(base-uri(.),'/tmsworks') and not(preceding-sibling::p) and preceding-sibling::*[1][name()='label']">
        <xsl:value-of select="../label"/><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="product">
    <p class="product">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="permissions">
    <div class="permissions">
      <xsl:apply-templates select="copyright-statement"/>
      <xsl:if test="copyright-year | copyright-holder">
        <p class="copyright">
          <span class="generated">Copyright </span>
          <xsl:for-each select="copyright-year | copyright-holder">
            <xsl:apply-templates/>
            <xsl:if test="not(position() = last())">
              <span class="generated">, </span>
            </xsl:if>
          </xsl:for-each>
        </p>
      </xsl:if>
      <xsl:apply-templates select="license"/>
    </div>
  </xsl:template>


  <xsl:template match="copyright-statement">
    <p class="copyright">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="def-list">
    <div class="def-list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <div class="def-list table">
        <xsl:if test="term-head | def-head">
          <div class="row">
            <div class="cell def-list-head">
              <xsl:apply-templates select="term-head"/>
            </div>
            <div class="cell def-list-head">
              <xsl:apply-templates select="def-head"/>
            </div>
          </div>
        </xsl:if>
        <xsl:apply-templates select="def-item"/>
      </div>
      <xsl:apply-templates select="def-list"/>
    </div>
  </xsl:template>


  <xsl:template match="def-item">
    <div class="def-item row">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="term[parent::def-item]">
    <div>
      <xsl:choose>
        <xsl:when test="starts-with(@id,'G') and contains(base-uri(.),'/tmsworks/')"><xsl:attribute name="class" select="'def-term cell def-small-cell'"/></xsl:when>
        <xsl:otherwise><xsl:attribute name="class" select="'def-term cell'"/></xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="assign-id"/>
      <p>
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:template>


  <xsl:template match="def">
    <div class="def-def cell">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="disp-quote">
    <div class="blockquote">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="preformat">
    <pre class="preformat">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>


  <xsl:template match="alternatives | name-alternatives | collab-alternatives | aff-alternatives">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="citation-alternatives" priority="2">
    <!-- priority bumped to supersede match on ref/* -->
    <!-- may appear in license-p, p, ref, td, th, title  -->
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="ref">
    <li class="row" id="{@id}">
      <xsl:if test="mixed-citation/label or note/label">
        <div class="ref-label cell">
          <xsl:apply-templates select="mixed-citation/label | note/label" mode="label"/>
        </div>
      </xsl:if>
      <div class="ref-content cell">
        <xsl:apply-templates/>
      </div>
    </li>
  </xsl:template>


  <xsl:template match="ref/mixed-citation | ref/citation-alternatives/*" priority="0">
    <div class="citation">
      <xsl:apply-templates select="node() except (label)"/>
    </div>
  </xsl:template>


  <xsl:template match="x[parent::mixed-citation]">
    <!-- <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][self::label]"/>
      <!-/- <xsl:when test="matches(.,'\(')"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:when> -/->
      <xsl:when test="matches(.,'^doi:$')"><xsl:text>. </xsl:text><xsl:apply-templates/></xsl:when>
      <xsl:when test="matches(.,'^\(')"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:when>
      <xsl:when test="matches(.,'^In$')"><xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="matches(.,'\($')"><xsl:apply-templates/></xsl:when>
      <xsl:when test="matches(.,'^&amp;$')"><xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="preceding-sibling::*[1][self::string-name or self::etal or self::collab]">
        <xsl:apply-templates/><xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="following-sibling::*[1][self::uri]"><xsl:apply-templates/><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="matches(.,'[\.:,]$') and following-sibling::*"><xsl:apply-templates/><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="matches(.,'^nd$')"><xsl:apply-templates/><xsl:text>. </xsl:text></xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose> -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][self::label]"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="x[parent::given-names or parent::surname][ancestor::mixed-citation]">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="//@book-part-type = 'reference-topic'"/>
      <xsl:otherwise>
        <!-- <xsl:text> </xsl:text> -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="year[parent::mixed-citation]">
    <span class="cit-pub-date">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="not(following-sibling::*[1][self::x or self::article-title])">
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="article-title[parent::mixed-citation]">
    <xsl:if
      test="not(preceding-sibling::*[1][self::x] or preceding-sibling::*[1][self::string-name[given-names[x]]])">
      <xsl:text>. </xsl:text>
    </xsl:if>
    <span class="cit-article-title">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:value-of select="if(ends-with(.,'?') or ends-with(.,'.')) then(' ') else('. ')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="source[parent::mixed-citation]">
    <span class="cit-source">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:value-of select="if(ends-with(.,'?') or ends-with(.,'.')) then(' ') else('. ')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="comment[parent::mixed-citation]">
    <xsl:if test="preceding-sibling::*[1][self::issue]">
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="preceding-sibling::*[1][self::lpage]">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="collab[parent::mixed-citation]">
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::*[1][self::x or self::uri])">
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="surname[ancestor::mixed-citation]">
    <xsl:apply-templates/>
    <!-- <xsl:if test="not(following-sibling::*[1][self::x])"><xsl:text>, </xsl:text></xsl:if> -->
<!--    <xsl:if test="not(x)">
      <xsl:text>,</xsl:text>
    </xsl:if>
-->
  </xsl:template>

  <xsl:template match="given-names[ancestor::mixed-citation]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="string-name[parent::mixed-citation]">
    <span class="cit-auth">
      <xsl:apply-templates/>
    </span>
    <xsl:choose>
      <xsl:when test="//@book-part-type = 'reference-topic'"/>
      <xsl:otherwise>
        <xsl:if test="following-sibling::*[1][self::string-name]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="not(following-sibling::*[1][self::string-name or self::x])">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="volume[parent::mixed-citation]">
    <span class="cit-vol">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="fpage[parent::mixed-citation]">
    <span class="cit-fpage">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="lpage[parent::mixed-citation]">
    <xsl:if test="not(preceding-sibling::*[1][self::x])">
      <xsl:text>-</xsl:text>
    </xsl:if>
    <span class="cit-lpage">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:text>.</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="chapter-title[parent::mixed-citation]">
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="publisher-loc[parent::mixed-citation]">
    <xsl:if test="not(preceding-sibling::*[1][self::x])">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::*[1][self::x])">
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="pub-id[parent::mixed-citation]">
    <span class="cit-pub-id cit-pub-id-{normalize-space(lower-case(@pub-id-type))}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="ref/note" priority="2">
    <xsl:param name="label" select="''"/>
    <!-- we'll get the label in the ref template above -->
    <!-- <xsl:if test="normalize-space(string($label))
      and not(preceding-sibling::*[not(self::label)])">
      <p class="label">
          <xsl:copy-of select="$label"/>
      </p>
    </xsl:if> -->
    <div class="note">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="* except label"/>
    </div>
  </xsl:template>


  <xsl:template
    match="
      app/related-article |
      app-group/related-article | bio/related-article |
      body/related-article | boxed-text/related-article |
      disp-quote/related-article | glossary/related-article |
      gloss-group/related-article |
      ref-list/related-article | sec/related-article">
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>


  <xsl:template
    match="
      app/related-object |
      app-group/related-object | bio/related-object |
      body/related-object | boxed-text/related-object |
      disp-quote/related-object | glossary/related-object |
      gloss-group/related-article |
      ref-list/related-object | sec/related-object">
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>


  <xsl:template match="speech">
    <div class="speech">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates mode="speech"/>
    </div>
  </xsl:template>


  <xsl:template match="speech/speaker" mode="speech"/>


  <xsl:template match="speech/p" mode="speech">
    <p>
      <xsl:apply-templates select="self::p[not(preceding-sibling::p)]/../speaker"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="speech/speaker">
    <b>
      <xsl:apply-templates/>
    </b>
    <!-- <span class="generated">: </span> -->
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="supplementary-material">
    <div class="panel">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="tex-math">
    <span class="tex-math">
      <span class="generated">[TeX:] </span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="mml:*">
    <!-- this stylesheet simply copies MathML through. If your browser
         supports it, you will get it -->
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="verse-group">
    <div class="verse">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="verse-line">
    <p class="verse-line">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="aff/label | corresp/label | chem-struct/label">
    <!-- these labels appear in line -->
    <span class="generated">[</span>
    <xsl:apply-templates/>
    <span class="generated">] </span>
  </xsl:template>


  <xsl:template
    match="
      app/label | boxed-text/label |
      chem-struct-wrap/label | chem-struct-wrapper/label |
      disp-formula/label | fig/label | fn/label | ref/label |
      statement/label | supplementary-material/label | table-wrap/label"
    priority="2">
    <!-- suppressed, since acquired by their parents in mode="label" -->
  </xsl:template>


  <xsl:template match="p/label">
    <span class="label">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="label" name="label">
    <!-- other labels are displayed as blocks -->
    <xsl:choose>
      <xsl:when test="(parent::fig or parent::table-wrap) and contains(base-uri(.),'/tmsworks/')">
        
      </xsl:when>
      <xsl:when test="parent::fig or parent::table-wrap">
        <div class="label">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:when test="parent::sec and following-sibling::title and contains(base-uri(.),'/tmsworks/')">
      </xsl:when>
      <xsl:when test="contains(base-uri(.),'/tmsworks') and ancestor::list[1][@list-type='simple']"></xsl:when>
      <xsl:otherwise>
        <span class="label">
          <xsl:apply-templates/>
          <!-- <xsl:if test="following-sibling::*[1][self::x]"><xsl:value-of select="following-sibling::*[1][self::x]"/><xsl:text> </xsl:text></xsl:if> -->
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  TABLES                                                       -->
  <!-- ============================================================= -->
  <!--  Tables are already in XHTML, and can simply be copied
        through                                                      -->


  <xsl:template match="table | thead | tbody | tfoot | col | tr | th | td">
    <xsl:copy copy-namespaces="no">
      <xsl:if test="local-name(.) eq 'table' and //@rowspan >= '2'">
        <xsl:attribute name="class" select="'no-striping'"/>
      </xsl:if>
      <xsl:apply-templates
        select="@* except (@frame, @rules, @border, @cellpadding, @cellspacing, @span, @valign)"
        mode="table-copy"/>
      <!-- <xsl:call-template name="named-anchor"/> -->
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="colgroup">
    <colgroup>
      <xsl:choose>
        <xsl:when test="col"/>
        <xsl:otherwise>
          <xsl:attribute name="span" select="@span"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </colgroup>
  </xsl:template>

  <xsl:template match="array/tbody">
    <table>
      <xsl:copy>
        <xsl:apply-templates select="@*" mode="table-copy"/>
        <!-- <xsl:call-template name="named-anchor"/> -->
        <xsl:apply-templates/>
      </xsl:copy>
    </table>
  </xsl:template>


  <xsl:template match="@*" mode="table-copy">
    <xsl:copy-of select="."/>
  </xsl:template>


  <xsl:template match="@content-type" mode="table-copy"/>


  <!-- ============================================================= -->
  <!--  INLINE MISCELLANEOUS                                         -->
  <!-- ============================================================= -->
  <!--  Templates strictly for formatting follow; these are templates
        to handle various inline structures -->


  <xsl:template match="abbrev">
    <abbrev>
      <xsl:apply-templates/>
    </abbrev>
  </xsl:template>

  <xsl:template match="abbrev[normalize-space(string(@xlink:href))]">
    <a>
      <xsl:call-template name="assign-href"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="abbrev/def">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template
    match="
      p/address | license-p/address |
      named-content/p | styled-content/p">
    <xsl:apply-templates mode="inline"/>
  </xsl:template>


  <xsl:template match="address/*" mode="inline">
    <xsl:if test="preceding-sibling::*">
      <span class="generated">, </span>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="award-id">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="award-id[normalize-space(string(@rid))]">
    <a href="#{@rid}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match="break">
    <br class="br"/>
  </xsl:template>


  <xsl:template match="email">
    <a href="mailto:{.}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="uri[ext-link]">
    <xsl:apply-templates select="ext-link"/>
  </xsl:template>
  

  <xsl:template
    match="ext-link[not(matches(@specific-use, 'brightcove-(video|audio)'))] | uri | inline-supplementary-material">
    <xsl:choose>
      <xsl:when test="@ext-link-type='reference' and contains(base-uri(.),'/tmsworks/')">
        <div class="ref-wrapper">
          <a class="ref-popover" data-bs-trigger="hover" data-bs-toggle="popover"  target-id="{if(contains(@xlink:href,'bib_ref'))then(concat('ref_',substring-after(@xlink:href,'bib_ref'))) else(@xlink:href)}">
            <xsl:apply-templates/>
          </a>
          <div class="def-ref-content" id="{if(contains(@xlink:href,'bib_ref'))then(concat('ref_',substring-after(@xlink:href,'bib_ref'))) else(@xlink:href)}" reference-id="{if(contains(@xlink:href,'bib_ref'))then(substring-after(@xlink:href,'bib_ref')) else(substring-after(@xlink:href,'ref_'))}"></div>
        </div>
      </xsl:when>
      <xsl:when test="@ext-link-type = ('standard', 'chapter', 'section', 'sec', 'disp-formula', 'fig', 'table', 'fn') and contains(base-uri(.),'/tmsworks/')">
        <xsl:variable name="ext-link-type" select="@ext-link-type"/>
        <xsl:variable name="stdid" select="if(contains(@xlink:href,'#'))then(tokenize(@xlink:href,'#')[1])else('')"/>
        <xsl:variable name="stdsubid" select="if(contains(@xlink:href,'#'))then(tokenize(@xlink:href,'#')[2])else('')"/>
        <a>
          <xsl:attribute name="href"><xsl:choose>
            <xsl:when test="$ext-link-type = ('disp-formula', 'fig', 'table', 'fn')">
              <xsl:call-template name="standardexternallink">
                <xsl:with-param name="standard"><xsl:value-of select="$stdid"/></xsl:with-param>
                <xsl:with-param name="standardsubcontent"><xsl:value-of select="substring-before($stdsubid,'_')"/></xsl:with-param>
                <xsl:with-param name="subcontenttypeid"><xsl:value-of select="$stdsubid"/></xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ext-link-type = ('section','sec')">
              <xsl:call-template name="standardexternallink">
                <xsl:with-param name="standard"><xsl:value-of select="$stdid"/></xsl:with-param>
                <xsl:with-param name="standardsubcontent"><xsl:value-of select="substring-before($stdsubid,'.')"/></xsl:with-param>
                <xsl:with-param name="subcontenttypeid"><xsl:value-of select="$stdsubid"/></xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ext-link-type = ('chapter')">
              <xsl:call-template name="standardexternallink">
                <xsl:with-param name="standard"><xsl:value-of select="$stdid"/></xsl:with-param>
                <xsl:with-param name="standardsubcontent"><xsl:value-of select="$stdsubid"/></xsl:with-param>
                <xsl:with-param name="subcontenttypeid"><xsl:value-of select="''"/></xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ext-link-type = ('standard')">
              <xsl:call-template name="standardexternallink">
                <xsl:with-param name="standard"><xsl:value-of select="@xlink:href"/></xsl:with-param>
                <xsl:with-param name="standardsubcontent"><xsl:value-of select="''"/></xsl:with-param>
                <xsl:with-param name="subcontenttypeid"><xsl:value-of select="''"/></xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose></xsl:attribute>
          <xsl:attribute name="data-rid" select="@xlink:href"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a target="xrefwindow">
          <xsl:call-template name="assign-href"/>
          <xsl:call-template name="assign-id"/>
          <xsl:apply-templates/>
          <xsl:if test="not(normalize-space(string(.)))">
            <xsl:value-of select="@xlink:href"/>
          </xsl:if>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="ext-link[@specific-use eq 'brightcove-video']">
    <div class="videoobject" id="{generate-id(.)}">
      <div class="media video-content">
        <div class="player-container">
          <object classid="Single Video Player" class="play-in-place" data="{@xlink:href}"/>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="ext-link[@specific-use eq 'brightcove-audio']">
    <div class="audioobject" id="{generate-id(.)}">
      <div class="media audio-content">
        <div class="player-container">
          <object classid="Single Audio Player" class="play-in-place" data="{@xlink:href}"/>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="funding-source">
    <span class="funding-source">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="hr">
    <hr class="hr"/>
  </xsl:template>


  <!-- inline-graphic is handled above, with graphic -->


  <xsl:template match="inline-formula | chem-struct">
    <span class="{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="chem-struct-wrap/chem-struct | chem-struct-wrapper/chem-struct">
    <div class="{local-name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="milestone-start | milestone-end">
    <span class="{substring-after(local-name(),'milestone-')}">
      <xsl:comment>
        <xsl:value-of select="@rationale"/>
      </xsl:comment>
    </span>
  </xsl:template>


  <!-- don't need this - freebird-100 -->
  <!-- <xsl:template match="object-id">
    <span class="{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template> -->
  <xsl:template match="object-id"/>


  <!-- preformat is handled above -->

  <xsl:template match="sig">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="target">
    <xsl:choose>
      <xsl:when test="@target-type eq 'page'">
        <span class="page-number" data-page-number="{substring-after(@id,'pg')}" id="{@id}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="named-anchor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="styled-content">
    <span>
      <xsl:copy-of select="@style"/>
      <xsl:for-each select="@style-type">
        <xsl:attribute name="class">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="named-content">
    <span>
      <xsl:for-each select="@content-type">
        <xsl:attribute name="class">
          <xsl:value-of select="translate(., ' ', '-')"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  
  <xsl:template match="private-char">
    <span>
      <xsl:for-each select="@description">
        <xsl:attribute name="title">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <span class="generated">[Private character </span>
      <xsl:for-each select="@name">
        <xsl:text> </xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <span class="generated">]</span>
    </span>
  </xsl:template>


  <xsl:template match="glyph-data | glyph-ref">
    <span class="generated">(Glyph not rendered)</span>
  </xsl:template>


  <xsl:template match="related-article">
    <span class="generated">[Related article:] </span>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="related-object">
    <span class="generated">[Related object:] </span>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="xref[not(normalize-space(string(.)))]">
    <a href="#{@rid}">
      <xsl:apply-templates select="key('element-by-id', @rid)" mode="label-text">
        <xsl:with-param name="warning" select="true()"/>
      </xsl:apply-templates>
    </a>
  </xsl:template>

  <xsl:template match="def[@class='def-hide']">
    <div class="def-ref-content" id="{preceding-sibling::*[1][local-name()='xref'][@ref-type=('def','glossary')]/@rid}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="xref">
    <xsl:choose>
      <xsl:when test="@ref-type=('def', 'glossary') and contains(base-uri(.),'tmsworks')">
        <a>
          <xsl:attribute name="class">ref-popover</xsl:attribute>
          <xsl:attribute name="data-bs-trigger">hover</xsl:attribute>
          <xsl:attribute name="data-bs-toggle">popover</xsl:attribute>
          <xsl:attribute name="data-rid" select="@rid"/>
          <xsl:attribute name="target-id" select="@rid"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@ref-type=('bibref') and contains(base-uri(.),'tmsworks')">
        <div class="ref-wrapper">
          <a class="ref-popover" data-bs-trigger="hover" data-bs-toggle="popover"  target-id="{concat('ref_',substring-after(@rid,'bib_ref'))}">
            <xsl:apply-templates/>
          </a>
          <div class="def-ref-content" id="{concat('ref_',substring-after(@rid,'bib_ref'))}" reference-id="{substring-after(@rid,'bib_ref')}"></div>
        </div>
      </xsl:when>
      <xsl:when test="@ref-type=('sec','part','chapter','standard','disp-formula', 'fig', 'table', 'fn', 'list') and contains(base-uri(.),'tmsworks')">
        <xsl:variable name="ref-sec" select="/*/@id"/>
        <a>
          <xsl:attribute name="href"><xsl:choose>
            <xsl:when test="starts-with(@rid,$ref-sec)">
              <xsl:value-of select="if (@xlink:href) then
                @xlink:href
                else
                concat('#',@rid)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="tofindexternalchaperlink">
                <xsl:with-param name="linkid"><xsl:value-of select="@rid"/></xsl:with-param>
                <xsl:with-param name="section"><xsl:value-of select="if(@ref-type=('sec','part','disp-formula', 'fig', 'table', 'fn','list')) then(true()) else(false())"/></xsl:with-param>
                <xsl:with-param name="contenttype"><xsl:value-of select="@ref-type"/></xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose></xsl:attribute>
          <xsl:attribute name="data-rid" select="@rid"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"
            select="
            if (@xlink:href) then
            @xlink:href
            else
            concat('#', @rid)"/>
          <xsl:attribute name="data-rid" select="@rid"/>
          <!-- <xsl:attribute name="data">
        <xsl:if test="matches(@xlink:href,'atom://')">
	  <xsl:variable name="domain" select="http://atom-dev.highwire.org/sgrworks.atom"/>
	  <xsl:variable name="atom-id" select="substring-after(@xlink:ref,'sgrworks/')"/>
	  <xsl:variable name="stub" as="element(stub)">
            <stub l:ref-type="atom" l:ref="{$atom-id}"/>
          </xsl:variable>
	  <xsl:variable name="query" select="concat($domain,l:stub-to-query($stub))"/>
	  <xsl:sequence select="doc($query)/atom:feed/atom:entry/atom:link[@rel eq 'self']/@href"/>
	</xsl:if>
      </xsl:attribute> -->
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>



  <!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->


  <xsl:template match="bold">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>


  <xsl:template match="italic">
    <span class="italic">
      <xsl:apply-templates select="@* except (@toggle)"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="italic" mode="addr-line">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="monospace">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>


  <xsl:template match="overline">
    <span style="text-decoration: overline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="price">
    <span class="price">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="roman">
    <span style="font-style: normal">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sans-serif">
    <span style="font-family: sans-serif; font-size: 80%">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sc">
    <span style="font-variant: small-caps">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="strike">
    <span style="text-decoration: line-through">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>


  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>


  <xsl:template match="underline">
    <span style="text-decoration: underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  BACK MATTER                                                  -->
  <!-- ============================================================= -->


  <xsl:variable name="loose-footnotes"
    select="//fn[not(ancestor::front | parent::fn-group | ancestor::table-wrap)]"/>


  <xsl:template name="make-back">
    <xsl:apply-templates select="back"/>
    <xsl:if test="$loose-footnotes and not(back)">
      <!-- autogenerating a section for footnotes only if there is no
           back element, and if footnotes exist for it -->
      <xsl:call-template name="footnotes"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="back">
    <!-- content model for back: 
          (label?, title*, 
          (ack | app-group | bio | fn-group | glossary | ref-list |
           notes | sec)*) -->
    <xsl:if test="not(fn-group) and $loose-footnotes">
      <xsl:call-template name="footnotes"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template name="footnotes">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="$loose-footnotes" mode="footnote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- <xsl:template match="ack">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Acknowledgements</xsl:with-param>
    </xsl:call-template>
  </xsl:template> -->

  <xsl:template match="ack">
    <div class="ack">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="/ack/title"/>
  <!-- ignore title if ack is root element (springrsc3-526) -->
  <xsl:template match="ack/title[not(/ack)]">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="contrib-group[ancestor::ack]">
    <ul class="ack contrib-group">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="contrib[ancestor::ack]">
    <li class="ack contrib">
      <xsl:value-of select="name/surname"/>
      <xsl:if test="(name/surname/x)">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="not(name/surname/x)">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="name/given-names"/>
      <xsl:if test="degrees">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="degrees"/>
      </xsl:if>
      <xsl:if test="aff">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="aff"/>
      </xsl:if>
    </li>
  </xsl:template>
  <!-- comment below template based SF 01190101 ticket   -->
  <!--<xsl:template match="app-group"><xsl:comment></xsl:comment>
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Appendices</xsl:with-param>
    </xsl:call-template>
  </xsl:template>-->


  <xsl:template match="back/bio">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Biography</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="back/fn-group">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="back/glossary | back/gloss-group">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Glossary</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="back/ref-list">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">References</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="ref-list"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="back/notes">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="backmatter-section">
    <xsl:param name="generated-title"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <div class="back-section">
      <!-- <xsl:call-template name="named-anchor"/> -->
      <xsl:if test="not(title) and $generated-title">
        <xsl:choose>
          <!-- The level of title depends on whether the back matter itself
               has a title -->
          <xsl:when test="ancestor::back/title">
            <xsl:call-template name="section-title">
              <xsl:with-param name="contents" select="$generated-title"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="main-title">
              <xsl:with-param name="contents" select="$generated-title"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:copy-of select="$contents"/>
    </div>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  FOOTNOTES                                                    -->
  <!-- ============================================================= -->

  <xsl:template match="fn">
    <!-- Footnotes appearing outside fn-group
       generate cross-references to the footnote,
       which is displayed elsewhere -->
    <!-- Note the rules for displayed content: if any fn elements
       not inside an fn-group (the matched fn or any other) includes
       a label child, all footnotes are expected to have a label
       child. -->
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <a href="#{$id}">
      <xsl:apply-templates select="." mode="label-text">
        <xsl:with-param name="warning" select="true()"/>
      </xsl:apply-templates>
    </a>
  </xsl:template>

  <xsl:template match="
      fn-group/fn | table-wrap-foot/fn |
      table-wrap-foot/fn-group/fn">
    <xsl:apply-templates select="." mode="footnote"/>
  </xsl:template>


  <xsl:template match="fn" mode="footnote">
    <div class="footnote">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
<xsl:template match="fn/label" mode="tmsfnlabel">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="fn/p">
    <p>
      <xsl:call-template name="assign-id"/>
      <xsl:if test="not(preceding-sibling::p)">
        <xsl:choose>
          <xsl:when test="preceding-sibling::label">
            <xsl:choose>
              <xsl:when test="contains(base-uri(.),'/tmsworks')">
                <xsl:apply-templates select="../label" mode="tmsfnlabel"/><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <span class="label">
                  <xsl:value-of select="../label"/>
                  <xsl:text> </xsl:text>
                </span>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- drop an inline label text into the first p -->
            <xsl:apply-templates select="parent::fn" mode="label-text"/>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  MODE 'label-text'
	      Generates label text for elements and their cross-references -->
  <!-- ============================================================= -->
  <!--  This mode is to support auto-numbering and generating of
        labels for certain elements by the stylesheet.
  
        The logic is as follows: for any such element type, if a
        'label' element is ever present, it is expected always to be 
        present; automatic numbering is not performed on any elements
        of that type. For example, the presence of a 'label' element 
        in any 'fig' is taken to indicate that all figs should likewise
        be labeled, and any 'fig' without a label is supposed to be 
        unlabelled (and unnumbered). But if no 'fig' elements have 
        'label' children, labels with numbers are generated for all 
        figs in display.
        
        This logic applies to:
          app, boxed-text, chem-struct-wrap, disp-formula, fig, fn, 
          note, ref, statement, table-wrap.
        
        There is one exception in the case of fn elements, where
        the checking for labels (or for @symbol attributes in the
        case of this element) is performed only within its parent
        fn-group, or in the scope of all fn elements not in an
        fn-group, for fn elements appearing outside fn-group.
        
        In all cases, this logic can be altered simply by overwriting 
        templates in "label" mode for any of these elements.
        
        For other elements, a label is simply displayed if present,
        and auto-numbering is never performed.
        These elements include:
          (label appearing in line) aff, corresp, chem-struct, 
          element-citation, mixed-citation
          
          (label appearing as a block) abstract, ack, app-group, 
          author-notes, back, bio, def-list, disp-formula-group, 
          disp-quote, fn-group, glossary, graphic, kwd-group, 
          list, list-item, media, notes, ref-list, sec, 
          supplementary-material, table-wrap-group, 
          trans-abstract, verse-group -->


  <xsl:variable name="auto-label-app" select="false()"/>
  <xsl:variable name="auto-label-boxed-text" select="false()"/>
  <xsl:variable name="auto-label-chem-struct-wrap" select="false()"/>
  <xsl:variable name="auto-label-disp-formula" select="false()"/>
  <xsl:variable name="auto-label-fig" select="false()"/>
  <xsl:variable name="auto-label-ref" select="not(//ref[label])"/>
  <!-- ref elements are labeled unless any ref already has a label -->

  <xsl:variable name="auto-label-statement" select="false()"/>
  <xsl:variable name="auto-label-supplementary" select="false()"/>
  <xsl:variable name="auto-label-table-wrap" select="false()"/>

  <!--
  These variables assignments show how autolabeling can be 
  configured conditionally.
  For example: "label figures if no figures have labels" translates to
    "not(//fig[label])", which will resolve to Boolean true() when the set of
    all fig elements with labels is empty.
  
  <xsl:variable name="auto-label-app" select="not(//app[label])"/>
  <xsl:variable name="auto-label-boxed-text" select="not(//boxed-text[label])"/>
  <xsl:variable name="auto-label-chem-struct-wrap" select="not(//chem-struct-wrap[label])"/>
  <xsl:variable name="auto-label-disp-formula" select="not(//disp-formula[label])"/>
  <xsl:variable name="auto-label-fig" select="not(//fig[label])"/>
  <xsl:variable name="auto-label-ref" select="not(//ref[label])"/>
  <xsl:variable name="auto-label-statement" select="not(//statement[label])"/>
  <xsl:variable name="auto-label-supplementary"
    select="not(//supplementary-material[not(ancestor::front)][label])"/>
  <xsl:variable name="auto-label-table-wrap" select="not(//table-wrap[label])"/>
-->


  <xsl:template mode="label" match="*" name="block-label">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text">
        <!-- we place a warning for missing labels if this element is ever
             cross-referenced with an empty xref -->
        <xsl:with-param name="warning"
          select="boolean(key('xref-by-rid', @id)[not(normalize-space(string(.)))])"/>
      </xsl:apply-templates>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <xsl:choose>
        <xsl:when test="parent::fig or parent::table-wrap">
          <div class="label">
            <xsl:apply-templates/>
          </div>
        </xsl:when>
        <xsl:when test="name()='app'"></xsl:when><!-- SF 01190101 -->
        <xsl:otherwise>
          <span class="label">
            <xsl:copy-of select="$contents"/>
            <xsl:value-of select="following-sibling::*[1][self::x]"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <!-- <xsl:template mode="label" match="ref">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text"/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-/- we're already in a p -/->
        <span class="label">
          <xsl:copy-of select="$contents"/>
        </span>
    </xsl:if>
  </xsl:template> -->


  <xsl:template match="app" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-app"/>
      <xsl:with-param name="warning" select="$warning"/>
      <!--
      Pass in the desired label if a label is to be autogenerated  
      <xsl:with-param name="auto-text">
        <xsl:text>Appendix </xsl:text>
        <xsl:number format="A"/>
      </xsl:with-param>-->
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="boxed-text" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-boxed-text"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Box </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="disp-formula" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-disp-formula"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Formula </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="chem-struct-wrap | chem-struct-wrapper" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-chem-struct-wrap"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Formula (chemical) </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="fig" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-fig"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Figure </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="front//fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <!-- auto-number-fn is true only if (1) this fn is cross-referenced, and
         (2) there exists inside the front matter any fn elements with
         cross-references, but not labels or @symbols. -->
    <xsl:param name="auto-number-fn"
      select="
        boolean(key('xref-by-rid', parent::fn/@id)) and
        boolean(ancestor::front//fn[key('xref-by-rid', @id)][not(label | @symbol)])"/>
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:number level="any" count="fn" from="front" format="a"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="table-wrap//fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <xsl:param name="auto-number-fn"
      select="not(ancestor::table-wrap//fn/label | ancestor::table-wrap//fn/@symbol)"/>
<!--
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>[</xsl:text>
        <xsl:number level="any" count="fn" from="table-wrap" format="i"/>
        <xsl:text>]</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
-->
  </xsl:template>


  <xsl:template match="fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <!-- autonumber all fn elements outside fn-group,
         front matter and table-wrap only if none of them 
         have labels or @symbols (to keep numbering
         orderly) -->
    <xsl:variable name="in-scope-notes"
      select="
        ancestor::article//fn[not(parent::fn-group
        | ancestor::front
        | ancestor::table-wrap)]"/>
    <xsl:variable name="auto-number-fn"
      select="
        not($in-scope-notes/label |
        $in-scope-notes/@symbol)"/>
    <!-- 
      HWPTRIAGE-4510: sgrworks doesn't want [#] auto labels 
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>[</xsl:text>
        <xsl:number level="any" count="fn[not(ancestor::front)]"
          from="article | sub-article | response"/>
        <xsl:text>]</xsl:text>
        <xsl:apply-templates select="@fn-type"/>
      </xsl:with-param>
    </xsl:call-template> -->
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'abbr']" priority="2">
    <span class="generated"> Abbreviation</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'com']" priority="2">
    <span class="generated"> Communicated by</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'con']" priority="2">
    <span class="generated"> Contributed by</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'conflict']" priority="2">
    <span class="generated"> Conflicts of interest</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'corresp']" priority="2">
    <span class="generated"> Corresponding author</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'current-aff']" priority="2">
    <span class="generated"> Current affiliation</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'deceased']" priority="2">
    <span class="generated"> Deceased</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'edited-by']" priority="2">
    <span class="generated"> Edited by</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'equal']" priority="2">
    <span class="generated"> Equal contributor</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'financial-disclosure']" priority="2">
    <span class="generated"> Financial disclosure</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'on-leave']" priority="2">
    <span class="generated"> On leave</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'other']" priority="2"/>

  <xsl:template match="fn/@fn-type[. = 'participating-researchers']" priority="2">
    <span class="generated"> Participating researcher</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'present-address']" priority="2">
    <span class="generated"> Current address</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'presented-at']" priority="2">
    <span class="generated"> Presented at</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'presented-by']" priority="2">
    <span class="generated"> Presented by</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'previously-at']" priority="2">
    <span class="generated"> Previously at</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'study-group-members']" priority="2">
    <span class="generated"> Study group member</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'supplementary-material']" priority="2">
    <span class="generated"> Supplementary material</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type[. = 'supported-by']" priority="2">
    <span class="generated"> Supported by</span>
  </xsl:template>

  <xsl:template match="fn/@fn-type"/>


  <!-- <xsl:template match="ref" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-/- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -/->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-ref"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template> -->


  <xsl:template match="statement" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-statement"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Statement </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="supplementary-material" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-supplementary"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Supplementary Material </xsl:text>
        <xsl:number level="any" format="A" count="supplementary-material[not(ancestor::front)]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="table-wrap" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-table-wrap"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Table </xsl:text>
        <xsl:number level="any" format="I"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="*" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="warning" select="$warning"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="label" mode="label-text">
    <xsl:apply-templates mode="inline-label-text"/>
  </xsl:template>


  <!-- <xsl:template match="text()" mode="inline-label-text">
    <!-/- when displaying labels, space characters become non-breaking spaces -/->
    <xsl:value-of select="translate(normalize-space(string(.)),' &#xA;&#x9;','&#xA0;&#xA0;&#xA0;')"/>
  </xsl:template> -->


  <!-- ============================================================= -->
  <!--  Writing a name                                               -->
  <!-- ============================================================= -->

  <!-- Called when displaying structured names in metadata         -->

  <xsl:template match="name">
    <span class="name">
      <xsl:apply-templates select="prefix" mode="inline-name"/>
      <xsl:apply-templates select="surname[../@name-style = 'eastern']" mode="inline-name"/>
      <xsl:apply-templates select="surname[not(../@name-style = 'eastern')]" mode="inline-name"/>
      <xsl:apply-templates select="given-names" mode="inline-name"/>
      <!-- <xsl:apply-templates select="surname[not(../@name-style='eastern')]"
      mode="inline-name"/> -->
      <xsl:apply-templates select="suffix" mode="inline-name"/>
    </span>
  </xsl:template>


  <xsl:template match="prefix" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../surname | ../given-names | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="given-names" mode="inline-name">
    <xsl:apply-templates/>
    <!-- <xsl:if test="../surname[not(../@name-style='eastern')] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if> -->
    <xsl:if test="../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
    <!--    <xsl:if test="x[matches(., '\.')]">
      <xsl:value-of select="x"/>
    </xsl:if>
 -->
  </xsl:template>


  <xsl:template match="contrib/name/surname" mode="inline-name">
    <xsl:apply-templates/>
    <!-- <xsl:if test="../given-names[../@name-style = 'eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
    -->
    <xsl:if test="../given-names[not(../@name-style = 'eastern')] | ../suffix">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="surname" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../given-names[../@name-style = 'eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="../given-names[not(../@name-style = 'eastern')] | ../suffix">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="suffix" mode="inline-name">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- string-name elements are written as is -->

  <xsl:template match="string-name">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="string-name[not(parent::mixed-citation)]/*">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  UTILITY TEMPLATES                                           -->
  <!-- ============================================================= -->


  <xsl:template name="append-pub-type">
    <!-- adds a value mapped for @pub-type, enclosed in parenthesis,
         to a string -->
    <xsl:for-each select="@pub-type">
      <xsl:text> (</xsl:text>
      <span class="data">
        <xsl:choose>
          <xsl:when test=". = 'epub'">electronic</xsl:when>
          <xsl:when test=". = 'ppub'">print</xsl:when>
          <xsl:when test=". = 'epub-ppub'">print and electronic</xsl:when>
          <xsl:when test=". = 'epreprint'">electronic preprint</xsl:when>
          <xsl:when test=". = 'ppreprint'">print preprint</xsl:when>
          <xsl:when test=". = 'ecorrected'">corrected, electronic</xsl:when>
          <xsl:when test=". = 'pcorrected'">corrected, print</xsl:when>
          <xsl:when test=". = 'eretracted'">retracted, electronic</xsl:when>
          <xsl:when test=". = 'pretracted'">retracted, print</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <xsl:text>)</xsl:text>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="metadata-labeled-entry">
    <xsl:param name="label"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:if test="normalize-space(string($label))">
          <span class="generated">
            <xsl:copy-of select="$label"/>
            <xsl:text>: </xsl:text>
          </span>
        </xsl:if>
        <xsl:copy-of select="$contents"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="metadata-entry">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <p class="metadata-entry">
      <xsl:copy-of select="$contents"/>
    </p>
  </xsl:template>


  <xsl:template name="metadata-area">
    <xsl:param name="label"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <div class="metadata-area">
      <xsl:if test="normalize-space(string($label))">
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">
            <xsl:copy-of select="$label"/>
          </xsl:with-param>
          <xsl:with-param name="contents"/>
        </xsl:call-template>
      </xsl:if>
      <div class="metadata-chunk">
        <xsl:copy-of select="$contents"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="make-label-text">
    <xsl:param name="auto" select="false()"/>
    <xsl:param name="warning" select="false()"/>
    <xsl:param name="auto-text"/>
    <xsl:choose>
      <xsl:when test="$auto">
        <span class="generated">
          <xsl:copy-of select="$auto-text"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="label-text" select="label | @symbol"/>
        <xsl:if test="$warning and not(label | @symbol)">
          <span class="warning">
            <xsl:text>{ label</xsl:text>
            <xsl:if test="self::fn"> (or @symbol)</xsl:if>
            <xsl:text> needed for </xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:for-each select="@id">
              <xsl:text>[@id='</xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>']</xsl:text>
            </xsl:for-each>
            <xsl:text> }</xsl:text>
          </span>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="assign-id">
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <xsl:attribute name="id">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template name="assign-src">
    <xsl:for-each select="@xlink:href">
      <xsl:attribute name="src">
        <xsl:if test="../../object-id[@hwp:sub-type eq 'pisa']">
          <xsl:text>sass://</xsl:text>
          <xsl:value-of select="translate(../../object-id[@hwp:sub-type eq 'pisa'], ';', '/')"/>
          <xsl:value-of select="../../object-id[@hwp:sub-type eq 'slug']"/>
        </xsl:if>
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="assign-href">
    <xsl:for-each select="@xlink:href">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="named-anchor">
    <!-- generates an HTML named anchor -->
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@id">
          <!-- if we have an @id, we use it -->
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:when
          test="
            not(preceding-sibling::*) and
            (parent::alternatives | parent::name-alternatives |
            parent::citation-alternatives | parent::collab-alternatives |
            parent::aff-alternatives)/@id">
          <!-- if not, and we are first among our siblings inside one of
               several 'alternatives' wrappers, we use its @id if available -->
          <xsl:value-of
            select="
              (parent::alternatives | parent::name-alternatives |
              parent::citation-alternatives | parent::collab-alternatives |
              parent::aff-alternatives)/@id"
          />
        </xsl:when>
        <xsl:otherwise>
          <!-- otherwise we simply generate an ID -->
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- <a id="{$id}">
      <xsl:comment> named anchor </xsl:comment>
    </a> -->
    <span id="{$id}"/>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  id mode                                                      -->
  <!-- ============================================================= -->
  <!-- An id can be derived for any element. If an @id is given,
     it is presumed unique and copied. If not, one is generated.   -->

  <xsl:template match="*" mode="id">
    <xsl:value-of select="@id"/>
    <xsl:if test="not(@id)">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="article | sub-article | response" mode="id">
    <xsl:value-of select="@id"/>
    <xsl:if test="not(@id)">
      <xsl:value-of select="local-name()"/>
      <xsl:number from="article" level="multiple" count="article | sub-article | response"
        format="1-1"/>
    </xsl:if>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  "format-date"                                                -->
  <!-- ============================================================= -->
  <!-- Maps a structured date element to a string -->

  <xsl:template name="format-date">
    <!-- formats date in DD Month YYYY format -->
    <!-- context must be 'date', with content model:
         (((day?, month?) | season)?, year) -->
    <xsl:for-each select="day | month | season">
      <xsl:apply-templates select="." mode="map"/>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:apply-templates select="year" mode="map"/>
  </xsl:template>


  <xsl:template match="day | season | year" mode="map">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="month" mode="map">
    <!-- maps numeric values to English months -->
    <xsl:choose>
      <xsl:when test="number() = 1">January</xsl:when>
      <xsl:when test="number() = 2">February</xsl:when>
      <xsl:when test="number() = 3">March</xsl:when>
      <xsl:when test="number() = 4">April</xsl:when>
      <xsl:when test="number() = 5">May</xsl:when>
      <xsl:when test="number() = 6">June</xsl:when>
      <xsl:when test="number() = 7">July</xsl:when>
      <xsl:when test="number() = 8">August</xsl:when>
      <xsl:when test="number() = 9">September</xsl:when>
      <xsl:when test="number() = 10">October</xsl:when>
      <xsl:when test="number() = 11">November</xsl:when>
      <xsl:when test="number() = 12">December</xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  "author-string" writes authors' names in sequence            -->
  <!-- ============================================================= -->

  <xsl:template name="author-string">
    <xsl:variable name="all-contribs"
      select="
        /article/front/article-meta/contrib-group/contrib/name/surname |
        /article/front/article-meta/contrib-group/contrib/collab"/>
    <xsl:for-each select="$all-contribs">
      <xsl:if test="count($all-contribs) &gt; 1">
        <xsl:if test="position() &gt; 1">
          <xsl:if test="count($all-contribs) &gt; 2">,</xsl:if>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="position() = count($all-contribs)">and </xsl:if>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  Footer branding                                              -->
  <!-- ============================================================= -->

  <xsl:template name="footer-branding">
    <hr class="part-rule"/>
    <div class="branding">
      <p>
        <xsl:text>This display is generated from </xsl:text>
        <xsl:text>NISO JATS XML with </xsl:text>
        <b>
          <xsl:value-of select="$transform"/>
        </b>
        <xsl:text>. The XSLT engine is </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
        <xsl:text>.</xsl:text>
      </p>
    </div>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  Utility templates for generating warnings and reports        -->
  <!-- ============================================================= -->

  <!--  <xsl:template name="report-warning">
    <xsl:param name="when" select="false()"/>
    <xsl:param name="msg"/>
    <xsl:if test="$verbose and $when">
      <xsl:message>
        <xsl:copy-of select="$msg"/>
      </xsl:message>
    </xsl:if>
  </xsl:template>-->


  <!--<xsl:template name="list-elements">
    <xsl:param name="elements" select="/.."/>
    <xsl:if test="$elements">
      <ol>
        <xsl:for-each select="*">
          <li>
            <xsl:apply-templates select="." mode="element-pattern"/>
          </li>
        </xsl:for-each>
      </ol>
    </xsl:if>
  </xsl:template>-->


  <xsl:template match="*" mode="pattern">
    <xsl:value-of select="name(.)"/>
    <xsl:for-each select="@*">
      <xsl:text>[@</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>='</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>']</xsl:text>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="node()" mode="xpath">
    <xsl:apply-templates mode="xpath" select=".."/>
    <xsl:apply-templates mode="xpath-step" select="."/>
  </xsl:template>


  <xsl:template match="/" mode="xpath"/>


  <xsl:template match="*" mode="xpath-step">
    <xsl:variable name="name" select="name(.)"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:if test="count(../*[name(.) = $name]) > 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::*[name(.) = $name])"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@*" mode="xpath-step">
    <xsl:text>/@</xsl:text>
    <xsl:value-of select="name(.)"/>
  </xsl:template>


  <xsl:template match="comment()" mode="xpath-step">
    <xsl:text>/comment()</xsl:text>
    <xsl:if test="count(../comment()) > 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::comment())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="processing-instruction()" mode="xpath-step">
    <xsl:text>/processing-instruction()</xsl:text>
    <xsl:if test="count(../processing-instruction()) > 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::processing-instruction())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="text()" mode="xpath-step">
    <xsl:text>/text()</xsl:text>
    <xsl:if test="count(../text()) > 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::text())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- bits-specific stuff added by HW -->

  <xsl:template match="dedication">
    <div class="dedication">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="foreword">
    <div class="foreword">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="front-matter-part">
    <div>
      <xsl:attribute name="class"
        select="concat('front-matter-part', ' ', lower-case(@book-part-type))"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="preface">
    <div class="preface">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="index">
    <div class="index">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="index-title-group/title">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="index-entry">
    <div class="index-entry">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="term[parent::index-entry]">
    <span class="term">
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::x">
        <xsl:value-of select="following-sibling::x"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="nav-pointer-group">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="nav-pointer">
    <span rid="{@rid}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="question-wrap-group">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="question-wrap">
    <div class="question" id="{question/@id}">
      <xsl:if test="question/p or question/option or answer-set">
        <div class="question-text">
          <xsl:apply-templates select="question/label"/>
          <xsl:apply-templates select="question/p"/>
          <xsl:if test="question/option">
            <ol class="answers-list">
              <xsl:apply-templates select="question/option"/>
            </ol>
          </xsl:if>
        </div>
        <xsl:apply-templates select="answer-set"/>
      </xsl:if>
      <!-- per HWPTRIAGE-4446, sometimes answers tagged within question, sometimes outside -->
      <xsl:if test="question/answer">
        <xsl:apply-templates select="question/answer"/>
      </xsl:if>
      <xsl:if test="answer">
        <xsl:apply-templates select="answer"/>
      </xsl:if>      
    </div>
  </xsl:template>

  <xsl:template match="question/label">
    <div class="questionid">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="question/p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="option">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="option/label">
    <span class="answer-label">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="option/p">
    <xsl:text> </xsl:text>
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="answer-set">
    <div class="answer-text">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="answer">
    <xsl:choose>
      <xsl:when test="@pointer-to-question = //question/@id">
        <button class="btn showhide-button collapsed" data-toggle="collapse"
          data-target="#{@pointer-to-question}-answer" aria-expanded="false"
          >&#xA0;answer&#xA0;</button>
        <div class="answer collapse" id="{@pointer-to-question}-answer" aria-expanded="false">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="answer" id="{@pointer-to-question}-answer" aria-expanded="false">
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="answer/label">
    <div class="answer-label">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- <xsl:template match="answer/p[not(normalize-space(text()))][not(node())]"/> -->
  <xsl:template match="p[parent::answer][not(normalize-space(text()))][not(node())]"/>

  <!-- <xsl:template match="answer/p[normalize-space(text())][node()]"> -->
  <xsl:template match="p[parent::answer][normalize-space(text())][node()]">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="book-app">
    <div class="appendix">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:attribute name="id" select="."/>
  </xsl:template>

  <xsl:template match="book-id"/>
  <xsl:template match="book-part-id"/>
  <xsl:template match="contrib-group"/>
  <!-- <xsl:template match="front-matter-part"/> -->
  <xsl:template match="isbn"/>
  <xsl:template match="pub-date"/>
  <xsl:template match="publisher"/>
  <xsl:template match="subj-group"/>
  <xsl:template match="toc"/>
  <!--<xsl:template match="x"/>-->


  <!-- ============================================================= -->
  <!--  End stylesheet                                               -->
  <!-- ============================================================= -->
  <xsl:template name="standardexternallink">
    <xsl:param name="standard"/>
    <xsl:param name="standardsubcontent"/>
    <xsl:param name="subcontenttypeid"/>
    <xsl:variable name="atomurilist" select="doc(concat('http://atom-dev.highwire.org/svc.atom?query-form=search&amp;canned-query=/hwc/list-resources.xqy&amp;type=pattern&amp;pattern=/tmsworks/standard/',$standard,'*.atom'))"/>
    <xsl:choose>
    <xsl:when test="$standard != '' and $standardsubcontent != '' and $subcontenttypeid != ''">
      <xsl:for-each select="tokenize($atomurilist,'\n')">
        <xsl:if test="ends-with(.,concat($subcontenttypeid,'.atom'))">
          <xsl:choose>
            <xsl:when test="contains(.,'/402-16/part/part') or contains(.,'/402-16/front-matter/') or contains(.,'/402-16/back-matter/')">
              <xsl:value-of select="if(contains(.,'commentary-section')) then(concat(replace(substring-before(.,'/commentary-section/'),'tmsworks','content'),'#',$subcontenttypeid)) else(concat(replace(substring-before(.,'/standard-section/'),'tmsworks','content'),'#',$subcontenttypeid))"/>
            </xsl:when>
            <xsl:when test="contains(.,'/602-16/')">
              <xsl:value-of select="if(contains(.,'commentary-section')) then(concat(replace(substring-before(.,'/commentary-section/'),'tmsworks','content'),'#',$subcontenttypeid)) else(concat(replace(substring-before(.,'/standard-section/'),'tmsworks','content'),'#',$subcontenttypeid))"/>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
      <xsl:when test="$standard != '' and $standardsubcontent != '' and $subcontenttypeid = ''">
        <xsl:for-each select="tokenize($atomurilist,'\n')">
          <xsl:if test="ends-with(.,concat($standardsubcontent,'.atom'))">
            <xsl:choose>
              <xsl:when test="contains(.,'/402-16/part/part') or contains(.,'/402-16/front-matter/') or contains(.,'/402-16/back-matter/')">
                <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
              </xsl:when>
              <xsl:when test="contains(.,'/602-16/')">
                <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$standard != '' and $standardsubcontent = '' and $subcontenttypeid = ''">
        <xsl:for-each select="tokenize($atomurilist,'\n')">
          <xsl:if test="ends-with(.,concat($standard,'.atom'))">
            <xsl:choose>
              <xsl:when test="contains(.,'/402-16')">
                <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
              </xsl:when>
              <xsl:when test="contains(.,'/602-16')">
                <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    <xsl:otherwise>
      
    </xsl:otherwise>
  </xsl:choose>
    
  </xsl:template>
  <xsl:template name="tofindexternalchaperlink">
    <xsl:param name="linkid"/>
    <xsl:param name="section" as="xs:boolean"/>
    <xsl:param name="contenttype" as="xs:string"/>
    <xsl:variable name="fig_tbl_fn_eqn" select="if(contains($linkid,'_')) then(substring-before($linkid,'_')) else($linkid)"/>
    <xsl:variable name="part-base-uri" select="base-uri()"/>
    <xsl:choose>
      <xsl:when test="$section eq true()">
        <xsl:for-each select="tokenize($queryurl,'\n')">
          <xsl:if test="if($contenttype = 'part') then(ends-with(.,concat(replace($fig_tbl_fn_eqn,'p','part'),'.atom'))) else(ends-with(.,concat($fig_tbl_fn_eqn,'.atom')))">
            <xsl:choose>
              <xsl:when test="$contenttype = 'part'">
                <xsl:variable name="part-uri" select="resolve-uri(.,$part-base-uri)"/>
                <xsl:variable name="part-doc" select="document($part-uri)//atom:link[@rel='http://schema.highwire.org/Compound#child' and @c:role='http://schema.highwire.org/ItemSet/Item'][1]/@href"/>
                <xsl:value-of select="replace(substring-before($part-doc,'.atom'),'tmsworks','content')"/>
                <!--<xsl:value-of select="."/>-->              
              </xsl:when>
              <xsl:when test="contains(.,'/402-16/part/part') or contains(.,'/402-16/front-matter/') or contains(.,'/402-16/back-matter/')">
                <xsl:value-of select="if($contenttype = ('disp-formula', 'fig', 'table', 'fn','list')) then(concat(replace(substring-before(.,'.atom'),'tmsworks','content'),'#',$linkid)) else(if(contains(.,'commentary-section')) then(concat(replace(substring-before(.,'/commentary-section/'),'tmsworks','content'),'#',$linkid)) else(concat(replace(substring-before(.,'/standard-section/'),'tmsworks','content'),'#',$linkid)))"/>
              </xsl:when>
              <xsl:when test="contains(.,'/602-16/')">
                <xsl:value-of select="if($contenttype = ('disp-formula', 'fig', 'table', 'fn','list')) then(concat(replace(substring-before(.,'.atom'),'tmsworks','content'),'#',$linkid)) else(if(contains(.,'commentary-section')) then(concat(replace(substring-before(.,'/commentary-section/'),'tmsworks','content'),'#',$linkid)) else(concat(replace(substring-before(.,'/standard-section/'),'tmsworks','content'),'#',$linkid)))"/>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="tokenize($queryurl,'\n')">
          <xsl:if test="if(starts-with($linkid,'p')) then(ends-with(.,concat(replace($linkid,'p','part'),'.atom'))) else(ends-with(.,concat($linkid,'.atom')))">
           <xsl:choose>
             <xsl:when test="contains(.,'/402-16/part/part') or contains(.,'/402-16/front-matter/') or contains(.,'/402-16/back-matter/')">
               <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
             </xsl:when>
             <xsl:when test="contains(.,'/602-16/')">
               <xsl:value-of select="replace(substring-before(.,'.atom'),'tmsworks','content')"/>
             </xsl:when>
           </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmsresourcelink">
    <xsl:param name="resourceid"/>
    <xsl:for-each select="tokenize($queryurl,'\n')">
      <xsl:if test="if(starts-with($resourceid,'p')) then(ends-with(.,concat(replace($resourceid,'p','part'),'.atom'))) else(ends-with(.,concat($resourceid,'.atom')))">
        <xsl:value-of select="if(contains(.,'/602-16/')) then(.) else(if(contains(.,'/402-16/part/part') or contains(.,'/402-16/front-matter/') or contains(.,'/402-16/back-matter/')) then(.) else())"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
