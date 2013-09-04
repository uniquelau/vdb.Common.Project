<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!-- You can change this to suit your environment -->
	<!ENTITY subPages "*[@isDoc][not(@template = 0) and not(umbracoNaviHide = 1)]">
]>
<?umbraco-package XSLT Helpers v0.8.1 - NavigationHelper v1.1?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" xmlns:freeze="http://xmlns.greystate.dk/2012/freezer" version="1.0" exclude-result-prefixes="umb freeze">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- :: Configuration :: -->
	<!-- CSS class for selected/active items -->
	<xsl:variable name="selectedClass" select="'selected'"/>
	
	<!-- Top level to output -->
	<xsl:variable name="topLevel" select="2"/>
	
<!-- :: Templates :: -->
	<!-- Main navigation -->
	<xsl:template match="*" mode="navigation.main">
		<!-- Find the top-level node -->
		<xsl:variable name="siteRoot" select="ancestor-or-self::*[@level = $topLevel - 1]"/>
		
		<xsl:apply-templates mode="navigation.link" select="$siteRoot/&subPages;"/>
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="navigation.sub">
		<xsl:param name="levels" select="concat($topLevel, '-', 99)"/>
		<xsl:variable name="topLevelNode" select="ancestor-or-self::*[@level = $topLevel]"/>
		<xsl:variable name="currentSection" select="($topLevelNode | ancestor-or-self::*[@level = substring-before($levels, '-') - 1])[last()]"/>

		<!-- No output on the home node -->
		<xsl:if test="not(generate-id($currentSection) = generate-id(ancestor-or-self::*[@level = $topLevel - 1]))">
			<xsl:apply-templates mode="navigation.link" select="$currentSection/&subPages;">
				<xsl:with-param name="endLevel" select="substring-after($levels, '-')"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="navigation.crumb">
		<xsl:apply-templates select="ancestor-or-self::*[@level &gt;= $topLevel]" mode="navigation.link">
			<xsl:with-param name="highlight" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="navigation.map">
		<xsl:apply-templates select="." mode="navigation.link">
			<xsl:with-param name="recurse" select="true()"/>
			<xsl:with-param name="highlight" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Generic template for nav items -->
	<xsl:template match="*" mode="navigation.link">
		<xsl:param name="endLevel" select="0"/>
		<xsl:param name="highlight" select="true()"/>
		<xsl:param name="recurse"/>
		<xsl:variable name="hasCurrentPageInBranch" select="descendant-or-self::*[@id = $currentPage/@id]"/>
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="$highlight and $hasCurrentPageInBranch">
        <xsl:attribute name="class"><xsl:value-of select="$selectedClass"/></xsl:attribute>
        <!-- Add ancestor class, if this page isn't current -->
        <xsl:if test="@id != $currentPage/@id"> ancestor</xsl:if>
      </xsl:if>

			<!-- Generate link -->
			<a href="{umb:NiceUrl(@id)}" title="{@nodeName}">
        <!-- If Redirect node, set URL to the umbraco301MovedPermanently property -->
        <xsl:if test="self::Redirect">
          <xsl:attribute name="href">
            <xsl:value-of select="umbraco301MovedPermanently" />
          </xsl:attribute>
          <xsl:attribute name="target">_Blank</xsl:attribute>
        </xsl:if>
        <!-- If the page 'redirects', show in the menu, but don't link anywhere -->
        <!-- e.g. this is a container page, therefore it should be redirected somewhere sensible -->
        <xsl:if test="redirect !=''"><xsl:attribute name="href">#</xsl:attribute></xsl:if>
        <xsl:value-of select="(@nodeName[not(normalize-space(../navTitle))] | navTitle)[1]"/>
			</a>

			<!-- Recurse if needed (and there are pages to show) -->
			<xsl:if test="($recurse or (@level &lt; $endLevel and $hasCurrentPageInBranch)) and &subPages;">
				<ul>
					<xsl:apply-templates mode="navigation.link" select="&subPages;">
						<xsl:with-param name="recurse" select="$recurse"/>
						<xsl:with-param name="endLevel" select="$endLevel"/>
						<xsl:with-param name="highlight" select="$highlight"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>
