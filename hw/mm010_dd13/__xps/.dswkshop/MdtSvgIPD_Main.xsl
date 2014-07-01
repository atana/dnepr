<?xml version="1.0" standalone="no"?>
<xsl:stylesheet version="1.0"
           xmlns:svg="http://www.w3.org/2000/svg"
           xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
           xmlns:exsl="http://exslt.org/common"
           xmlns:xlink="http://www.w3.org/1999/xlink">
                
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
	       doctype-public="-//W3C//DTD SVG 1.0//EN"
		   doctype-system="http://www.w3.org/TR/SVG/DTD/svg10.dtd"/>
		   
<xsl:include href="MdtSVG_Colors.xsl"/>
<xsl:include href="MdtSVG_BifShapes.xsl"/>
	
<xsl:include href="MdtSvgIPD_Dimensions.xsl"/>

<xsl:param name="INSTANCE"          select="'microblaze_0'"/>

<!-- ======================= main svg block =============================== -->

<xsl:template match="EDKSYSTEM">
	
<xsl:if test="not(MODULES/MODULE[(@INSTANCE= $INSTANCE)])">
	<xsl:message>XSLT WARNING: Could not find <xsl:value-of select="$INSTANCE"/> in project's XML.</xsl:message>
</xsl:if>

<xsl:for-each select="MODULES/MODULE[(@INSTANCE= $INSTANCE)]">
	
<xsl:variable name="ports_left_cnt_" select="count(PORT[((@DIR='I' or @DIR = 'IO') and not(@SIGNAME = '__NOC__') and not(@SIGNAME = '__DEF__'))])"/>	
<xsl:variable name="ports_rght_cnt_" select="count(PORT[((@DIR='O') and not(@SIGNAME = '__NOC__') and not(@SIGNAME = '__DEF__'))])"/>	
	
<xsl:variable name="bifs_left_cnt_"  select="count(BUSINTERFACE[((not(@BUSNAME = '__DEF__') and not(@BUSNAME = '__NOC__') and not(@ISVALID = 'TRUE')) and (not(@BIFRANK) or (@BIFRANK = 'SLAVE') or (@BIFRANK = 'TARGET') or (@BIFRANK ='TRANSPARENT')))])"/>
<xsl:variable name="bifs_rght_cnt_"  select="count(BUSINTERFACE[((not(@BUSNAME = '__DEF__') and not(@BUSNAME = '__NOC__') and not(@ISVALID = 'TRUE')) and ((@BIFRANK = 'MASTER') or (@BIFRANK = 'MASTER_SLAVE') or (@BIFRANK = 'INITIATOR') or (@BIFRANK ='MONITOR')))])"/>

<!-- select and return the maximum between the two left and right of ports -->
<xsl:variable name="PORTS_H">
<xsl:choose>
	
	<xsl:when test="(($ports_left_cnt_ &lt; 2) and ($ports_rght_cnt_ &lt; 2))">
		<xsl:value-of select="(($IPD_PRT_H + $IPD_PRT_SPC) * 2) + $IPD_PRT_SY"/>
	</xsl:when>
	
	<!-- make sure the module is at least 2 port spaces high -->
	<xsl:when test="($ports_left_cnt_ &gt; $ports_rght_cnt_)">
		<xsl:value-of select="(($IPD_PRT_H + $IPD_PRT_SPC) * $ports_left_cnt_) + $IPD_PRT_SY"/>
	</xsl:when>
		
	<xsl:when test="($ports_rght_cnt_ &gt; $ports_left_cnt_)">
		<xsl:value-of select="(($IPD_PRT_H + $IPD_PRT_SPC) * $ports_rght_cnt_) + $IPD_PRT_SY"/>
	</xsl:when>
	
	<xsl:when test="($ports_left_cnt_ = $ports_rght_cnt_)">
		<xsl:value-of select="(($IPD_PRT_H + $IPD_PRT_SPC) * $ports_left_cnt_) + $IPD_PRT_SY"/>
	</xsl:when>
	
</xsl:choose>	
</xsl:variable>

<!-- select and return the maximum between the two left and right bifs -->
<xsl:variable name="BIFS_H">
<xsl:choose>

	<xsl:when test="($bifs_left_cnt_ &gt; $bifs_rght_cnt_)">
		<xsl:value-of select="(($IPD_BIF_H + $IPD_PRT_SPC) * $bifs_left_cnt_)"/>
	</xsl:when>
		
	<xsl:when test="($bifs_rght_cnt_ &gt; $bifs_left_cnt_)">
		<xsl:value-of select="(($IPD_BIF_H + $IPD_PRT_SPC) * $bifs_rght_cnt_)"/>
	</xsl:when>
	
	<xsl:when test="(($bifs_left_cnt_ = $bifs_rght_cnt_) and ($bifs_left_cnt_ &gt; 0))">
		<xsl:value-of select="(($IPD_BIF_H + $IPD_PRT_SPC) * $bifs_left_cnt_)"/>
	</xsl:when>  
	
	<xsl:otherwise>0</xsl:otherwise>	
	
