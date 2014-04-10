<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY MaxLevel "5">
	<!ENTITY Page "*[@isDoc and @level &lt;= &MaxLevel;] [not(self::FormPage | self::ThankYouPage )]">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library" xmlns:msxml="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="umb xsl msxml" 
	extension-element-prefixes="umb">

	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" version="1.0" encoding="utf-8" />
	<xsl:param name="currentPage" />

	<!-- SEO Titles for Excel Analysis (via import XML), Laurie 2014 -->
	<!-- Excel hints and tips! http://www.mrexcel.com/articles/using-xml-in-excel.php -->
	<xsl:variable name="urlPrefix" select="concat('http://' , umb:RequestServerVariables('HTTP_HOST'))" />


	<xsl:template match="/">
		<!-- To Import into Excel, everything must be inside one containing element -->
		<Results>
			<!-- Process the homepage using the 'sitemap-entry' template -->
			<xsl:apply-templates select="$currentPage/ancestor-or-self::*[@level=1 and @isDoc and not(sitemapNoIndex = 1)]" mode="sitemap-entry">
				<xsl:with-param name="recurse" select="false()" />
			</xsl:apply-templates>
	
			<xsl:call-template name="renderSitemapArea">
				<xsl:with-param name="parent" select="$currentPage/ancestor-or-self::*[@level=1 and @isDoc]"/>
			</xsl:call-template>
		</Results>
	</xsl:template>

	<xsl:template name="renderSitemapArea">
		<xsl:param name="parent"/>
		<xsl:if test="umb:IsProtected($parent/@id, $parent/@path) = 0 or (umb:IsProtected($parent/@id, $parent/@path) = 1 and umb:IsLoggedOn() = 1) and @level &lt;= &MaxLevel;">
			<xsl:for-each select="$parent/&Page;">
				<xsl:variable name="nodeAncestorOrSelf" select="node()/ancestor-or-self::*[@level = 2 and @isDoc]/@nodeName"/>
				<xsl:apply-templates select="self::*" mode="sitemap-entry" /> 
			</xsl:for-each>
		</xsl:if>
	</xsl:template>


	<!-- Templates for repeative tasks -->
	<!-- [1] Sitemap entry -->
	<xsl:template match="* [@isDoc]" mode="sitemap-entry">
		<xsl:param name="recurse" select="true()" />
		<url>
			<dt><xsl:value-of select="local-name(.)" /></dt>
			<loc>
				<xsl:apply-templates select="@id" />
			</loc>
			<lastmod><xsl:value-of select="@updateDate" />+00:00</lastmod>
			<meta>
				<metaTitle><xsl:value-of select="metaTitle" /></metaTitle>
				<metaDescription><xsl:value-of select="metaDescription" /></metaDescription>
				<canonicalUrl><xsl:value-of select="canonicalUrl" /></canonicalUrl>
			</meta>
			<content>
				<pageTitle>
					<xsl:value-of select="contentHeader | @nodeName[not(./contentHeader)] [1]" />
				</pageTitle>
			</content>
		</url>
		<!-- Enless 'recurse' is false, let's keep adding enteries -->
		<xsl:if test="$recurse != false() and count(./* [@isDoc and @level &lt;= &MaxLevel;]) &gt; 0">
			<xsl:call-template name="renderSitemapArea">
				<xsl:with-param name="parent" select="."/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- [2] URL's -->
	<xsl:template match="@id">
		<xsl:value-of select="$urlPrefix" />
    <!-- Not quite sure what this does? Does it remove the trailing slash from any root nodes, e.g. domain.com -->
		<xsl:choose>
			<!-- The only data that is avalible is @id, so we access it using '.', meaning this or self -->
			<xsl:when test="substring(umb:NiceUrl(.) , string-length(umb:NiceUrl(.)) , 1) = '/'">
				<xsl:value-of select="substring(umb:NiceUrl(.) , 0 , string-length(umb:NiceUrl(.)))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umb:NiceUrl(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
</xsl:stylesheet>