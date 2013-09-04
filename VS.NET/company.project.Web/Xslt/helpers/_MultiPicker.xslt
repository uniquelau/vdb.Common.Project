<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" version="1.0" exclude-result-prefixes="umb">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:key name="document-by-id" match="*[@isDoc]" use="@id"/>
  <xsl:template match="MultiNodePicker" mode="multipicker">
    <!--
 Make possible to override the key used to retrieve nodes 
-->
    <xsl:param name="key" select="'document-by-id'"/>
    <!--

		This does the equivalent of calling the key() function for every <nodeId>,
		collecting the resulting documents into a node-set.
		
		Ideally we could just apply templates to that set, but unfortunately the nodes
		will be processed in document order...
		
		So, would be cool to just be able to do this:
	
-->
    <!--  <xsl:apply-templates select="key($key, nodeId)" />  -->
    <!--
 Workaround for the above - still only accessing the lookup table once 
-->
    <xsl:variable name="nodes" select="key($key, nodeId)"/>
    <xsl:for-each select="nodeId">
      <xsl:apply-templates select="$nodes[@id = current()]"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>