<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl js" xmlns="http://www.w3.org/1999/xhtml" xmlns:js="urn:custom-javascript" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
    <xsl:variable name="itemsPerPage">
        <xsl:value-of select="20" />
    </xsl:variable>
    <xsl:variable name="itemCount">
        <xsl:value-of select="count(Invoice//Content//Products//Product)" />
    </xsl:variable>
    <xsl:variable name="pagesNeeded">
        <xsl:choose>
            <xsl:when test="$itemCount &lt;= $itemsPerPage">
                <xsl:value-of select="1" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$itemCount mod $itemsPerPage = 0">
                        <xsl:value-of select="$itemCount div $itemsPerPage" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="ceiling($itemCount div $itemsPerPage)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template name="addZero">
        <xsl:param name="count" />
        <xsl:if test="$count &gt; 0">
            <xsl:text>0</xsl:text>
            <xsl:call-template name="addZero">
                <xsl:with-param name="count" select="$count - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="congphi">
        <xsl:param name="count" />
        <xsl:if test="$count &gt; 0">
            <xsl:value-of select="$count"/>
            <xsl:text>0</xsl:text>
            <xsl:call-template name="addZero">
                <xsl:with-param name="count" select="$count - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="addDots">
        <xsl:param name="val" />
        <xsl:param name="val1" />
        <xsl:param name="val2" />
        <xsl:param name="i" select="1" />
        <xsl:if test="$val1&gt;0">
            <xsl:choose>
                <xsl:when test="$val2 !=0">
                    <xsl:value-of select="substring($val,$i,$val2)" />
                    <xsl:if test="substring($val,$i+$val2+1,1) !=''">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:call-template name="addDots">
                        <xsl:with-param name="val" select="$val" />
                        <xsl:with-param name="val1" select="$val1 - 1" />
                        <xsl:with-param name="i" select="$i + $val2" />
                        <xsl:with-param name="val2" select="3" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:text>test</xsl:text>-->
                    <xsl:value-of select="substring($val,$i,3)" />
                    <xsl:if test="substring($val,$i+3,1) !=''">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:call-template name="addDots">
                        <xsl:with-param name="val" select="$val" />
                        <xsl:with-param name="val1" select="$val1 - 1" />
                        <xsl:with-param name="i" select="$i + 3" />
                        <xsl:with-param name="val2" select="3" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="addLine">
        <xsl:param name="count" />
        <xsl:if test="$count &gt; 0">
            <tr class="noline back">
                <td class="stt" height="23px" style="border-left:1px solid #000;">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold" height="23px">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold" height="23px">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold" height="23px">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold" height="23px">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold">
                    <xsl:value-of select="''" />
                </td>
                <td class="back-bold">
                    <xsl:value-of select="''" />
                </td>
            </tr>
            <xsl:call-template name="addLine">
                <xsl:with-param name="count" select="$count - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="findSpaceChar">
        <xsl:param name="str" />
        <xsl:variable name="strLength">
            <xsl:value-of select="string-length($str)" />
        </xsl:variable>
        <xsl:if test="$strLength &gt; 0">
            <xsl:choose>
                <xsl:when test="substring($str, $strLength) != ' '">
                    <xsl:call-template name="findSpaceChar">
                        <xsl:with-param name="str" select="substring($str, 1, $strLength - 1)" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$strLength" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tempAmount_words">
        <xsl:param name="str" />
        <xsl:variable name="strLength">
            <xsl:value-of select="string-length($str)" />
        </xsl:variable>
        <xsl:variable name="row1Length">
            <xsl:value-of select="120" />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$strLength &gt; $row1Length">
                <xsl:variable name="str0">
                    <xsl:value-of select="substring($str, 1, $row1Length)" />
                </xsl:variable>
                <xsl:variable name="spaceCharPosition">
                    <xsl:call-template name="findSpaceChar">
                        <xsl:with-param name="str" select="$str0" />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="str1">
                    <xsl:value-of select="substring($str0, 1, $spaceCharPosition)" />
                </xsl:variable>
                <xsl:variable name="str2">
                    <xsl:value-of select="substring($str, $spaceCharPosition + 1)" />
                </xsl:variable>
                <div class="clearfix">
                    <label class="fl-l">
                        Số tiền viết bằng chữ <i>(Amount in words)</i>:
                    </label>
                    <label class="fl-l " style="margin-left:3px;width:655px;height:17px;min-width: 100px;display: block;text-align:left;">
                        <xsl:value-of select="$str1" />
                    </label>
                </div>
                <div class="clearfix">
                    <label class="fl-l" style="width:910px;height:17px;min-width: 100px;display: block;text-align:left!important;">
                        <xsl:value-of select="$str2" />
                    </label>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="clearfix">
                    <label class="fl-l">
                        Số tiền viết bằng chữ <i>(Amount in words)</i>:
                    </label>
                    <label class="fl-l " style="margin-left:20px;width:655px;height:17px;min-width: 100px;display: block;text-align:left;">
                        <xsl:value-of select="$str" />
                    </label>
                </div>
                <div class="clearfix">
                    <label class="fl-l " style="width:910px;height:17px;min-width: 100px;display: block;text-align:left!important;"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="main">
        <xsl:param name="pagesNeededfnc" />
        <xsl:param name="itemCountfnc" />
        <xsl:param name="itemNeeded" />
        <xsl:for-each select="Products//Product">
            <xsl:choose>
                <!-- Vị trí dòng product đầu mỗi trang -->
                <xsl:when test=" position() mod $itemNeeded = 1">
                    <xsl:choose>
                        <!-- Dòng product đầu tiên của trang đầu -->
                        <xsl:when test="position()=1">
                            <xsl:text disable-output-escaping="yes">&lt;div class="pagecurrent" id="1"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div class="statistics"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div style="font-size:12px;border-bottom:1px dashed #000; width:950px; float: left ; text-align: center;color:#584d77;margin:0px auto"&gt;</xsl:text>
                            Đơn vị cung cấp giải pháp hóa đơn điện tử: Tổng công ty dịch vụ viễn thông - VNPT Vinaphone, MST:0106869738, Điện thoại:18001260
                            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div class="nenhd" style="margin-bottom: 10px!important;"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;table style="width:920px!important;"&gt;</xsl:text>
                            <xsl:call-template name="addfirstbody"/>
							<tr>
								<td colspan="8" valign="top">
									<div style="width:73%; float:right;text-align:center; margin-top:-20px;">
                                        <label> Trang <i>(page)</i>: </label>
                                        1/ <xsl:value-of select="$pagesNeededfnc" />
                                    </div>
									<br/>
									<div class="ComInfo" style="margin-top:-20px;">
										Số đơn hàng <i>(Order No)</i>:
										<xsl:choose>
											<xsl:when test="../../ORDERNUMBER!=''">
												<xsl:value-of select="../../ORDERNUMBER" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
									<div class="ComInfo">
										Mã đơn hàng <i>(Oder ID)</i>:
										<xsl:choose>
											<xsl:when test="../../ORDERID!=''">
												<xsl:value-of select="../../ORDERID" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
									<div class="ComInfo">
										Giao hàng <i>(Delivery)</i>:
										<xsl:choose>
											<xsl:when test="../../POSTALNOTE!=''">
												<xsl:value-of select="../../POSTALNOTE" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
							</tr>
							
                            <xsl:call-template name="addsecondbody"/>
							<tr>
								<td valign="top" colspan="8" style="border:1px solid #000;border-top:none!important;">
									<div style="width:100%!important; float:left;text-align: left; padding-left:3px;">
										Hình thức thanh toán <i>(payment method)</i>: TM/CK <i>(Cash/ Transfer)</i>
									</div>									
								</td>
							</tr>							
							
							
                            <xsl:call-template name="addthirdbody"/>
                            <xsl:call-template name="calltitleproduct"/>
                            <xsl:call-template name="callbodyproduct"/>

                            <!-- Trường hợp chỉ có 1 sản phẩm product -->
                            <xsl:if test="(position()=1) and $itemCountfnc=1">
                                <xsl:call-template name="addLine">
                                    <xsl:with-param name="count" select="$pagesNeededfnc * $itemNeeded - $itemCountfnc" />
                                </xsl:call-template>
                                <xsl:call-template name="calltongsoproduct"/>
                                <!-- <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>-->
                                <xsl:call-template name="addfinalbody"/>
                                <xsl:call-template name="addchuky"/>
                                <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;div class="nenhd_bg" style="margin-top: -6px; margin-left: -26px"&gt;&lt;/div&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
								<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                            </xsl:if>
                        </xsl:when>
                        <!-- Dòng product đầu của các trang sau -->
                        <xsl:otherwise>
                            <xsl:text disable-output-escaping="yes">&lt;div class="pagecurrent" id=</xsl:text>
                            <xsl:value-of select="((position()-1) div $itemNeeded) + 1" />
                            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div class="statistics"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div style="font-size:12px;border-bottom:1px dashed #584d77; width:950px; float: left ;text-align: center;color:#584d77;"&gt;</xsl:text>
                            Đơn vị cung cấp giải pháp hóa đơn điện tử: Tổng công ty dịch vụ viễn thông - VNPT Vinaphone, MST:0106869738, Điện thoại:18001260
                            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;div class="nenhd" style="margin-bottom: 0px !important;"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;table style="width:920px!important;"&gt;</xsl:text>
                            <xsl:call-template name="addfirstbody"/>
                            <tr>
								<td colspan="8" valign="top">
									<div style="width:73%; float:right;text-align:center; margin-top:-20px;">
                                        <label> tiếp theo trang trước - trang: </label>
                                         <xsl:value-of select="((position()-1) div $itemNeeded) + 1" />/ <xsl:value-of select="$pagesNeededfnc" />
                                    </div>
									<br/>
									<div class="ComInfo" style="margin-top:-20px;">
										Số đơn hàng <i>(Order No)</i>:
										<xsl:choose>
											<xsl:when test="../../ORDERNUMBER!=''">
												<xsl:value-of select="../../ORDERNUMBER" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
									<div class="ComInfo">
										Mã đơn hàng <i>(Oder ID)</i>:
										<xsl:choose>
											<xsl:when test="../../ORDERID!=''">
												<xsl:value-of select="../../ORDERID" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
									<div class="ComInfo">
										Giao hàng <i>(Delivery)</i>:
										<xsl:choose>
											<xsl:when test="../../POSTALNOTE!=''">
												<xsl:value-of select="../../POSTALNOTE" />
											</xsl:when>
											<xsl:otherwise>
												 
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
							</tr>
                            <xsl:call-template name="addsecondbody"/>
							<tr>
								<td valign="top" colspan="8" style="border:1px solid #000;border-top:none!important;">
									<div style="width:100%!important; float:left;text-align: left; padding-left:3px;">
										Hình thức thanh toán <i>(payment method)</i>: TM/CK <i>(Cash/ Transfer)</i>
									</div>									
								</td>
							</tr>  
                            <xsl:call-template name="addthirdbody"/>
                            <!--<tr>
                                <td colspan="6">
                                    <div style="margin-left: 318px; margin-top: 8px; height:20px">
                                        <label>Tiếp theo trang trước - trang </label>
                                        <xsl:value-of select="((position()-1) div $itemNeeded) + 1" />/<xsl:value-of select="$pagesNeededfnc" />
                                    </div>
                                </td>
                            </tr>-->
                            <xsl:call-template name="calltitleproduct"/>
                            <xsl:call-template name="callbodyproduct"/>

                            <!-- Trường hợp dòng product cuối cùng là dòng đầu tiên của trang cuối cùng -->
                            <xsl:if test=" position() = $itemCountfnc">
                                <xsl:call-template name="addLine">
                                    <xsl:with-param name="count" select="$pagesNeededfnc * $itemNeeded - $itemCountfnc" />
                                </xsl:call-template>
                                <xsl:call-template name="calltongsoproduct"/>
                                <xsl:call-template name="addfinalbody"/>
                                <xsl:call-template name="addchuky"/>
                                <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;div class="nenhd_bg" style="margin-top: -6px; margin-left: -26px"&gt;&lt;/div&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- Vị trí dòng product cuối cùng mỗi trang, không phải trang cuối -->
                <xsl:when test=" (position() mod $itemNeeded = 0) and (position() &lt; $itemCountfnc)">
                    <xsl:call-template name="callbodyproduct"/>
                    <xsl:call-template name="endproduct"/>
                    <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;div class="nenhd_bg" style="margin-top: -6px; margin-left: -26px"&gt;&lt;/div&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
					<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                    <p style="page-break-before: always" />
                </xsl:when>
                <!-- Vị trí dòng sản phẩm cuối cùng -->
                <xsl:when test=" position() = $itemCountfnc">
                    <xsl:call-template name="callbodyproduct"/>

                    <xsl:call-template name="addLine">
                        <xsl:with-param name="count" select="$pagesNeededfnc * $itemNeeded - $itemCountfnc" />
                    </xsl:call-template>
                    <xsl:call-template name="calltongsoproduct"/>
                    <xsl:call-template name="addfinalbody"/>
                    <xsl:call-template name="addchuky"/>
                    <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;div class="nenhd_bg" style="margin-top: -6px; margin-left: -26px"&gt;&lt;/div&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
					<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                </xsl:when>
                <!-- Các vị trí dòng sản phẩm ở khoảng giữa một trang -->
                <xsl:otherwise>
                    <xsl:call-template name="callbodyproduct"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="addfirstbody">
        <tr>
            <td colspan="8">
                <table class="headerCom-table">
                    <tr>
                        <td rowspan="2" valign="top" style="width:465px;">
                            <div class="ComInfo" style="font-weight:bold; font-size:16px!important;">
								CHI NHÁNH CÔNG TY TNHH MỸ PHẨM THƯỜNG XUÂN <br/> TẠI HÀ NỘI
								<!--
								<xsl:choose>
                                    <xsl:when test="../../ComName!=''">
                                        <xsl:value-of select="../../ComName" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>
								-->
                            </div>
                            <div class="ComInfo">
                                MÃ SỐ THUẾ <i>(Tax Code) :</i> <b>0 3 0 2 6 9 7 4 1 1 - 0 0 1</b>
                                <!--<xsl:choose>
                                    <xsl:when test="../../ComTaxCode!=''">
                                        <b><xsl:value-of select="../../ComTaxCode" /></b>
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>
								-->
                            </div>
                            <div class="ComInfo">
                                Địa chỉ <i>(Address) :</i> Số 19 Cát Linh, Phường Quốc Tử Giám, Quận Đống Đa, Thành Phố Hà Nội, Việt Nam.
                               <!-- <xsl:choose>
                                    <xsl:when test="../../ComAddress!=''">
                                        <xsl:value-of select="../../ComAddress" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>-->
                            </div>
                            <div class="ComInfo">
                                Điện thoại <i>(Tel.)</i>:(84-24) 3933 4229
                                <!--<xsl:choose>
                                    <xsl:when test="../../ComPhone!=''">
                                        <xsl:value-of select="../../ComPhone" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>-->

                                &#160;&#160;
                                Fax: (84-24) 3933 4238
                            </div>
                            <!--<div class="ComInfo">
                                Số tài khoản <i>(Bank account):</i>
                                <xsl:choose>
                                    <xsl:when test="../../ComBankNo!=''">
                                        <b><xsl:value-of select="../../ComBankNo" /></b>
                                        <xsl:choose>
                                            <xsl:when test="../../ComBankName!=''">
                                                - <xsl:value-of select="../../ComBankName" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                 
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>-->                            
                        </td>
                        <td rowspan="2" valign="top" style="width:285px; text-align:center;font-size:26px!important; font-weight:bold;">
                            HÓA ĐƠN
                            <br/>
                            GIÁ TRỊ GIA TĂNG
                            <br/>
                            <xsl:choose>
                                <xsl:when test="substring(ArisingDate,7,4)!= '1957' and substring(../../ArisingDate,7,4)!= ''">
                                    <label  class="fl-l" style="padding-left:55px;">
                                        Ngày <br/> <br/> <i>(date)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;">
                                        <xsl:value-of select="substring(../../ArisingDate,1,2)" />
                                    </label>
                                      		<label  class="fl-l">
                                        tháng <br/> <br/> <i>(month)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;">
                                        <xsl:value-of select="substring(../../ArisingDate,4,2)" />
                                    </label>
                                      		<label  class="fl-l">
                                        năm <br/> <br/> <i>(year)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block; ">
                                        <xsl:value-of select="concat('20',substring(../../ArisingDate,9,2))" />
                                    </label>
                                </xsl:when>
                                <xsl:otherwise>
                                    <label  class="fl-l" style="padding-left:55px;">
                                        Ngày <br/> <br/> <i>(date)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;text-align:center;">
                                        &#160;
                                    </label>
                                    <label  class="fl-l">
                                        tháng <br/> <br/> <i>(month)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;text-align:center;">
                                        &#160;
                                    </label>
                                    <label  class="fl-l">
                                        năm <br/> <br/> <i>(year)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block; text-align:center;">
                                        &#160;
                                    </label>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td valign = "top" style="width:200px;height:115px;">
                            <img style="width: 200px;padding-top: 10px;" src=" data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/4REURXhpZgAATU0AKgAAAAgACAExAAIAAAARAAAIegMBAAUAAAABAAAIjAMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAOxFESAAQAAAABAAAOxIdpAAQAAAABAAAIlOocAAcAAAgMAAAAbgAAAAAc6gAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEFkb2JlIEltYWdlUmVhZHkAAAABhqAAALGPAAWQAwACAAAAFAAAEOKQBAACAAAAFAAAEPaSkQACAAAAAzAwAACSkgACAAAAAzAwAADqHAAHAAAIDAAACNYAAAAAHOoAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAyMDE2OjA4OjI1IDIxOjM4OjI1ADIwMTY6MDg6MjUgMjE6Mzg6MjUAAAD/4QmcaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49J++7vycgaWQ9J1c1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCc/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyI+PHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQzMS1kMzNkNzUxODJmMWIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+PHhtcDpDcmVhdGVEYXRlPjIwMTYtMDgtMjVUMjE6Mzg6MjU8L3htcDpDcmVhdGVEYXRlPjwvcmRmOkRlc2NyaXB0aW9uPjwvcmRmOlJERj48L3g6eG1wbWV0YT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgPD94cGFja2V0IGVuZD0ndyc/Pv/bAEMAAgEBAgEBAgICAgICAgIDBQMDAwMDBgQEAwUHBgcHBwYHBwgJCwkICAoIBwcKDQoKCwwMDAwHCQ4PDQwOCwwMDP/bAEMBAgICAwMDBgMDBgwIBwgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDP/AABEIACoAyAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK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"/>
                            <br/><br/>
                            Mẫu số <i>(Type)</i>:
                            <b>
                                <xsl:value-of select="../../InvoicePattern" />
                            </b>
                            <br />
                            Ký hiệu <i>(Serial)</i>:
                            <b>
                                <xsl:value-of select="../../SerialNo" />
                            </b>
                            <p style=" margin-top:1px;">
                                Số <i>(No.)</i>:
                                <b>
                                    <span class="number" style="color:#FA5858; font-size:20px; padding-left:5px">
                                        <xsl:call-template name="addZero">
                                            <xsl:with-param name="count" select="7-string-length(../../InvoiceNo)" />
                                        </xsl:call-template>
                                        <xsl:value-of select="../../InvoiceNo" />
                                    </span>
                                </b>
                            </p>
                        </td>
                    </tr>
                    <!--<tr>
                        <td valign="top">
                            <div>
								<xsl:choose>
                                    <xsl:when test="/Invoice/qrCodeData!=''">
                                        <p>
                                           <img style="width: 200px; height: 45px;float: left;position:relative;" >
												<xsl:attribute name="src">
													data:image/png;base64,<xsl:value-of select="../../BarcodeBase64"/>
												</xsl:attribute>
											</img>
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img style="margin-left:5px;width: 110px; height: 110px;float: left;" width="110" height="110" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAIjSURBVGhD7Y9BbiQxDMTm/5+exR4ICIQLJSe5ZNIE6lAyrW6/3n+E56GfxvPQT+N56KfxPBRer9eXAm1upnuTxvNQ2C4C+6l7Dmme2PrV+O6HU/cc0jyx9avhRXQH3GG683zbHXBPVCMtdsAdpjvPt90B90Q10mIH3GG6p0DqDrgnqpEWO+AO0z0FUnfAPVGNtNgBd5jujPF8ujPgnqhGWuyAO0x3xng+3RlwT1RjuwiS7zk9zbds/Wr81Ic9p6f5lq1fDRbdBr7ab9OoxmnpJvDVfptGN36Y7Y/9NM9DzfYH8RxI3fPG7b315vXC8fEZSN3zxu299ea22PPbDslzblnfaB/y/LZD8pxb6o30gdt5ovk+d7ZUMy2+nSea73NnSzW9cH7kNG9sPcB3bqk3vHh+7DRvbD3Ad26pN04f+R84nZ0C7iad385NNVjkwOnsFHA36fx2brrxTfiR9kP2CKTueeJ5KHjhNnA6OwW2c7LleShcLww+8xY4nc2Ae6Ia20WQfOYtcDqbAfdENdJiB9whzRP2W29UM33AAXdI84T91hvVTB9wwB2mO8/dG7c+1BteTHfAHaY7z90btz7UG15Md8Adpns6h3Q+757SqIYXzeUz4A7TPZ1DOp93T2lUY7sI7NOdLfZv70O9cbvYPt3ZYv/2PtQbLL5Nw166lzzPG9X04m0a9tK95Hne2Ju/nOehn8bz0E/jeein8Uce+n7/Az1k0HCW6mJSAAAAAElFTkSuQmCC" />
                                    </xsl:otherwise>
                                </xsl:choose>                                
                            </div>
                        </td>
                    </tr>-->
                </table>
            </td>
        </tr>
        
    </xsl:template>
    <xsl:template name="addsecondbody">
		<tr>
            <td colspan="8" style="line-height:5px;" >
                <div class="clearfix" id="bt">&#160;</div>
            </td>
        </tr>
        <tr>
            <td colspan="7" style="border:1px solid #000;border-bottom:none!important;border-right:none!important;">
                <div class="CusInfo">
                    Mã số khách hàng <i>(Consultant No.)</i>:&#160; <xsl:value-of select="../../CusCode" />
                </div>
                <div class="CusInfo">
                    Họ và tên người mua hàng <i>(Consultant name)</i>:&#160; <xsl:value-of select="../../Buyer" />
                </div>
                <div class="CusInfo">
                    Tên đơn vị <i>(Company)</i>:&#160; <xsl:value-of select="../../CusName" />
                </div>
                <div class="CusInfo">
                    Mã số thuế <i>(Taxcode)</i>:&#160; <xsl:value-of select="../../CusTaxCode" />
                </div>
                <div class="CusInfo">
                    Địa chỉ <i>(Address)</i>:&#160; <xsl:value-of select="../../CusAddress" />
                </div>
                <div class="CusInfo">
                    Điện thoại <i>(Tel.)</i>:&#160; <xsl:value-of select="../../CusPhone" />
                </div>
            </td>
			<td style="border:1px solid #000;border-bottom:none!important;border-left:none!important;">
				<div style="float:right;">
					<xsl:choose>
						<xsl:when test="/Invoice/qrCodeData!=''">
							<p>
								<img style="margin-left:5px;">
									<xsl:attribute name="src">
										data:image/png;base64,
											<xsl:value-of select="/Invoice/qrCodeData" />
									</xsl:attribute>
								</img>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<p style="margin:0px; padding:0px;">
								<img style="margin-left:5px;width: 110px; height: 110px;float: left;" width="110" height="110" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAIjSURBVGhD7Y9BbiQxDMTm/5+exR4ICIQLJSe5ZNIE6lAyrW6/3n+E56GfxvPQT+N56KfxPBRer9eXAm1upnuTxvNQ2C4C+6l7Dmme2PrV+O6HU/cc0jyx9avhRXQH3GG683zbHXBPVCMtdsAdpjvPt90B90Q10mIH3GG6p0DqDrgnqpEWO+AO0z0FUnfAPVGNtNgBd5jujPF8ujPgnqhGWuyAO0x3xng+3RlwT1RjuwiS7zk9zbds/Wr81Ic9p6f5lq1fDRbdBr7ab9OoxmnpJvDVfptGN36Y7Y/9NM9DzfYH8RxI3fPG7b315vXC8fEZSN3zxu299ea22PPbDslzblnfaB/y/LZD8pxb6o30gdt5ovk+d7ZUMy2+nSea73NnSzW9cH7kNG9sPcB3bqk3vHh+7DRvbD3Ad26pN04f+R84nZ0C7iad385NNVjkwOnsFHA36fx2brrxTfiR9kP2CKTueeJ5KHjhNnA6OwW2c7LleShcLww+8xY4nc2Ae6Ia20WQfOYtcDqbAfdENdJiB9whzRP2W29UM33AAXdI84T91hvVTB9wwB2mO8/dG7c+1BteTHfAHaY7z90btz7UG15Md8Adpns6h3Q+757SqIYXzeUz4A7TPZ1DOp93T2lUY7sI7NOdLfZv70O9cbvYPt3ZYv/2PtQbLL5Nw166lzzPG9X04m0a9tK95Hne2Ju/nOehn8bz0E/jeein8Uce+n7/Az1k0HCW6mJSAAAAAElFTkSuQmCC" />
							</p>
						</xsl:otherwise>
					 </xsl:choose>                                
                </div>
			</td>
        </tr>     
    </xsl:template>
    <xsl:template name="addthirdbody">
    </xsl:template>
    <xsl:template name="calltitleproduct">
        <tr style="height: 30px;">
            <th style="width:30px;">
                <b>STT</b>
                <br />
                <i>(No)</i>
            </th>
            <th style="width:60px;">
                <b>Vị trí</b>
                <br />
                <i>(Location)</i>
            </th>
            <th style="width:70px;">
                <b>Mã hàng</b>
                <br />
                <i>(code)</i>
            </th>
            <th style="width:80px;">
                <b>Số lượng</b>
                <br />
                <i>(Quantity)</i>
            </th>
            <th style="width:290px;">
                <b>Tên hàng hóa, dịch vụ</b>
                <br />
                <i>(Description)</i>
            </th>
            <th style="width:90px;">
                <b>Đơn vị tính</b>
                <br />
                <i>(Unit)</i>
            </th>
            <th style="width:100px;">
                <b>Đơn giá</b>
                <br />
                <i>(Unit Price)</i>
            </th>
            <th style="width:200px;">
                <b>Thành tiền</b>
                <br />
                <i>(Amount)</i>
            </th>
        </tr>
        <tr style="">
            <th class="h2">
                <b>(1)</b>
            </th>
            <th class="h2">
                <b>(2)</b>
            </th>
            <th class="h2">
                <b>(3)</b>
            </th>
            <th class="h2">
                <b>(4)</b>
            </th>
            <th class="h2">
                <b>(5)</b>
            </th>
            <th class="h2">
                <b>(6)</b>
            </th>
            <th class="h2">
                <b>(7)</b>
            </th>
            <th class="h2">
                <b>(8) = (4) x (7)</b>
            </th>
        </tr>
    </xsl:template>
    <xsl:template name="callbodyproduct">
        <tr>
            <td class="stt" style="border-left:1px solid #000;">
                <div style="display: block;width: 30px;">
                    <xsl:value-of select="position()" />
                </div>
            </td>
            <td style="border-left:1px solid #000;border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 55px;text-align:center;overflow: hidden; padding-left:5px">
                    <xsl:value-of select="Remark" />
                </div>
            </td>
            <td>
                <div style="display: block;width: 65px;word-wrap: break-word;text-align:center; ">
                    <xsl:value-of select="Code" />
                </div>
            </td>
            <td style="border-left:1px solid #000;border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 75px;text-align:center;overflow: hidden;">
                    <xsl:choose>
                        <xsl:when test="ProdQuantity=0">
                             0
                        </xsl:when>
						<xsl:when test="ProdQuantity=''">
                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(ProdQuantity, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
            </td>
            <td>
                <div style="display: block;word-wrap: break-word;width: 285px;text-align: center;  overflow: hidden;">
                    <xsl:value-of select="ProdName" />
                </div>
            </td>
            <td style="border-left:1px solid #000;border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 95px;text-align: center;  overflow: hidden;">
                    <xsl:value-of select="ProdUnit" />
                </div>
            </td>
            <td style="border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 95px;text-align: center; overflow: hidden;">
                    <xsl:choose>
                        <xsl:when test="ProdPrice=''">
                             
                        </xsl:when>
						<xsl:when test="ProdPrice=0">
                             0
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(ProdPrice, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </td>
            <td style="border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 190px;text-align: right; overflow: hidden; float:left;">
                    <xsl:choose>
                        <xsl:when test="Amount=''">
                             
                        </xsl:when>
						 <xsl:when test="Amount=0">
                             0
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(Amount, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </td>
        </tr>
    </xsl:template>
    <xsl:template  name="endproduct">
        <tr>
            <td colspan="8" style="border-top:1px solid #000;">

            </td>
        </tr>
    </xsl:template>
    <xsl:template name="calltongsoproduct">
		<tr>
			<td colspan="7" style="border:1px solid #000; border-right:none!important;border-bottom:none!important; height:30px">
				<div style="width:280px; float:left; padding-left:5px; text-align:left;">
					<b>Tổng Số lượng</b><i>(Total Qty)</i>:
					<xsl:choose>
                        <xsl:when test="(../../TOTALQUANTITY=0) or(../../TOTALQUANTITY='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(../../TOTALQUANTITY, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
					
					<!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_TOTALQUANTITY'">
											<xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" />
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
				</div>
				<div style="float:right; width:280px; text-align:left;">
					<b>Cộng tiền hàng</b><i>(Total)</i>:
				</div>
			</td>
			<td style="border:1px solid #000;">
				<div style="display: block;word-wrap: break-word;width: 200px;text-align: right; overflow: hidden; float:left;">
					<xsl:choose>
                        <xsl:when test="(../../Total=0) or(../../Total='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(../../Total, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="7" style="border:1px solid #000; border-right:none!important;border-bottom:none!important;border-top:none!important;height:30px;">
				<div style="width:280px; float:left;padding-left:5px;text-align:left;">
					<b>Thuế suất GTGT</b><i>(VAT rate)</i>:
					<xsl:choose>
                        <xsl:when test="(../../VAT_Rate=0) or(../../VAT_Rate='')">
                              %
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="../../VAT_Rate" />%
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
				<div style="float:right; width:280px; text-align:left;">
					<b>Tiền thuế GTGT</b><i>(VAT amount)</i>:
				</div>
			</td>
			<td style="border:1px solid #000;border-bottom:none!important;border-top:none!important;">
				<div style="display: block;word-wrap: break-word;width: 200px;text-align: right; float:left;">
					<xsl:choose>
                        <xsl:when test="(../../VAT_Amount=0) or (../../VAT_Amount='')">
                             &#160;
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(../../VAT_Amount, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="7" style="border:1px solid #000; border-right:none!important;border-top:none!important;">
				<div style="float:right; width:280px; text-align:left;">
					<b>Tổng cộng tiền thanh toán</b><i>(Total payable)</i>:
				</div>
			</td>
			<td style="border:1px solid #000;">
				<div style="display: block;word-wrap: break-word;width: 200px;text-align: right; float:left;line-height: 24px;">
					<xsl:choose>
                        <xsl:when test="(../../Amount=0) or(../../Amount='')">
                             &#160;
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../Amount, '###,###'),',','?'),'.',','),'?','.')" /></b>
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
			</td>
		</tr>        
    </xsl:template>
    <xsl:template name="addfinalbody">
        <tr class="noline back" style="line-height:20px">			
			<td valign="top" colspan="8" style="text-align:left; padding-left:5px; border:1px solid #000;">
				<xsl:call-template name="tempAmount_words">
					<xsl:with-param name="str" select="../../Amount_words" />
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td colspan="4" style=" border:1px solid #000; height:23px;">
				<div style="width:122px;float:left;padding-left:5px;text-align:left;">
					<b>Số tiền phải trả:</b><br/> <i style="font-size:11px;">(Order value)</i>
				</div>
				<div style="width:105px;float:left; text-align:right;">
					<xsl:choose>
                        <xsl:when test="(../../TOTALPAY=0) or(../../TOTALPAY='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../TOTALPAY, '###,###'),',','?'),'.',','),'?','.')" /></b>
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_TOTALPAY'">
											<b><xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" /></b>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
				</div>
			</td>
			<td colspan="3" style=" border:1px solid #000;">
				<div style="width:170px;float:left;padding-left:5px;text-align:left"> 
					<b>Số tiền đã trả trước:</b><br/> <i style="font-size:11px;">(Prepaid amount)</i>
				</div>
				<div style="width:170px;float:right;text-align:right"> 
					<xsl:choose>
                        <xsl:when test="(../../PREPAYMENTAMOUNT=0) or(../../PREPAYMENTAMOUNT='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../PREPAYMENTAMOUNT, '###,###'),',','?'),'.',','),'?','.')" /></b>
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_PREPAYMENTAMOUNT'">
											<b><xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" /></b>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
				</div>
			</td>
			<td style=" border:1px solid #000;">
				<div style="width:100px;float:left;padding-left:3px; text-align:left">
					<b>Số tiền thực trả</b> <br/> <i style="font-size:11px;">(Payment request)</i>
				</div>				
				<div style="display: block;word-wrap: break-word;width: 95px;text-align: right; overflow: hidden; float:left;">					
					<xsl:choose>
                        <xsl:when test="(../../PAYMENTREQUEST=0) or(../../PAYMENTREQUEST='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../PAYMENTREQUEST, '###,###'),',','?'),'.',','),'?','.')" /></b>
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_PAYMENTREQUEST'">
											<b><xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" /></b>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
				</div>
			</td>
		</tr>
		<!--<tr>
			<td valign="top" colspan="4" style="height:30px;">
				<i>(payment from consultant A/c /Bonus)</i>
			</td>
			<td valign="top" colspan="3">
				<i>(Money in Prepayment on)</i>
			</td>
			<td valign="top">
				<i>(Payment request)</i>
			</td>
		</tr>-->
		<tr>
			<td colspan="8">
				<div style="width:450px; float:left; text-align:left;">
					Trọng lượng <i>(Total weight)</i>: 
					<xsl:choose>
                        <xsl:when test="(../../TOTALWEIGHT=0) or(../../TOTALWEIGHT='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(../../TOTALWEIGHT, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
						<xsl:choose>
							<xsl:when test="Extra_Name!='' and Extra_Name='Extra_TOTALWEIGHT'">
								<xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" />
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>-->
				</div>
				<div style="width:450px; float:left;text-align:left;">
					Điểm BP <i>(Total BP)</i>:
					<xsl:choose>
                        <xsl:when test="(../../TOTALBP=0) or(../../TOTALBP='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(../../TOTALBP, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
						<xsl:choose>
							<xsl:when test="Extra_Name!='' and Extra_Name='Extra_TOTALBP'">
								<xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" />
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>-->
				</div>
			</td>			
		</tr>		
    </xsl:template>
    <xsl:template name="addchuky">
        <tr class="noline back" style="border-bottom: hidden;">
            <td colspan="8" style="border:none!important;">
                <table style="width: 100%;">
                   <!-- <tr>
                        <td style="text-align:left;border: none!important">
                            <b>Người mua hàng (Buyer)</b>
                        </td>
                        <td style="text-align:center;border: none!important">
                            <b>Người bán hàng (Seller)</b>
                        </td>
                        <td style="text-align:center; border: none!important; ">
                            <b>Thủ trưởng đơn vị ( Manager )</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:left; border: none!important">
                            <i style="padding-left:25px;"> (Ký, ghi rõ họ tên)</i>
                        </td>
                        <td style="text-align:center;border: none!important;">
							<i> (Ký, ghi rõ họ, tên)</i>
                        </td>
                        <td style="text-align:center; border: none!important">
                            <i> (Ký, ghi rõ họ, tên)</i>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:left; border: none!important">
                            <i style="padding-left:28px;"> (Sign,full name)</i>
                        </td>
                        <td style="text-align:center; border: none!important; border-left: none!important">
                            <i> (Sign, full name)</i>
                        </td>
                        <td style="text-align:center; border: none!important">
                            <i> (Sign, full name)</i>
                        </td>
                    </tr>-->
                    <tr>
                        <td style="border: none!important">
                            <div class="payment fl-l" style="width:200px;float:left;">  </div>
                        </td>
                        <td style="border: none!important;">
                            <div class="payment fl-l" style="width:200px;float:right;">
                                <!-- <p style="font-size:12px; margin:0px;color:#eb363a!important;" class="ComNameSignDate">
								<xsl:variable name="serial">
								  <xsl:value-of select="../../SerialNo"/>
								</xsl:variable>
								<xsl:variable name="pattern">
								  <xsl:value-of select="../../InvoicePattern"/>
								</xsl:variable>
								<xsl:variable name="invno">
								  <xsl:value-of select="../../InvoiceNo"/>
								</xsl:variable>
								<xsl:choose>
								  <xsl:when test="/Invoice/imageTVAN != '' ">
									<div class="bgimg" style="width:185px;background:url({/Invoice/image/@URI}) no-repeat center center" onclick="showDialog('dialogTVAN','{$serial}','{$pattern}','{$invno}',0,'messSer','is')">
									  <p style="color:#eb363a!important">
										<xsl:value-of select="/Invoice/image"/>
									  </p>
									  <p style="color:#eb363a!important">
										Ký bởi: <xsl:value-of select="/Invoice/CNTVAN"/>
										<br/>
										Ký ngày: <xsl:value-of select="/Invoice/TvanData/Date"/>
									  </p>
									</div>
								  </xsl:when>
								</xsl:choose>
							  </p>-->
                            </div>
                        </td>
                        <td style="  border: none!important; ">
                            <div class="payment fl-l" style="width:300px;">
                                <p style="font-size:12px; color:#eb363a!important;" class="ComNameSignDate">
                                    <xsl:variable name="serial">
                                        <xsl:value-of select="../../SerialNo" />
                                    </xsl:variable>
                                    <xsl:variable name="pattern">
                                        <xsl:value-of select="../../InvoicePattern" />
                                    </xsl:variable>
                                    <xsl:variable name="invno">
                                        <xsl:value-of select="../../InvoiceNo" />
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="/Invoice/image != '' ">
                                            <div class="bgimg" style="width:300px;background:url(data:image/png;base64,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) no-repeat center left" onclick="showDialog('dialogServer','{$serial}','{$pattern}','{$invno}',0,'messSer','is')">
                                                <p style="color:#eb363a!important">
                                                    <xsl:value-of select="/Invoice/image" />
													<!--<img style="width: 200px;padding-top: 10px;" src=" data:image/png;base64,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"/>-->
                                                </p>
                                                <p style="color:#eb363a!important">
                                                    Ký bởi: CHI NHÁNH CÔNG TY TNHH MỸ PHẨM THƯỜNG XUÂN <br/> TẠI HÀ NỘI
													<!--<xsl:choose>
                                                        <xsl:when test="/Invoice/CNCom!=''">
															<xsl:value-of select="/Invoice/CNCom" />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="../../ComName" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>-->
                                                    <br />
                                                    Ký ngày: <xsl:value-of select="/Invoice//Content/SignDate" />
                                                </p>
                                            </div>
                                        </xsl:when>
                                    </xsl:choose>
                                </p>
                            </div>
                        </td>
                    </tr>                    
                </table>
				<hr/>
            </td>
        </tr>
		<tr>
			<td colspan="8" style="border:none!important;">
				<div style="width:650px;float:right;text-align:left; border-bottom:1px solid #000;padding-top:10px;	">
					Tra cứu dịch vụ hóa đơn điện tử tại: https://hoadon.vn.oriflame.com với Mã số bí mật: <xsl:value-of select="../../REFERENCENUM" />
				</div>
                <!--<div style="width:900px;float:left;text-align:center;">
					<b>Cần kiểm tra đối chiếu khi lập, giao, nhận hóa đơn. (Need to check when prepare, delivery invoice)</b>
				</div>-->
            </td>
		</tr>
        <tr>
            <td colspan="8" style="text-align:center; border-right: none!important; border-left: none!important">
                <xsl:value-of select="../../isReplace" />
                <xsl:value-of select="../../isAdjust" />
                <xsl:choose>
                    <xsl:when test="/Invoice/convert!=''">
                        <div style="text-align:center;">
                            <div style="float:left;width:910px;">
                                <label style="font-size:10px">
                                    <b>
                                        HÓA ĐƠN CHUYỂN ĐỔI TỪ HÓA ĐƠN ĐIỆN TỬ
                                    </b>
                                </label>
                                <p style="font-size:10px; margin:0px">
                                    Ngày <b style="color:#584C56">
                                        <xsl:value-of select="substring(/Invoice/ConvertDate,1,2)" />
                                    </b> tháng <b style="color:#584C56">
                                        <xsl:value-of select="substring(/Invoice/ConvertDate,4,2)" />
                                    </b> năm <b style="color:#584C56">
                                        <xsl:value-of select="concat('20',substring(/Invoice/ConvertDate,9,2))" />
                                    </b>
                                </p>
                                <p style="font-size:10px; margin:0px">
                                    Người chuyển đổi
                                </p>
                                <i style="font-size:10px; margin:0px">
                                    ( Signature of converter )
                                </i>
                                <p style="margin-top:40px">
                                    <xsl:value-of select="../../ConvertBy"/>
                                </p>
                            </div>
                        </div>
                    </xsl:when>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
                <!--<link href="styles.css" type="text/css" rel="stylesheet" />-->
                <title>VAT</title>
                <style type="text/css" rel="stylesheet">
                    html, body
                    {
                    margin: 0;
                    padding: 0;
                    height: 100%;
                    background-color: white;
                    }
                    @page {
						size: A4;
						margin: 2mm 2mm 2mm 2mm; /* change the margins as you want them to be. */
                    }
                    #ViewInvoice{
                    height:auto!important;
                    }
                    #main
                    {
                    margin: 0 auto;
                    }
                    .VATTEMP
                    {
                    background-color: white;
                    font-family: Arial;
                    width: 920px !important;
                    font-size: 13px;


                    }
                    .VATTEMP .header-main, .content
                    {
                    width: 790px;
                    }
                    .VATTEMP #logo
                    {
                    float: left;
                    width: 70px;
                    height: 70px;
                    background: url() no-repeat;
                    margin: 0;
                    }
                    .VATTEMP .header
                    {
                    float: right;
                    width: 613px;
                    }
                    .VATTEMP .header-content
                    {
                    float: left;
                    text-align: center;
                    width: 400px;
                    }
                    .VATTEMP .header h2
                    {
                    font-size: 1em;
                    }
                    .VATTEMP .header h2, .header p
                    {
                    margin: 0;
                    }
                    .VATTEMP .header p.name-upcase
                    {
                    font-size: 16px;
                    text-transform: uppercase;
                    }
                    .VATTEMP .header-note
                    {
                    float: right;
                    font-size: 100%;
                    width: 175px;
                    margin-top: 0;
                    }
                    .VATTEMP .header .number
                    {
                    font-family: Arial;
                    font-size: 100%;
                    }
                    .clearfix:after
                    {
                    clear: both;
                    content: ".";
                    display: block;
                    height: 1px;
                    overflow: hidden;
                    visibility: hidden;
                    }
                    .clearfix
                    {
                    clear: both;
                    }
                    .VATTEMP .input-code
                    {
                    border: 1px solid #584d77;
                    float: left;
                    font-weight: normal;
                    text-align: center;
                    width: 18px;
                    height: 14px;
                    }
                    .VATTEMP div label.fl-l, div label
                    {
                    margin-right: 0;
                    /* margin-top: 3px; */
                    }
                    .VATTEMP .input-name, .input-date
                    {
                    border: 0;
                    border-bottom: 1px dotted #000;
                    text-align:center;
                    }
                    .VATTEMP .statistics
                    {
                    clear: both;
                    margin-right: 0;
                    padding-top: 2px;
                    }
                    .nenhd
                    {
                    position: relative;
                    float: left !important;
                    }

                    .VATTEMP .statistics table
                    {
                    background-position: bottom;
                    border: 0 #fff;

                    font-size:13px;
                    margin: 0;
                    position: relative;
                    z-index: 2;
                    width: 100%;
                    }
                    table
                    {
                    border-collapse: collapse;
                    }
                    .VATTEMP .statistics table th
                    {
                    font-size: 100%;
                    text-transform: none;
                    font-weight: normal;
                    border-bottom: 1px solid #000;
                    border-right: 1px solid #000;
                    border-left: 1px solid #000;
                    border-top: 1px solid #000;
                    }
                    .VATTEMP .statistics table th.h2
                    {
                    font-size: 100%;
                    text-transform: none;
                    font-weight: normal;
                    border-bottom: 1px solid #000;
                    border-right: 1px solid #000;
                    border-left: 1px solid #000;
                    border-top: 1px solid #000;
                    }
                    .VATTEMP .statistics table td.stt
                    {
                    text-align: center;
                    padding-left: 0;
                    }
                    .VATTEMP .statistics table td.stt2
                    {
                    text-align: center;
                    color: #584d77;
                    }
                    .VATTEMP .statistics table .back td
                    {
                    color: #000;
                    font-family: Arial;
                    font-size: 100%;
                    }
                    .VATTEMP .statistics table .noline td
                    {
                    border-bottom:none;
                    border-right: 1px solid #000;
                    }
                    .VATTEMP .statistics table td
                    {
                    padding-bottom: 2px;
                    }
                    .VATTEMP .statistics tr td.back-bold
                    {
                    font-size: 100%;
                    /*border-bottom: 1px solid #584d77;*/
                    }
                    .VATTEMP .statistics table .back-bold
                    {
                    padding-right: 5px;
                    text-align: right;
                    }
                    .VATTEMP .statistics tr td.back-bold2
                    {
                    font-size: 100%;
                    border-bottom: 1px dotted #584d77;
                    }
                    .VATTEMP .statistics tr td.back-bold3
                    {
                    font-size: 100%;
                    border-bottom:none!important;
                    }
                    .VATTEMP .statistics table .back-bold2
                    {
                    padding-left: 5px;
                    text-align: left;
                    }
                    .VATTEMP .statistics tr.bg-pink td
                    {
                    font-size: 100%;
                    text-align: right;
                    background: none repeat scroll 0 0 #fedccc;
                    }
                    .VATTEMP .payment, .date
                    {
                    text-align: center;
                    width: 35%;
                    }
                    .VATTEMP .payment
                    {
                    float: right;
                    }
                    .VATTEMP .payment p, .date p
                    {
                    margin: 0;
                    }
                    .VATTEMP .date
                    {
                    float: right;
                    height: 120px;
                    }
                    .VATTEMP .input-date
                    {
                    width: 30px;
                    text-align:center!important;
                    }
                    .VATTEMP .input-name, .back-bold, .input-date
                    {
                    font-family: Arial;
                    font-size: 100%;
                    border-bottom:1px dotted #000;
                    }
                    .fl-l
                    {
                    float: left;
                    min-height: 16px;
                    }
                    .bgimg
                    {
                    border: 1px solid red;
                    cursor: pointer;
                    width: 170px;
                    }
                    .bgimg p
                    {
                    color: #584d77;
                    padding-left: 16px;
                    text-align: left;
                    }
                    p
                    {
                    font-size: 16px;
                    }
                    .item
                    {
                    color: #584d77;
                    }

                    img#imgCancel{
                    width: 800px !important;
                    left: 0px;
                    }

                    .nenhd_bg
                    {
                    background-image:  url('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/4REgRXhpZgAATU0AKgAAAAgACQESAAMAAAABAAEAAAExAAIAAAARAAAIhgMBAAUAAAABAAAImAMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAOxFESAAQAAAABAAAOxIdpAAQAAAABAAAIoOocAAcAAAgMAAAAegAAAAAc6gAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEFkb2JlIEltYWdlUmVhZHkAAAABhqAAALGPAAWQAwACAAAAFAAAEO6QBAACAAAAFAAAEQKSkQACAAAAAzAwAACSkgACAAAAAzAwAADqHAAHAAAIDAAACOIAAAAAHOoAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAyMDE2OjA4OjI1IDIxOjM4OjI1ADIwMTY6MDg6MjUgMjE6Mzg6MjUAAAD/4QmcaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49J++7vycgaWQ9J1c1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCc/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyI+PHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQzMS1kMzNkNzUxODJmMWIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+PHhtcDpDcmVhdGVEYXRlPjIwMTYtMDgtMjVUMjE6Mzg6MjU8L3htcDpDcmVhdGVEYXRlPjwvcmRmOkRlc2NyaXB0aW9uPjwvcmRmOlJERj48L3g6eG1wbWV0YT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgPD94cGFja2V0IGVuZD0ndyc/Pv/bAEMAAgEBAgEBAgICAgICAgIDBQMDAwMDBgQEAwUHBgcHBwYHBwgJCwkICAoIBwcKDQoKCwwMDAwHCQ4PDQwOCwwMDP/bAEMBAgICAwMDBgMDBgwIBwgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDP/AABEIAGoB9AMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3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') ;
                    height:110px;
                    left: 250px;
                    margin: 0 auto;
                    position: absolute;
                    top: 520px;
                    width: 500px;
                    z-index: 1;
                    background-repeat: no-repeat;
                    opacity:0.2;                   
                    }

                    .headerCom-table{
                    width:920px!important;
                    border-collapse:collapse;
                    text-align:left;
                    }
                    .headerCom-table label{
                    font-size:12px!important;
                    text-align:left;
                    font-weight:normal;
                    }
                    .ComInfo{
                    font-size:12px!important;
                    padding:1px 0px;
                    word-wrap:break-word;
                    }
                    .ComInfo i{
                    font-size:11px;
                    }
                    .CusInfo{
                    width:710px;
                    float:left;
                    padding-left:3px!important;
                    padding-bottom:3px!important;
                    text-align:left!important;
                    }
                    .CusInfo i{
                    font-size:12px;
                    }
                </style>
                <xsl:text disable-output-escaping="yes">
					
				</xsl:text>
            </head>
            <body>
                <center>
                    <div id="printView" style="position: relative;background-color: white;WIDTH: 100%;">
                        <xsl:choose>
                            <xsl:when test="/Invoice/Invcancel!=''">
                                <img style="position: absolute;left: 0px;top: 0px;width: 100%;height: auto;z-index: 3;" width="100%" height="960px" src="data:image/png;base64,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" />
                            </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="Invoice//Content">
                            <div class="VATTEMP">
                                <div id="quantitypages" style="padding-left:0px">
                                    <xsl:call-template name="main">
                                        <xsl:with-param name="pagesNeededfnc" select="$pagesNeeded" />
                                        <xsl:with-param name="itemCountfnc" select="count(Products//Product)" />
                                        <xsl:with-param name="itemNeeded" select="$itemsPerPage" />
                                    </xsl:call-template>
                                </div>
                            </div>
                        </xsl:for-each>
                        <!--<xsl:for-each select="Invoice//Content/Products/Product[(position()-1) mod 10 = 0]">
						<xsl:variable name="level1Count" select="(position()-1)*10"/>-->
                    </div>
                </center>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