</xsl:choose>	
</xsl:variable>

<xsl:variable name="IPD_H">
	<xsl:value-of select="$PORTS_H + $BIFS_H  + ($IPD_VGAP * 2)"/>
</xsl:variable>

<xsl:variable name="IPD_W">
	<xsl:value-of select="(($IPD_HGAP * 2) + ($IPD_BIF_W * 2)  + $IPD_CENTER_W)"/>
</xsl:variable>

<!--specify a css for the file -->
<xsl:processing-instruction name="xml-stylesheet">href="MdtSVG_Diagrams.css" type="text/css"</xsl:processing-instruction>

<svg width="{$IPD_W + 4}" height="{$IPD_H + 4}">
	
	<defs>
		<xsl:call-template name="Define_BodyParts">
			<xsl:with-param name="body_width"  select="$IPD_W"/>
			<xsl:with-param name="body_height" select="$IPD_H"/>
		</xsl:call-template>			
		
		<!-- BIF Defs -->
		<xsl:call-template name="Define_BifTypes"/>		
	</defs>	
	
	<xsl:call-template name="Draw_Module">
		<xsl:with-param name="body_width"   select="$IPD_W"/>
		<xsl:with-param name="body_height"  select="$IPD_H"/>
		<xsl:with-param name="bifs_height"  select="BIFS_H"/>
		<xsl:with-param name="ports_height" select="$PORTS_H"/>
	</xsl:call-template>			
</svg>

</xsl:for-each>
</xsl:template>

<!-- ======================= main svg block =============================== -->


<!-- ======================= IP DIAGRAM DEF =============================== -->

<xsl:template name="Define_BodyParts">
	
	<xsl:param name="body_width"  select="0"/>
	<xsl:param name="body_height" select="0"/>
	<xsl:param name="body_bg_col" select="$COL_MOD_BG"/>
	
	<symbol id="HCurve" overflow="visible">
		<path d="m 0  0, 
			 a 16 16, 0,0,0, 32,0,
			 z" style="fill:{$body_bg_col};fill-opacity:1;stroke:black;stroke-width:1.5"/>  
		 <line x1="0" y1="0" x2="32" y2="0" style="stroke:{$body_bg_col};stroke-width:3"/>
	</symbol> 	
	
	<symbol id="IPD_StandardBody">
			
		<rect x="0"  
			  y="0"    
			  width ="{$body_width}"  
			  height="{$body_height}"
			  style="fill:{$body_bg_col};fill-opacity: 1.0; stroke:{$COL_BLACK}; stroke-width:1"/> 
				
		<rect x="{$IPD_VGAP + $IPD_BIF_W}" 
			  y="{$IPD_HGAP}"   
			  width ="{$body_width  - (($IPD_VGAP * 2) + ($IPD_BIF_W * 2))}"   
			  height="{$body_height -  ($IPD_VGAP * 2)}" 
			  style="fill:{$COL_WHITE}; fill-opacity: 1.0; stroke:{$COL_BLACK}; stroke-width:1.5"/> 	
			  
		<xsl:variable name="inner_w_" select="($body_width  - (($IPD_VGAP * 2) + ($IPD_BIF_W * 2)))"/>
		
		<use  x="{ceiling($body_width div 2) - 16}" 
			  y="{$IPD_VGAP}" 
			  xlink:href="#HCurve"/>
	</symbol>
	
	<symbol id="IPD_PORT">
		<rect width ="{$IPD_PRT_W}" 
			  height="{$IPD_PRT_H}" 
			  style="fill:{$COL_MOD_MPRT};stroke-width:1;stroke:black;"/>
	</symbol>	
		
	<symbol id="IPD_SPort">
		<line x1="0"            y1="0" 
			  x2="{$IPD_PRT_W}" y2="0" 
			  style="stroke:{$COL_MOD_SPRT};stroke-width:2;stroke-opacity:1"/>
	</symbol>
	
    <symbol id="IPD_PortClk">
		<line x1="0" y1="0" 
			  x2="7" y2="3" 
			  style="stroke:{$COL_BLACK};stroke-width:1;stroke-opacity:1"/>
		<line x1="7" y1="3" x2="0" y2="7" style="stroke:{$COL_BLACK};stroke-width:1;stroke-opacity:1"/>
	</symbol>	
	
