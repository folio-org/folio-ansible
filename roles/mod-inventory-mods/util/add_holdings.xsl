<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:h="http://copac.ac.uk/schemas/holdings/v1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:math="http://exslt.org/math"
                extension-element-prefixes="math"
                exclude-result-prefixes="xsl">

  <!-- add holdings to a MODS file for FOLIO inventory ingest -->

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <!-- create mods_records wrapper -->
    <mods_records>
      <xsl:apply-templates select="mods:mods|*/mods:mods"/>
    </mods_records>
  </xsl:template>

  <xsl:template match="mods:mods">
    <mods:mods>
      <xsl:if test="@version != ''">
        <xsl:attribute name="version"><xsl:value-of select="@version"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*" mode="copy"/>
      <!-- add 1-5 locations: cute, but unnecessary, ingest only creates one item -->
      <!-- <xsl:call-template name="add_locations"> -->
      <!--   <xsl:with-param name="count"><xsl:value-of select="(floor(math:random()*10) div 2) + 1"/></xsl:with-param> -->
      <!-- </xsl:call-template> -->
      <xsl:call-template name="add_locations">
        <xsl:with-param name="count">1</xsl:with-param>
      </xsl:call-template>
    </mods:mods>
  </xsl:template>

  <!-- strip unwanted namespace nodes when copying (if possible) -->
  <xsl:template match="*" mode="copy">
    <xsl:element name="mods:{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()" mode="copy" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|text()|comment()" mode="copy">
    <xsl:copy/>
  </xsl:template>

  <!-- create mods:location nodes -->
  <xsl:template name="add_locations">
    <xsl:param name="i" select="1"/>
    <xsl:param name="count"/>
    <xsl:if test="$i &lt;= $count">
      <mods:location>
        <mods:holdingExternal>
          <h:localHolds>
            <h:org displayName="DIKU Library"/>
            <h:objId><xsl:value-of select="format-number(floor(math:random()*10000000000000),'0000000000000')"/></h:objId>
          </h:localHolds>
        </mods:holdingExternal>
      </mods:location>
      <xsl:call-template name="add_locations">
        <xsl:with-param name="i"><xsl:value-of select="$i + 1"/></xsl:with-param>
        <xsl:with-param name="count"><xsl:value-of select="$count"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
