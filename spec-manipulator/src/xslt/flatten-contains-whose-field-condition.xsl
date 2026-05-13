<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  
  <!-- Identity template: copy everything by default -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Flatten ContainsWhoseFieldCondition: hoist target/WhoseField attributes and subtree -->
  <xsl:template match="ContainsWhoseFieldCondition[target/WhoseField]">
    <ContainsWhoseFieldCondition>
      <xsl:apply-templates select="@*"/>
      <!-- Copy attributes from WhoseField -->
      <xsl:copy-of select="target/WhoseField/@*"/>
      <!-- Copy children from nodes other than target -->
      <xsl:apply-templates select="node()[not(self::target)]"/>
      <!-- Copy children from WhoseField subtree -->
      <xsl:apply-templates select="target/WhoseField/node()"/>
    </ContainsWhoseFieldCondition>
  </xsl:template>
  
</xsl:stylesheet>