</xsl:template>


<xsl:template name="Draw_Ports">
	<xsl:param name="body_width"   select="0"/>
	<xsl:param name="body_height"  select="0"/>
	
	<xsl:variable name="prt_ix_pos_">
		<xsl:value-of select="($IPD_HGAP  + $IPD_BIF_W) - $IPD_PRT_W"/>
	</xsl:variable>	
	
	<xsl:variable name="prt_ox_pos_">
		<xsl:value-of select="$body_width - ($IPD_HGAP + $IPD_BIF_W)"/>
	</xsl:variable>	
	
	<xsl:variable name="prt_ini_y_">
		<xsl:value-of select="$IPD_VGAP + $IPD_PRT_SY"/>
	</xsl:variable>	
	
	<!-- layout the input ports-->
	<xsl:for-each select="PORT[((@DIR='I'or @DIR='IO') and not(@SIGNAME = '__NOC__') and not(@SIGNAME = '__DEF__') and (@INMHS))]">
		<xsl:sort data-type="number" select="@INDEX" order="ascending"/>
		<xsl:variable name="prt_iy_pos_" select="$prt_ini_y_ + ((position() - 1) * ($IPD_PRT_SPC + $IPD_PRT_H))"/>
		
		<xsl:if test="@MSB and @LSB">
			<use x="{$prt_ix_pos_}" y="{$prt_iy_pos_}" xlink:href="#IPD_PORT"/>
		</xsl:if>
		<xsl:if test="not(@MSB) or not(@LSB)">
			<use x="{$prt_ix_pos_}" y="{$prt_iy_pos_}" xlink:href="#IPD_SPort"/>
		</xsl:if>
		<xsl:if test="@SIGIS='CLK'">
			<use x="{$prt_ix_pos_ + 8}" y="{$prt_iy_pos_ - 2}" xlink:href="#IPD_PortClk"/>
		</xsl:if>
		<text class="portlabel" 
		       x="{$prt_ix_pos_ + $IPD_PRT_W + 12}" 
			   y="{$prt_iy_pos_ + 6}"><xsl:value-of select="@INDEX"/></text>
	</xsl:for-each>
	
	<!-- layout the output ports-->
	<xsl:for-each select="PORT[((@DIR='O') and not(@SIGNAME = '__DEF__') and not(@SIGNAME = '__NOC__') and (@INMHS))]">
		<xsl:sort data-type="number" select="@INDEX" order="ascending"/>
		<xsl:variable name="prt_oy_pos_" select="$prt_ini_y_ + ((position() - 1) * ($IPD_PRT_SPC + $IPD_PRT_H))"/>
		
		<xsl:if test="@MSB and @LSB">
			<use x="{$prt_ox_pos_}" y="{$prt_oy_pos_}" xlink:href="#IPD_PORT"/> 
		</xsl:if>
		<xsl:if test="not(@MSB) or not(@LSB)">
			<use x="{$prt_ox_pos_}" y="{$prt_oy_pos_}" xlink:href="#IPD_SPort"/>
		</xsl:if>
		<text class="portlabel" 
			x="{$prt_ox_pos_ - 12}" 
			y="{$prt_oy_pos_ + 6}"><xsl:value-of select="@INDEX"/></text>
	</xsl:for-each>
	
</xsl:template>

