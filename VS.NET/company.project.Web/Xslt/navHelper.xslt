<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:umb="urn:umbraco.library"
    exclude-result-prefixes="umb"
>

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

  <xsl:param name="currentPage" />

  <xsl:variable name="mode" select="/macro/mode" />
  <xsl:variable name="propertyAlias" select="/macro/property" />

  <xsl:template match="/">
    <!-- Use The MEXAH, Luke ... -->
    <xsl:apply-templates select="$currentPage[$mode = 'mainnav']" mode="navigation.main" />
    <xsl:apply-templates select="$currentPage[$mode = 'subnav']" mode="navigation.sub" />
    <xsl:apply-templates select="$currentPage[$mode = 'breadcrumb']" mode="navigation.crumb" />
    <xsl:apply-templates select="$currentPage[$mode = 'sitemap']" mode="navigation.map" />
    <!-- STOP, Picker Time! -->
    <xsl:apply-templates select="$currentPage[$mode = 'multinode']/ancestor-or-self::*/*[name() = $propertyAlias]/*" mode="multipicker" />
  </xsl:template>
  
  <!-- Handle Multinode Tree Pickers -->
  <xsl:template match="* [@isDoc]">
    <xsl:apply-templates mode="navigation.link" select="." />
  </xsl:template>

  <xsl:include href="helpers/_MultiPicker.xslt" />
  <xsl:include href="helpers/_Navigation.xslt" />

  <!-- Project Specific Templates -->
  <!--
  <xsl:include href="templates/Navigation.xslt" />
  -->

</xsl:stylesheet>