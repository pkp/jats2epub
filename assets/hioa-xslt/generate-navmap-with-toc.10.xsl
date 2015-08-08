<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xhtml"
    version="1.0">
    <xsl:param name="article-xhtml" select="'index.html'"/>
    <xsl:output method="text" indent="yes"/>

    <!--
         Select all the headers in the xhtml-document used in the epub.
         The authors of the article are tagged as <h2 class="author">...</h2> in html, 
         This is not ideal. As a workaround, don't select the author-h2 element when choosing h1-h6 to be listed in
         navMap
         -->
    <xsl:variable name="headers"
      select="//xhtml:h1[not(@class='author')] |
              //xhtml:h2[not(@class='author')] |
              //xhtml:h3[not(@class='author')] |
              //xhtml:h4[not(@class='author')] |
              //xhtml:h5[not(@class='author')] |
              //xhtml:h6[not(@class='author')]"/>
    
    <!-- @@@ XSLT1.0 variable/result tree fragment mess -->
    <xsl:variable name="header-tree">
        <header>
            <xsl:for-each select="$headers">
                <xsl:element name="{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="pos" select="position()"/>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </header>
    </xsl:variable>
    
    <xsl:template match="/">
        <navMap xmlns="http://www.daisy.org/z3986/2005/ncx/">
            <xsl:apply-templates select="$header-tree/header/h1"/>
        </navMap>
    </xsl:template>
    
    <xsl:template match="h1">
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
            <xsl:apply-templates select="following-sibling::h2[generate-id(preceding-sibling::h1[1]) = $this-id]"/>
        </navPoint>
    </xsl:template>
    <xsl:template match="h2">
        <xsl:param name="parent-position" select="0"/>
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
            <xsl:apply-templates select="following-sibling::h3[generate-id(preceding-sibling::h2[1]) = $this-id]"/>
        </navPoint>
    </xsl:template>
    <xsl:template match="h3">
        <xsl:param name="parent-position" select="0"/>
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
            <xsl:apply-templates select="following-sibling::h4[generate-id(preceding-sibling::h3[1]) = $this-id]"/>
        </navPoint>
    </xsl:template>
    <xsl:template match="h4">
        <xsl:param name="parent-position" select="0"/>
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
            <xsl:apply-templates select="following-sibling::h5[generate-id(preceding-sibling::h4[1]) = $this-id]"/>
        </navPoint>
    </xsl:template>
    <xsl:template match="h5">
        <xsl:param name="parent-position" select="0"/>
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
            <xsl:apply-templates select="following-sibling::h6[generate-id(preceding-sibling::h5[1]) = $this-id]"/>
        </navPoint>
    </xsl:template>
    <xsl:template match="h6">
        <xsl:param name="parent-position" select="0"/>
        <xsl:variable name="this-id" select="generate-id(.)"/>
        <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{generate-id()}" playOrder="{@pos}">
            <navLabel>
                <text><xsl:value-of select="."/></text>
            </navLabel>
            <content><xsl:attribute name="src" select="concat($article-xhtml, '#' , @id)"/></content>
        </navPoint>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>