<xsl:template name="Draw_Bifs">
	<xsl:param name="body_width"    select="0"/>
	<xsl:param name="body_height"   select="0"/>
	<xsl:param name="ports_height"  select="0"/>
	
	<xsl:variable name="bif_ix_pos_">
		<xsl:value-of select="($IPD_HGAP  + $IPD_BIF_W) - $IPD_BIFC_W"/>
	</xsl:variable>	
	
	<xsl:variable name="bif_ox_pos_">
		<xsl:value-of select="$body_width - ($IPD_HGAP + $IPD_BIF_W)"/>
	</xsl:variable>	
	
	<xsl:variable name="bif_ini_y_">
		<xsl:value-of select="$IPD_VGAP + $IPD_PRT_SY + $ports_height"/>
	</xsl:variable>	
	
	<!-- layout the left bifs-->
	<xsl:for-each select="BUSINTERFACE[((not(@BUSNAME = '__NOC__') and not(@BUSNAME = '__DEF__') and not(@ISVALID='TRUE')) and (not(@BIFRANK) or (@BIFRANK = 'SLAVE') or (@BIFRANK = 'TARGET') or (@BIFRANK = 'TRANSPARENT')))]">
		<xsl:variable name="bif_iy_pos_" select="$bif_ini_y_ + ((position() - 1) * ($IPD_PRT_SPC + $IPD_BIF_H))"/>
		
		<xsl:variable name="bif_rank">
			<xsl:choose>
				<xsl:when test="@BIFRANK"><xsl:value-of select="@BIFRANK"/></xsl:when>
				<xsl:otherwise>SLAVE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bif_bstd">
			<xsl:choose>
				<xsl:when test="@BUSSTD"><xsl:value-of select="@BUSSTD"/></xsl:when>
				<xsl:otherwise>TRS</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<use x="{$bif_ix_pos_}" y="{$bif_iy_pos_}" xlink:href="#{$bif_bstd}_busconn_{$bif_rank}"/>
		
		<text class="ipdbiflbl" 
			x="{$bif_ix_pos_ + $IPD_BIF_W + 4}" 
			y="{$bif_iy_pos_ + 14}"><xsl:value-of select="@NAME"/></text>
	</xsl:for-each>
	
	<!-- layout the right bifs-->
	<xsl:for-each select=" BUSINTERFACE[((not(@BUSNAME = '__NOC__') and not(@BUSNAME = '__DEF__') and not(@ISVALID = 'TRUE')) and ((@BIFRANK = 'MASTER') or (@BIFRANK = 'MASTER_SLAVE') or (@BIFRANK = 'INITIATOR') or (@BIFRANK = 'MONITOR')))]">
		<xsl:variable name="bif_oy_pos_" select="$bif_ini_y_ + ((position() - 1) * ($IPD_PRT_SPC + $IPD_BIF_H))"/>
		
		<xsl:variable name="bif_rank">
			<xsl:choose>
				<xsl:when test="@BIFRANK"><xsl:value-of select="@BIFRANK"/></xsl:when>
				<xsl:otherwise>SLAVE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bif_bstd">
			<xsl:choose>
				<xsl:when test="@BUSSTD"><xsl:value-of select="@BUSSTD"/></xsl:when>
				<xsl:otherwise>TRS</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="not($bif_rank = 'MASTER_SLAVE')">
			<use x="{$bif_ox_pos_}" y="{$bif_oy_pos_}" xlink:href="#{$bif_bstd}_busconn_{$bif_rank}"/>
		</xsl:if>		
		<xsl:if test="($bif_rank = 'MASTER_SLAVE')">
			<use x="{$bif_ox_pos_}" y="{$bif_oy_pos_}" xlink:href="#{$bif_bstd}_busconn_{$bif_rank}" transform="rotate(90,{($bif_ox_pos_ + ceiling($IPD_BIF_W div 2))},{($bif_oy_pos_ + ceiling($IPD_BIF_H div 2))})"/>
		</xsl:if>
		
		<text class="ipdbiflbl" 
			x="{$bif_ox_pos_ - (string-length(@NAME) * 8) - 2}" 
			y="{$bif_oy_pos_ + 14}"><xsl:value-of select="@NAME"/></text>
	</xsl:for-each>
	
</xsl:template>


<xsl:template name="Draw_Module">
	
	<xsl:param name="body_width"   select="0"/>
	<xsl:param name="body_height"  select="0"/>
	<xsl:param name="bifs_height"  select="0"/>
	<xsl:param name="ports_height" select="0"/>

	<use x="0"  
		 y="0"  
		 xlink:href="#IPD_StandardBody"/>
		 
	<text class="iptype" 
		  x="{ceiling($body_width  div 2)}" 
		  y="{ceiling($body_height div 2) + 4}">
		<xsl:value-of select="@MODTYPE"/>
	</text>
	
	<text class="iplabel" 
		  x="{ceiling($body_width  div 2)}" 
		  y="{ceiling($body_height div 2) + 16}">
		<xsl:value-of select="@INSTANCE"/>
	</text>
		 
	<xsl:call-template name="Draw_Ports">
		<xsl:with-param name="body_width"   select="$body_width"/>
		<xsl:with-param name="body_height"  select="$body_height"/>
	</xsl:call-template>
	
	<xsl:call-template name="Draw_Bifs">
		<xsl:with-param name="body_width"    select="$body_width"/>
		<xsl:with-param name="body_height"   select="$body_height"/>
		<xsl:with-param name="ports_height"  select="$ports_height"/>
	</xsl:call-template>
	
</xsl:template>

</xsl:stylesheet>

