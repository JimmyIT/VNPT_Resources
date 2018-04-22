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
                    <label class="fl-l " style="margin-left:3px;width:675px;height:17px;min-width: 100px;display: block;text-align:left;">
                        <xsl:value-of select="$str1" />
                    </label>
                </div>
                <div class="clearfix">
                    <label class="fl-l" style="width:930px;height:17px;min-width: 100px;display: block;text-align:left!important;">
                        <xsl:value-of select="$str2" />
                    </label>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="clearfix">
                    <label class="fl-l">
                        Số tiền viết bằng chữ <i>(Amount in words)</i>:
                    </label>
                    <label class="fl-l " style="margin-left:20px;width:675px;height:17px;min-width: 100px;display: block;text-align:left;">
                        <xsl:value-of select="$str" />
                    </label>
                </div>
                <div class="clearfix">
                    <label class="fl-l " style="width:930px;height:17px;min-width: 100px;display: block;text-align:left!important;"/>
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
                            <xsl:text disable-output-escaping="yes">&lt;table style="width:950px!important;"&gt;</xsl:text>
                            <xsl:call-template name="addfirstbody"/>
                            <xsl:call-template name="addsecondbody"/>
							<tr>
								<td colspan="8" style="border:1px solid #000;">
									<div style="width:540px!important; float:left; text-align: left; padding-left:3px;">
										Hình thức thanh toán <i>(payment method)</i>: TM/CK <i>(Cash/ Transfer)</i><!-- <xsl:value-of select="../../PaymentMethod" /> -->
									</div>
									<div style="width:280px; float:right;text-align:center;">
                                        <label> Trang <i>(page)</i>: </label>
                                        1 of <xsl:value-of select="$pagesNeededfnc" />
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
                            <xsl:text disable-output-escaping="yes">&lt;table style="width:950px!important;"&gt;</xsl:text>
                            <xsl:call-template name="addfirstbody"/>
                            <xsl:call-template name="addsecondbody"/>
							<tr>
								<td colspan="8" style="border:1px solid #000;">
									<div style="width:540px!important; float:left;text-align: left; padding-left:3px;">
										Hình thức thanh toán <i>(payment method)</i>: TM/CK <i>(Cash/ Transfer)</i><!-- <xsl:value-of select="../../PaymentMethod" /> -->
									</div>
									<div style="width:280px; float:right;text-align:center;">
                                        <label> Trang <i>(page)</i>: </label>
                                        <xsl:value-of select="((position()-1) div $itemNeeded) + 1" /> of <xsl:value-of select="$pagesNeededfnc" />
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
                            <div class="ComInfo" style="font-weight:bold; font-size:17px!important;">
								CHI NHÁNH CÔNG TY TNHH MỸ PHẨM THƯỜNG XUÂN
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
                                MÃ SỐ THUẾ <i>(Tax Code) :</i> <b>0 3 0 2 6 9 7 4 1 1 - 0 0 3</b>
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
                                Địa chỉ <i>(Address) :</i>Khu vực S3 &amp; S4B - Tổ Hợp Chung Cư Thương Mại Cao Cấp Bàu Thạc Gián, Số 72 - Hàm Nghi, Phường Thạc Gián, Quận Thanh Khê, Thành Phố Đà Nẵng, Việt Nam.
                               <!-- <xsl:choose>
                                    <xsl:when test="../../ComAddress!=''">
                                        <xsl:value-of select="../../ComAddress" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>-->
                            </div>
                            <div class="ComInfo">
                                Điện thoại <i>(Tel.)</i>: (84-236) 3565 901
                                <!--<xsl:choose>
                                    <xsl:when test="../../ComPhone!=''">
                                        <xsl:value-of select="../../ComPhone" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>-->

                                &#160;&#160;
                                Fax:(84-236) 3565 902
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
                            <br/>
                            <div class="ComInfo">
                                Số đơn hàng <i>(Order No)</i>:
								<xsl:choose>
                                    <xsl:when test="../../ORDERNUMBER!=''">
										<xsl:value-of select="../../ORDERNUMBER" />                                       
                                    </xsl:when>
                                    <xsl:otherwise>
                                         
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_ORDERNUMBER'">
											<xsl:value-of select="Extra_Value" />
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
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
                                <!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_ORDERID'">
											<xsl:value-of select="Extra_Value" />
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
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
                                <!--<xsl:for-each select="../../Extras//Extra_item">
									<xsl:choose>
										<xsl:when test="Extra_Name!='' and Extra_Name='Extra_POSTALNOTE'">
											<xsl:value-of select="Extra_Value" />
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
                            </div>
                        </td>
                        <td rowspan="2" valign="top" style="width:285px; text-align:center;font-size:26px!important; font-weight:bold;line-height: 24px;padding-top: 8px;">
                            HÓA ĐƠN
                            <br/>
                            GIÁ TRỊ GIA TĂNG
                            <br/>
                            <xsl:choose>
                                <xsl:when test="substring(ArisingDate,7,4)!= '1957' and substring(../../ArisingDate,7,4)!= ''">
                                    <label  class="fl-l" style="padding-left:55px;">
                                        Ngày <br/> <i>(date)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;">
                                        <xsl:value-of select="substring(../../ArisingDate,1,2)" />
                                    </label>
                                      		<label  class="fl-l">
                                        tháng <br/> <i>(month)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;">
                                        <xsl:value-of select="substring(../../ArisingDate,4,2)" />
                                    </label>
                                      		<label  class="fl-l">
                                        năm <br/> <i>(year)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block; ">
                                        <xsl:value-of select="concat('20',substring(../../ArisingDate,9,2))" />
                                    </label>
                                </xsl:when>
                                <xsl:otherwise>
                                    <label  class="fl-l" style="padding-left:55px;">
                                        Ngày <br/> <i>(date)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;text-align:center;">
                                        &#160;
                                    </label>
                                    <label  class="fl-l">
                                        tháng <br/> <i>(month)</i>
                                    </label>
                                    <label class="fl-l input-date"  style=" color:#000000; font-weight:bold;display:block;text-align:center;">
                                        &#160;
                                    </label>
                                    <label  class="fl-l">
                                        năm <br/> <i>(year)</i>
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
                   <!-- <tr>
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
        <tr>
            <td colspan="8">
                <div class="clearfix" id="bt" />
            </td>
        </tr>
    </xsl:template>
    <xsl:template name="addsecondbody">
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
			 <td  style="border:1px solid #000;border-bottom:none!important;border-left:none!important;">
                <div style="float:right;">
					<xsl:choose>
						<xsl:when test="/Invoice/qrCodeData!=''">
							<p style="margin:0px; padding:0px;">
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
        <tr>
            <td colspan="8" style="border:1px solid #000;border-bottom:none!important;border-top:none!important;">
                <div class="clearfix" id="bt" />
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
            <th style="width:300px;">
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
            <th style="width:220px;">
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
                <div style="display: block;word-wrap: break-word;width: 55px;text-align: left;  overflow: hidden; padding-left:5px">
                    <xsl:value-of select="Remark" />
                </div>
            </td>
            <td>
                <div style="display: block;width: 65px;word-wrap: break-word;text-align: left; ">
                    <xsl:value-of select="Code" />
                </div>
            </td>
            <td style="border-left:1px solid #000;border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 75px;text-align: left;  overflow: hidden;">
                    <xsl:choose>
                        <xsl:when test="(ProdQuantity='') or(ProdQuantity=0)">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(ProdQuantity, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
            </td>
            <td>
                <div style="display: block;word-wrap: break-word;width: 295px;text-align: center;  overflow: hidden;">
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
                        <xsl:when test="(ProdPrice=0) or(ProdPrice='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(translate(translate(format-number(ProdPrice, '###,###'),',','?'),'.',','),'?','.')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </td>
            <td style="border-right:1px solid #000;">
                <div style="display: block;word-wrap: break-word;width: 210px;text-align: right; overflow: hidden; float:left;">
                    <xsl:choose>
                        <xsl:when test="(Amount=0) or(Amount='')">
                             
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
				<div style="width:300px; float:left; padding-left:5px;text-align:left;">
					<b>Tổng Số lượng</b><i>(Total Qty)</i>:
					<xsl:choose>
                        <xsl:when test="(../../TOTALQUANTITY=0) or(../../TOTALQUANTITY='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../TOTALQUANTITY, '###,###'),',','?'),'.',','),'?','.')" /></b>
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
				<div style="display: block;word-wrap: break-word;width: 210px;text-align: right; overflow: hidden; float:left;">
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
				<div style="width:300px; float:left;padding-left:5px;text-align:left;">
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
				<div style="display: block;word-wrap: break-word;width: 210px;text-align: right; overflow: hidden; float:left;">
					<xsl:choose>
                        <xsl:when test="(../../VAT_Amount=0) or(../../VAT_Amount='')">
                             
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
			<td style="border:1px solid #000;border-top:none!important;">
				<div style="display: block;word-wrap: break-word;width: 210px;text-align: right; overflow: hidden; float:left;">
					
					<xsl:choose>
                        <xsl:when test="(../../Amount=0) or(../../Amount='')">
                             
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
				<div style="width:170px;float:left;padding-left:5px;text-align:left;"> 
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
				<div style="width:100px;float:left;padding-left:5px;text-align:left;">
					<b>Số tiền thực trả</b><br/> <i style="font-size:11px;">(Payment request)</i>
				</div>				
				<div style="display: block;word-wrap: break-word;width: 105px;text-align: right; overflow: hidden; float:left;">					
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
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../TOTALWEIGHT, '###,###'),',','?'),'.',','),'?','.')" /></b>
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
                            <b><xsl:value-of select="translate(translate(translate(format-number(../../TOTALBP, '###,###'),',','?'),'.',','),'?','.')" /></b>
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
                                            <div class="bgimg" style="width:300px;background:url({/Invoice/image/@URI}) no-repeat left" onclick="showDialog('dialogServer','{$serial}','{$pattern}','{$invno}',0,'messSer','is')">
                                                <p style="color:#eb363a!important">
                                                    <xsl:value-of select="/Invoice/image" />
                                                </p>
                                                <p style="color:#eb363a!important">
                                                    Ký bởi:
													CHI NHÁNH CÔNG TY TNHH MỸ PHẨM THƯỜNG XUÂN
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
					Tra cứu dịch vụ hóa đơn điện tử tại: https://hoadon.vn.oriflame.com với Mã số bí mật: 
					<xsl:choose>
                        <xsl:when test="(../../REFERENCENUM=0) or(../../REFERENCENUM='')">
                             
                        </xsl:when>
                        <xsl:otherwise>
                            <b><xsl:value-of select="../../REFERENCENUM" /></b>
                        </xsl:otherwise>
                    </xsl:choose>
					<!--<xsl:for-each select="../../Extras//Extra_item">
						<xsl:choose>
							<xsl:when test="Extra_Name!='' and Extra_Name='Extra_REFERENCENUM'">
								<xsl:value-of select="translate(translate(translate(format-number(Extra_Value, '###,###'),',','?'),'.',','),'?','.')" />
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>-->
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
                            <div style="float:left;width:950px;">
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
                    size: 21cm 29.7cm;
                    margin: 2mm 8mm 2mm 8mm; /* change the margins as you want them to be. */
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
                    width: 960px !important;
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
                    width:950px!important;
                    border-collapse:collapse;
                    text-align:left;
                    }
                    .headerCom-table label{
                    font-size:12px!important;
                    text-align:left;
                    font-weight:normal;
                    }
                    .ComInfo{
                    font-size:13px!important;
                    padding:1px 0px;
                    word-wrap:break-word;
                    }
                    .ComInfo i{
                    font-size:11px;
                    }
                    .CusInfo{
                    width:720px;
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
					<![CDATA[
        
		<script>
		
		    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE 8");
	   if(msie != -1)
	   {
		
          /*! jQuery v1.7.2 jquery.com | jquery.org/license */
(function (a, b) {
    function cy(a) { return f.isWindow(a) ? a : a.nodeType === 9 ? a.defaultView || a.parentWindow : !1 } function cu(a) { if (!cj[a]) { var b = c.body, d = f("<" + a + ">").appendTo(b), e = d.css("display"); d.remove(); if (e === "none" || e === "") { ck || (ck = c.createElement("iframe"), ck.frameBorder = ck.width = ck.height = 0), b.appendChild(ck); if (!cl || !ck.createElement) cl = (ck.contentWindow || ck.contentDocument).document, cl.write((f.support.boxModel ? "<!doctype html>" : "") + "<html><body>"), cl.close(); d = cl.createElement(a), cl.body.appendChild(d), e = f.css(d, "display"), b.removeChild(ck) } cj[a] = e } return cj[a] } function ct(a, b) { var c = {}; f.each(cp.concat.apply([], cp.slice(0, b)), function () { c[this] = a }); return c } function cs() { cq = b } function cr() { setTimeout(cs, 0); return cq = f.now() } function ci() { try { return new a.ActiveXObject("Microsoft.XMLHTTP") } catch (b) { } } function ch() { try { return new a.XMLHttpRequest } catch (b) { } } function cb(a, c) { a.dataFilter && (c = a.dataFilter(c, a.dataType)); var d = a.dataTypes, e = {}, g, h, i = d.length, j, k = d[0], l, m, n, o, p; for (g = 1; g < i; g++) { if (g === 1) for (h in a.converters) typeof h == "string" && (e[h.toLowerCase()] = a.converters[h]); l = k, k = d[g]; if (k === "*") k = l; else if (l !== "*" && l !== k) { m = l + " " + k, n = e[m] || e["* " + k]; if (!n) { p = b; for (o in e) { j = o.split(" "); if (j[0] === l || j[0] === "*") { p = e[j[1] + " " + k]; if (p) { o = e[o], o === !0 ? n = p : p === !0 && (n = o); break } } } } !n && !p && f.error("No conversion from " + m.replace(" ", " to ")), n !== !0 && (c = n ? n(c) : p(o(c))) } } return c } function ca(a, c, d) { var e = a.contents, f = a.dataTypes, g = a.responseFields, h, i, j, k; for (i in g) i in d && (c[g[i]] = d[i]); while (f[0] === "*") f.shift(), h === b && (h = a.mimeType || c.getResponseHeader("content-type")); if (h) for (i in e) if (e[i] && e[i].test(h)) { f.unshift(i); break } if (f[0] in d) j = f[0]; else { for (i in d) { if (!f[0] || a.converters[i + " " + f[0]]) { j = i; break } k || (k = i) } j = j || k } if (j) { j !== f[0] && f.unshift(j); return d[j] } } function b_(a, b, c, d) { if (f.isArray(b)) f.each(b, function (b, e) { c || bD.test(a) ? d(a, e) : b_(a + "[" + (typeof e == "object" ? b : "") + "]", e, c, d) }); else if (!c && f.type(b) === "object") for (var e in b) b_(a + "[" + e + "]", b[e], c, d); else d(a, b) } function b$(a, c) { var d, e, g = f.ajaxSettings.flatOptions || {}; for (d in c) c[d] !== b && ((g[d] ? a : e || (e = {}))[d] = c[d]); e && f.extend(!0, a, e) } function bZ(a, c, d, e, f, g) { f = f || c.dataTypes[0], g = g || {}, g[f] = !0; var h = a[f], i = 0, j = h ? h.length : 0, k = a === bS, l; for (; i < j && (k || !l) ; i++) l = h[i](c, d, e), typeof l == "string" && (!k || g[l] ? l = b : (c.dataTypes.unshift(l), l = bZ(a, c, d, e, l, g))); (k || !l) && !g["*"] && (l = bZ(a, c, d, e, "*", g)); return l } function bY(a) { return function (b, c) { typeof b != "string" && (c = b, b = "*"); if (f.isFunction(c)) { var d = b.toLowerCase().split(bO), e = 0, g = d.length, h, i, j; for (; e < g; e++) h = d[e], j = /^\+/.test(h), j && (h = h.substr(1) || "*"), i = a[h] = a[h] || [], i[j ? "unshift" : "push"](c) } } } function bB(a, b, c) { var d = b === "width" ? a.offsetWidth : a.offsetHeight, e = b === "width" ? 1 : 0, g = 4; if (d > 0) { if (c !== "border") for (; e < g; e += 2) c || (d -= parseFloat(f.css(a, "padding" + bx[e])) || 0), c === "margin" ? d += parseFloat(f.css(a, c + bx[e])) || 0 : d -= parseFloat(f.css(a, "border" + bx[e] + "Width")) || 0; return d + "px" } d = by(a, b); if (d < 0 || d == null) d = a.style[b]; if (bt.test(d)) return d; d = parseFloat(d) || 0; if (c) for (; e < g; e += 2) d += parseFloat(f.css(a, "padding" + bx[e])) || 0, c !== "padding" && (d += parseFloat(f.css(a, "border" + bx[e] + "Width")) || 0), c === "margin" && (d += parseFloat(f.css(a, c + bx[e])) || 0); return d + "px" } function bo(a) { var b = c.createElement("div"); bh.appendChild(b), b.innerHTML = a.outerHTML; return b.firstChild } function bn(a) { var b = (a.nodeName || "").toLowerCase(); b === "input" ? bm(a) : b !== "script" && typeof a.getElementsByTagName != "undefined" && f.grep(a.getElementsByTagName("input"), bm) } function bm(a) { if (a.type === "checkbox" || a.type === "radio") a.defaultChecked = a.checked } function bl(a) { return typeof a.getElementsByTagName != "undefined" ? a.getElementsByTagName("*") : typeof a.querySelectorAll != "undefined" ? a.querySelectorAll("*") : [] } function bk(a, b) { var c; b.nodeType === 1 && (b.clearAttributes && b.clearAttributes(), b.mergeAttributes && b.mergeAttributes(a), c = b.nodeName.toLowerCase(), c === "object" ? b.outerHTML = a.outerHTML : c !== "input" || a.type !== "checkbox" && a.type !== "radio" ? c === "option" ? b.selected = a.defaultSelected : c === "input" || c === "textarea" ? b.defaultValue = a.defaultValue : c === "script" && b.text !== a.text && (b.text = a.text) : (a.checked && (b.defaultChecked = b.checked = a.checked), b.value !== a.value && (b.value = a.value)), b.removeAttribute(f.expando), b.removeAttribute("_submit_attached"), b.removeAttribute("_change_attached")) } function bj(a, b) { if (b.nodeType === 1 && !!f.hasData(a)) { var c, d, e, g = f._data(a), h = f._data(b, g), i = g.events; if (i) { delete h.handle, h.events = {}; for (c in i) for (d = 0, e = i[c].length; d < e; d++) f.event.add(b, c, i[c][d]) } h.data && (h.data = f.extend({}, h.data)) } } function bi(a, b) { return f.nodeName(a, "table") ? a.getElementsByTagName("tbody")[0] || a.appendChild(a.ownerDocument.createElement("tbody")) : a } function U(a) { var b = V.split("|"), c = a.createDocumentFragment(); if (c.createElement) while (b.length) c.createElement(b.pop()); return c } function T(a, b, c) { b = b || 0; if (f.isFunction(b)) return f.grep(a, function (a, d) { var e = !!b.call(a, d, a); return e === c }); if (b.nodeType) return f.grep(a, function (a, d) { return a === b === c }); if (typeof b == "string") { var d = f.grep(a, function (a) { return a.nodeType === 1 }); if (O.test(b)) return f.filter(b, d, !c); b = f.filter(b, d) } return f.grep(a, function (a, d) { return f.inArray(a, b) >= 0 === c }) } function S(a) { return !a || !a.parentNode || a.parentNode.nodeType === 11 } function K() { return !0 } function J() { return !1 } function n(a, b, c) { var d = b + "defer", e = b + "queue", g = b + "mark", h = f._data(a, d); h && (c === "queue" || !f._data(a, e)) && (c === "mark" || !f._data(a, g)) && setTimeout(function () { !f._data(a, e) && !f._data(a, g) && (f.removeData(a, d, !0), h.fire()) }, 0) } function m(a) { for (var b in a) { if (b === "data" && f.isEmptyObject(a[b])) continue; if (b !== "toJSON") return !1 } return !0 } function l(a, c, d) { if (d === b && a.nodeType === 1) { var e = "data-" + c.replace(k, "-$1").toLowerCase(); d = a.getAttribute(e); if (typeof d == "string") { try { d = d === "true" ? !0 : d === "false" ? !1 : d === "null" ? null : f.isNumeric(d) ? +d : j.test(d) ? f.parseJSON(d) : d } catch (g) { } f.data(a, c, d) } else d = b } return d } function h(a) { var b = g[a] = {}, c, d; a = a.split(/\s+/); for (c = 0, d = a.length; c < d; c++) b[a[c]] = !0; return b } var c = a.document, d = a.navigator, e = a.location, f = function () { function J() { if (!e.isReady) { try { c.documentElement.doScroll("left") } catch (a) { setTimeout(J, 1); return } e.ready() } } var e = function (a, b) { return new e.fn.init(a, b, h) }, f = a.jQuery, g = a.$, h, i = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/, j = /\S/, k = /^\s+/, l = /\s+$/, m = /^<(\w+)\s*\/?>(?:<\/\1>)?$/, n = /^[\],:{}\s]*$/, o = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, p = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, q = /(?:^|:|,)(?:\s*\[)+/g, r = /(webkit)[ \/]([\w.]+)/, s = /(opera)(?:.*version)?[ \/]([\w.]+)/, t = /(msie) ([\w.]+)/, u = /(mozilla)(?:.*? rv:([\w.]+))?/, v = /-([a-z]|[0-9])/ig, w = /^-ms-/, x = function (a, b) { return (b + "").toUpperCase() }, y = d.userAgent, z, A, B, C = Object.prototype.toString, D = Object.prototype.hasOwnProperty, E = Array.prototype.push, F = Array.prototype.slice, G = String.prototype.trim, H = Array.prototype.indexOf, I = {}; e.fn = e.prototype = { constructor: e, init: function (a, d, f) { var g, h, j, k; if (!a) return this; if (a.nodeType) { this.context = this[0] = a, this.length = 1; return this } if (a === "body" && !d && c.body) { this.context = c, this[0] = c.body, this.selector = a, this.length = 1; return this } if (typeof a == "string") { a.charAt(0) !== "<" || a.charAt(a.length - 1) !== ">" || a.length < 3 ? g = i.exec(a) : g = [null, a, null]; if (g && (g[1] || !d)) { if (g[1]) { d = d instanceof e ? d[0] : d, k = d ? d.ownerDocument || d : c, j = m.exec(a), j ? e.isPlainObject(d) ? (a = [c.createElement(j[1])], e.fn.attr.call(a, d, !0)) : a = [k.createElement(j[1])] : (j = e.buildFragment([g[1]], [k]), a = (j.cacheable ? e.clone(j.fragment) : j.fragment).childNodes); return e.merge(this, a) } h = c.getElementById(g[2]); if (h && h.parentNode) { if (h.id !== g[2]) return f.find(a); this.length = 1, this[0] = h } this.context = c, this.selector = a; return this } return !d || d.jquery ? (d || f).find(a) : this.constructor(d).find(a) } if (e.isFunction(a)) return f.ready(a); a.selector !== b && (this.selector = a.selector, this.context = a.context); return e.makeArray(a, this) }, selector: "", jquery: "1.7.2", length: 0, size: function () { return this.length }, toArray: function () { return F.call(this, 0) }, get: function (a) { return a == null ? this.toArray() : a < 0 ? this[this.length + a] : this[a] }, pushStack: function (a, b, c) { var d = this.constructor(); e.isArray(a) ? E.apply(d, a) : e.merge(d, a), d.prevObject = this, d.context = this.context, b === "find" ? d.selector = this.selector + (this.selector ? " " : "") + c : b && (d.selector = this.selector + "." + b + "(" + c + ")"); return d }, each: function (a, b) { return e.each(this, a, b) }, ready: function (a) { e.bindReady(), A.add(a); return this }, eq: function (a) { a = +a; return a === -1 ? this.slice(a) : this.slice(a, a + 1) }, first: function () { return this.eq(0) }, last: function () { return this.eq(-1) }, slice: function () { return this.pushStack(F.apply(this, arguments), "slice", F.call(arguments).join(",")) }, map: function (a) { return this.pushStack(e.map(this, function (b, c) { return a.call(b, c, b) })) }, end: function () { return this.prevObject || this.constructor(null) }, push: E, sort: [].sort, splice: [].splice }, e.fn.init.prototype = e.fn, e.extend = e.fn.extend = function () { var a, c, d, f, g, h, i = arguments[0] || {}, j = 1, k = arguments.length, l = !1; typeof i == "boolean" && (l = i, i = arguments[1] || {}, j = 2), typeof i != "object" && !e.isFunction(i) && (i = {}), k === j && (i = this, --j); for (; j < k; j++) if ((a = arguments[j]) != null) for (c in a) { d = i[c], f = a[c]; if (i === f) continue; l && f && (e.isPlainObject(f) || (g = e.isArray(f))) ? (g ? (g = !1, h = d && e.isArray(d) ? d : []) : h = d && e.isPlainObject(d) ? d : {}, i[c] = e.extend(l, h, f)) : f !== b && (i[c] = f) } return i }, e.extend({ noConflict: function (b) { a.$ === e && (a.$ = g), b && a.jQuery === e && (a.jQuery = f); return e }, isReady: !1, readyWait: 1, holdReady: function (a) { a ? e.readyWait++ : e.ready(!0) }, ready: function (a) { if (a === !0 && !--e.readyWait || a !== !0 && !e.isReady) { if (!c.body) return setTimeout(e.ready, 1); e.isReady = !0; if (a !== !0 && --e.readyWait > 0) return; A.fireWith(c, [e]), e.fn.trigger && e(c).trigger("ready").off("ready") } }, bindReady: function () { if (!A) { A = e.Callbacks("once memory"); if (c.readyState === "complete") return setTimeout(e.ready, 1); if (c.addEventListener) c.addEventListener("DOMContentLoaded", B, !1), a.addEventListener("load", e.ready, !1); else if (c.attachEvent) { c.attachEvent("onreadystatechange", B), a.attachEvent("onload", e.ready); var b = !1; try { b = a.frameElement == null } catch (d) { } c.documentElement.doScroll && b && J() } } }, isFunction: function (a) { return e.type(a) === "function" }, isArray: Array.isArray || function (a) { return e.type(a) === "array" }, isWindow: function (a) { return a != null && a == a.window }, isNumeric: function (a) { return !isNaN(parseFloat(a)) && isFinite(a) }, type: function (a) { return a == null ? String(a) : I[C.call(a)] || "object" }, isPlainObject: function (a) { if (!a || e.type(a) !== "object" || a.nodeType || e.isWindow(a)) return !1; try { if (a.constructor && !D.call(a, "constructor") && !D.call(a.constructor.prototype, "isPrototypeOf")) return !1 } catch (c) { return !1 } var d; for (d in a); return d === b || D.call(a, d) }, isEmptyObject: function (a) { for (var b in a) return !1; return !0 }, error: function (a) { throw new Error(a) }, parseJSON: function (b) { if (typeof b != "string" || !b) return null; b = e.trim(b); if (a.JSON && a.JSON.parse) return a.JSON.parse(b); if (n.test(b.replace(o, "@").replace(p, "]").replace(q, ""))) return (new Function("return " + b))(); e.error("Invalid JSON: " + b) }, parseXML: function (c) { if (typeof c != "string" || !c) return null; var d, f; try { a.DOMParser ? (f = new DOMParser, d = f.parseFromString(c, "text/xml")) : (d = new ActiveXObject("Microsoft.XMLDOM"), d.async = "false", d.loadXML(c)) } catch (g) { d = b } (!d || !d.documentElement || d.getElementsByTagName("parsererror").length) && e.error("Invalid XML: " + c); return d }, noop: function () { }, globalEval: function (b) { b && j.test(b) && (a.execScript || function (b) { a.eval.call(a, b) })(b) }, camelCase: function (a) { return a.replace(w, "ms-").replace(v, x) }, nodeName: function (a, b) { return a.nodeName && a.nodeName.toUpperCase() === b.toUpperCase() }, each: function (a, c, d) { var f, g = 0, h = a.length, i = h === b || e.isFunction(a); if (d) { if (i) { for (f in a) if (c.apply(a[f], d) === !1) break } else for (; g < h;) if (c.apply(a[g++], d) === !1) break } else if (i) { for (f in a) if (c.call(a[f], f, a[f]) === !1) break } else for (; g < h;) if (c.call(a[g], g, a[g++]) === !1) break; return a }, trim: G ? function (a) { return a == null ? "" : G.call(a) } : function (a) { return a == null ? "" : (a + "").replace(k, "").replace(l, "") }, makeArray: function (a, b) { var c = b || []; if (a != null) { var d = e.type(a); a.length == null || d === "string" || d === "function" || d === "regexp" || e.isWindow(a) ? E.call(c, a) : e.merge(c, a) } return c }, inArray: function (a, b, c) { var d; if (b) { if (H) return H.call(b, a, c); d = b.length, c = c ? c < 0 ? Math.max(0, d + c) : c : 0; for (; c < d; c++) if (c in b && b[c] === a) return c } return -1 }, merge: function (a, c) { var d = a.length, e = 0; if (typeof c.length == "number") for (var f = c.length; e < f; e++) a[d++] = c[e]; else while (c[e] !== b) a[d++] = c[e++]; a.length = d; return a }, grep: function (a, b, c) { var d = [], e; c = !!c; for (var f = 0, g = a.length; f < g; f++) e = !!b(a[f], f), c !== e && d.push(a[f]); return d }, map: function (a, c, d) { var f, g, h = [], i = 0, j = a.length, k = a instanceof e || j !== b && typeof j == "number" && (j > 0 && a[0] && a[j - 1] || j === 0 || e.isArray(a)); if (k) for (; i < j; i++) f = c(a[i], i, d), f != null && (h[h.length] = f); else for (g in a) f = c(a[g], g, d), f != null && (h[h.length] = f); return h.concat.apply([], h) }, guid: 1, proxy: function (a, c) { if (typeof c == "string") { var d = a[c]; c = a, a = d } if (!e.isFunction(a)) return b; var f = F.call(arguments, 2), g = function () { return a.apply(c, f.concat(F.call(arguments))) }; g.guid = a.guid = a.guid || g.guid || e.guid++; return g }, access: function (a, c, d, f, g, h, i) { var j, k = d == null, l = 0, m = a.length; if (d && typeof d == "object") { for (l in d) e.access(a, c, l, d[l], 1, h, f); g = 1 } else if (f !== b) { j = i === b && e.isFunction(f), k && (j ? (j = c, c = function (a, b, c) { return j.call(e(a), c) }) : (c.call(a, f), c = null)); if (c) for (; l < m; l++) c(a[l], d, j ? f.call(a[l], l, c(a[l], d)) : f, i); g = 1 } return g ? a : k ? c.call(a) : m ? c(a[0], d) : h }, now: function () { return (new Date).getTime() }, uaMatch: function (a) { a = a.toLowerCase(); var b = r.exec(a) || s.exec(a) || t.exec(a) || a.indexOf("compatible") < 0 && u.exec(a) || []; return { browser: b[1] || "", version: b[2] || "0" } }, sub: function () { function a(b, c) { return new a.fn.init(b, c) } e.extend(!0, a, this), a.superclass = this, a.fn = a.prototype = this(), a.fn.constructor = a, a.sub = this.sub, a.fn.init = function (d, f) { f && f instanceof e && !(f instanceof a) && (f = a(f)); return e.fn.init.call(this, d, f, b) }, a.fn.init.prototype = a.fn; var b = a(c); return a }, browser: {} }), e.each("Boolean Number String Function Array Date RegExp Object".split(" "), function (a, b) { I["[object " + b + "]"] = b.toLowerCase() }), z = e.uaMatch(y), z.browser && (e.browser[z.browser] = !0, e.browser.version = z.version), e.browser.webkit && (e.browser.safari = !0), j.test(" ") && (k = /^[\s\xA0]+/, l = /[\s\xA0]+$/), h = e(c), c.addEventListener ? B = function () { c.removeEventListener("DOMContentLoaded", B, !1), e.ready() } : c.attachEvent && (B = function () { c.readyState === "complete" && (c.detachEvent("onreadystatechange", B), e.ready()) }); return e }(), g = {}; f.Callbacks = function (a) { a = a ? g[a] || h(a) : {}; var c = [], d = [], e, i, j, k, l, m, n = function (b) { var d, e, g, h, i; for (d = 0, e = b.length; d < e; d++) g = b[d], h = f.type(g), h === "array" ? n(g) : h === "function" && (!a.unique || !p.has(g)) && c.push(g) }, o = function (b, f) { f = f || [], e = !a.memory || [b, f], i = !0, j = !0, m = k || 0, k = 0, l = c.length; for (; c && m < l; m++) if (c[m].apply(b, f) === !1 && a.stopOnFalse) { e = !0; break } j = !1, c && (a.once ? e === !0 ? p.disable() : c = [] : d && d.length && (e = d.shift(), p.fireWith(e[0], e[1]))) }, p = { add: function () { if (c) { var a = c.length; n(arguments), j ? l = c.length : e && e !== !0 && (k = a, o(e[0], e[1])) } return this }, remove: function () { if (c) { var b = arguments, d = 0, e = b.length; for (; d < e; d++) for (var f = 0; f < c.length; f++) if (b[d] === c[f]) { j && f <= l && (l--, f <= m && m--), c.splice(f--, 1); if (a.unique) break } } return this }, has: function (a) { if (c) { var b = 0, d = c.length; for (; b < d; b++) if (a === c[b]) return !0 } return !1 }, empty: function () { c = []; return this }, disable: function () { c = d = e = b; return this }, disabled: function () { return !c }, lock: function () { d = b, (!e || e === !0) && p.disable(); return this }, locked: function () { return !d }, fireWith: function (b, c) { d && (j ? a.once || d.push([b, c]) : (!a.once || !e) && o(b, c)); return this }, fire: function () { p.fireWith(this, arguments); return this }, fired: function () { return !!i } }; return p }; var i = [].slice; f.extend({ Deferred: function (a) { var b = f.Callbacks("once memory"), c = f.Callbacks("once memory"), d = f.Callbacks("memory"), e = "pending", g = { resolve: b, reject: c, notify: d }, h = { done: b.add, fail: c.add, progress: d.add, state: function () { return e }, isResolved: b.fired, isRejected: c.fired, then: function (a, b, c) { i.done(a).fail(b).progress(c); return this }, always: function () { i.done.apply(i, arguments).fail.apply(i, arguments); return this }, pipe: function (a, b, c) { return f.Deferred(function (d) { f.each({ done: [a, "resolve"], fail: [b, "reject"], progress: [c, "notify"] }, function (a, b) { var c = b[0], e = b[1], g; f.isFunction(c) ? i[a](function () { g = c.apply(this, arguments), g && f.isFunction(g.promise) ? g.promise().then(d.resolve, d.reject, d.notify) : d[e + "With"](this === i ? d : this, [g]) }) : i[a](d[e]) }) }).promise() }, promise: function (a) { if (a == null) a = h; else for (var b in h) a[b] = h[b]; return a } }, i = h.promise({}), j; for (j in g) i[j] = g[j].fire, i[j + "With"] = g[j].fireWith; i.done(function () { e = "resolved" }, c.disable, d.lock).fail(function () { e = "rejected" }, b.disable, d.lock), a && a.call(i, i); return i }, when: function (a) { function m(a) { return function (b) { e[a] = arguments.length > 1 ? i.call(arguments, 0) : b, j.notifyWith(k, e) } } function l(a) { return function (c) { b[a] = arguments.length > 1 ? i.call(arguments, 0) : c, --g || j.resolveWith(j, b) } } var b = i.call(arguments, 0), c = 0, d = b.length, e = Array(d), g = d, h = d, j = d <= 1 && a && f.isFunction(a.promise) ? a : f.Deferred(), k = j.promise(); if (d > 1) { for (; c < d; c++) b[c] && b[c].promise && f.isFunction(b[c].promise) ? b[c].promise().then(l(c), j.reject, m(c)) : --g; g || j.resolveWith(j, b) } else j !== a && j.resolveWith(j, d ? [a] : []); return k } }), f.support = function () { var b, d, e, g, h, i, j, k, l, m, n, o, p = c.createElement("div"), q = c.documentElement; p.setAttribute("className", "t"), p.innerHTML = "   <link/><table></table><a href='/a' style='top:1px;float:left;opacity:.55;'>a</a><input type='checkbox'/>", d = p.getElementsByTagName("*"), e = p.getElementsByTagName("a")[0]; if (!d || !d.length || !e) return {}; g = c.createElement("select"), h = g.appendChild(c.createElement("option")), i = p.getElementsByTagName("input")[0], b = { leadingWhitespace: p.firstChild.nodeType === 3, tbody: !p.getElementsByTagName("tbody").length, htmlSerialize: !!p.getElementsByTagName("link").length, style: /top/.test(e.getAttribute("style")), hrefNormalized: e.getAttribute("href") === "/a", opacity: /^0.55/.test(e.style.opacity), cssFloat: !!e.style.cssFloat, checkOn: i.value === "on", optSelected: h.selected, getSetAttribute: p.className !== "t", enctype: !!c.createElement("form").enctype, html5Clone: c.createElement("nav").cloneNode(!0).outerHTML !== "<:nav></:nav>", submitBubbles: !0, changeBubbles: !0, focusinBubbles: !1, deleteExpando: !0, noCloneEvent: !0, inlineBlockNeedsLayout: !1, shrinkWrapBlocks: !1, reliableMarginRight: !0, pixelMargin: !0 }, f.boxModel = b.boxModel = c.compatMode === "CSS1Compat", i.checked = !0, b.noCloneChecked = i.cloneNode(!0).checked, g.disabled = !0, b.optDisabled = !h.disabled; try { delete p.test } catch (r) { b.deleteExpando = !1 } !p.addEventListener && p.attachEvent && p.fireEvent && (p.attachEvent("onclick", function () { b.noCloneEvent = !1 }), p.cloneNode(!0).fireEvent("onclick")), i = c.createElement("input"), i.value = "t", i.setAttribute("type", "radio"), b.radioValue = i.value === "t", i.setAttribute("checked", "checked"), i.setAttribute("name", "t"), p.appendChild(i), j = c.createDocumentFragment(), j.appendChild(p.lastChild), b.checkClone = j.cloneNode(!0).cloneNode(!0).lastChild.checked, b.appendChecked = i.checked, j.removeChild(i), j.appendChild(p); if (p.attachEvent) for (n in { submit: 1, change: 1, focusin: 1 }) m = "on" + n, o = m in p, o || (p.setAttribute(m, "return;"), o = typeof p[m] == "function"), b[n + "Bubbles"] = o; j.removeChild(p), j = g = h = p = i = null, f(function () { var d, e, g, h, i, j, l, m, n, q, r, s, t, u = c.getElementsByTagName("body")[0]; !u || (m = 1, t = "padding:0;margin:0;border:", r = "position:absolute;top:0;left:0;width:1px;height:1px;", s = t + "0;visibility:hidden;", n = "style='" + r + t + "5px solid #524570;", q = "<div " + n + "display:block;'><div style='" + t + "0;display:block;overflow:hidden;'></div></div>" + "<table " + n + "' cellpadding='0' cellspacing='0'>" + "<tr><td></td></tr></table>", d = c.createElement("div"), d.style.cssText = s + "width:0;height:0;position:static;top:0;margin-top:" + m + "px", u.insertBefore(d, u.firstChild), p = c.createElement("div"), d.appendChild(p), p.innerHTML = "<table><tr><td style='" + t + "0;display:none'></td><td>t</td></tr></table>", k = p.getElementsByTagName("td"), o = k[0].offsetHeight === 0, k[0].style.display = "", k[1].style.display = "none", b.reliableHiddenOffsets = o && k[0].offsetHeight === 0, a.getComputedStyle && (p.innerHTML = "", l = c.createElement("div"), l.style.width = "0", l.style.marginRight = "0", p.style.width = "2px", p.appendChild(l), b.reliableMarginRight = (parseInt((a.getComputedStyle(l, null) || { marginRight: 0 }).marginRight, 10) || 0) === 0), typeof p.style.zoom != "undefined" && (p.innerHTML = "", p.style.width = p.style.padding = "1px", p.style.border = 0, p.style.overflow = "hidden", p.style.display = "inline", p.style.zoom = 1, b.inlineBlockNeedsLayout = p.offsetWidth === 3, p.style.display = "block", p.style.overflow = "visible", p.innerHTML = "<div style='width:5px;'></div>", b.shrinkWrapBlocks = p.offsetWidth !== 3), p.style.cssText = r + s, p.innerHTML = q, e = p.firstChild, g = e.firstChild, i = e.nextSibling.firstChild.firstChild, j = { doesNotAddBorder: g.offsetTop !== 5, doesAddBorderForTableAndCells: i.offsetTop === 5 }, g.style.position = "fixed", g.style.top = "20px", j.fixedPosition = g.offsetTop === 20 || g.offsetTop === 15, g.style.position = g.style.top = "", e.style.overflow = "hidden", e.style.position = "relative", j.subtractsBorderForOverflowNotVisible = g.offsetTop === -5, j.doesNotIncludeMarginInBodyOffset = u.offsetTop !== m, a.getComputedStyle && (p.style.marginTop = "1%", b.pixelMargin = (a.getComputedStyle(p, null) || { marginTop: 0 }).marginTop !== "1%"), typeof d.style.zoom != "undefined" && (d.style.zoom = 1), u.removeChild(d), l = p = d = null, f.extend(b, j)) }); return b }(); var j = /^(?:\{.*\}|\[.*\])$/, k = /([A-Z])/g; f.extend({ cache: {}, uuid: 0, expando: "jQuery" + (f.fn.jquery + Math.random()).replace(/\D/g, ""), noData: { embed: !0, object: "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000", applet: !0 }, hasData: function (a) { a = a.nodeType ? f.cache[a[f.expando]] : a[f.expando]; return !!a && !m(a) }, data: function (a, c, d, e) { if (!!f.acceptData(a)) { var g, h, i, j = f.expando, k = typeof c == "string", l = a.nodeType, m = l ? f.cache : a, n = l ? a[j] : a[j] && j, o = c === "events"; if ((!n || !m[n] || !o && !e && !m[n].data) && k && d === b) return; n || (l ? a[j] = n = ++f.uuid : n = j), m[n] || (m[n] = {}, l || (m[n].toJSON = f.noop)); if (typeof c == "object" || typeof c == "function") e ? m[n] = f.extend(m[n], c) : m[n].data = f.extend(m[n].data, c); g = h = m[n], e || (h.data || (h.data = {}), h = h.data), d !== b && (h[f.camelCase(c)] = d); if (o && !h[c]) return g.events; k ? (i = h[c], i == null && (i = h[f.camelCase(c)])) : i = h; return i } }, removeData: function (a, b, c) { if (!!f.acceptData(a)) { var d, e, g, h = f.expando, i = a.nodeType, j = i ? f.cache : a, k = i ? a[h] : h; if (!j[k]) return; if (b) { d = c ? j[k] : j[k].data; if (d) { f.isArray(b) || (b in d ? b = [b] : (b = f.camelCase(b), b in d ? b = [b] : b = b.split(" "))); for (e = 0, g = b.length; e < g; e++) delete d[b[e]]; if (!(c ? m : f.isEmptyObject)(d)) return } } if (!c) { delete j[k].data; if (!m(j[k])) return } f.support.deleteExpando || !j.setInterval ? delete j[k] : j[k] = null, i && (f.support.deleteExpando ? delete a[h] : a.removeAttribute ? a.removeAttribute(h) : a[h] = null) } }, _data: function (a, b, c) { return f.data(a, b, c, !0) }, acceptData: function (a) { if (a.nodeName) { var b = f.noData[a.nodeName.toLowerCase()]; if (b) return b !== !0 && a.getAttribute("classid") === b } return !0 } }), f.fn.extend({ data: function (a, c) { var d, e, g, h, i, j = this[0], k = 0, m = null; if (a === b) { if (this.length) { m = f.data(j); if (j.nodeType === 1 && !f._data(j, "parsedAttrs")) { g = j.attributes; for (i = g.length; k < i; k++) h = g[k].name, h.indexOf("data-") === 0 && (h = f.camelCase(h.substring(5)), l(j, h, m[h])); f._data(j, "parsedAttrs", !0) } } return m } if (typeof a == "object") return this.each(function () { f.data(this, a) }); d = a.split(".", 2), d[1] = d[1] ? "." + d[1] : "", e = d[1] + "!"; return f.access(this, function (c) { if (c === b) { m = this.triggerHandler("getData" + e, [d[0]]), m === b && j && (m = f.data(j, a), m = l(j, a, m)); return m === b && d[1] ? this.data(d[0]) : m } d[1] = c, this.each(function () { var b = f(this); b.triggerHandler("setData" + e, d), f.data(this, a, c), b.triggerHandler("changeData" + e, d) }) }, null, c, arguments.length > 1, null, !1) }, removeData: function (a) { return this.each(function () { f.removeData(this, a) }) } }), f.extend({ _mark: function (a, b) { a && (b = (b || "fx") + "mark", f._data(a, b, (f._data(a, b) || 0) + 1)) }, _unmark: function (a, b, c) { a !== !0 && (c = b, b = a, a = !1); if (b) { c = c || "fx"; var d = c + "mark", e = a ? 0 : (f._data(b, d) || 1) - 1; e ? f._data(b, d, e) : (f.removeData(b, d, !0), n(b, c, "mark")) } }, queue: function (a, b, c) { var d; if (a) { b = (b || "fx") + "queue", d = f._data(a, b), c && (!d || f.isArray(c) ? d = f._data(a, b, f.makeArray(c)) : d.push(c)); return d || [] } }, dequeue: function (a, b) { b = b || "fx"; var c = f.queue(a, b), d = c.shift(), e = {}; d === "inprogress" && (d = c.shift()), d && (b === "fx" && c.unshift("inprogress"), f._data(a, b + ".run", e), d.call(a, function () { f.dequeue(a, b) }, e)), c.length || (f.removeData(a, b + "queue " + b + ".run", !0), n(a, b, "queue")) } }), f.fn.extend({ queue: function (a, c) { var d = 2; typeof a != "string" && (c = a, a = "fx", d--); if (arguments.length < d) return f.queue(this[0], a); return c === b ? this : this.each(function () { var b = f.queue(this, a, c); a === "fx" && b[0] !== "inprogress" && f.dequeue(this, a) }) }, dequeue: function (a) { return this.each(function () { f.dequeue(this, a) }) }, delay: function (a, b) { a = f.fx ? f.fx.speeds[a] || a : a, b = b || "fx"; return this.queue(b, function (b, c) { var d = setTimeout(b, a); c.stop = function () { clearTimeout(d) } }) }, clearQueue: function (a) { return this.queue(a || "fx", []) }, promise: function (a, c) { function m() { --h || d.resolveWith(e, [e]) } typeof a != "string" && (c = a, a = b), a = a || "fx"; var d = f.Deferred(), e = this, g = e.length, h = 1, i = a + "defer", j = a + "queue", k = a + "mark", l; while (g--) if (l = f.data(e[g], i, b, !0) || (f.data(e[g], j, b, !0) || f.data(e[g], k, b, !0)) && f.data(e[g], i, f.Callbacks("once memory"), !0)) h++, l.add(m); m(); return d.promise(c) } }); var o = /[\n\t\r]/g, p = /\s+/, q = /\r/g, r = /^(?:button|input)$/i, s = /^(?:button|input|object|select|textarea)$/i, t = /^a(?:rea)?$/i, u = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i, v = f.support.getSetAttribute, w, x, y; f.fn.extend({ attr: function (a, b) { return f.access(this, f.attr, a, b, arguments.length > 1) }, removeAttr: function (a) { return this.each(function () { f.removeAttr(this, a) }) }, prop: function (a, b) { return f.access(this, f.prop, a, b, arguments.length > 1) }, removeProp: function (a) { a = f.propFix[a] || a; return this.each(function () { try { this[a] = b, delete this[a] } catch (c) { } }) }, addClass: function (a) { var b, c, d, e, g, h, i; if (f.isFunction(a)) return this.each(function (b) { f(this).addClass(a.call(this, b, this.className)) }); if (a && typeof a == "string") { b = a.split(p); for (c = 0, d = this.length; c < d; c++) { e = this[c]; if (e.nodeType === 1) if (!e.className && b.length === 1) e.className = a; else { g = " " + e.className + " "; for (h = 0, i = b.length; h < i; h++) ~g.indexOf(" " + b[h] + " ") || (g += b[h] + " "); e.className = f.trim(g) } } } return this }, removeClass: function (a) { var c, d, e, g, h, i, j; if (f.isFunction(a)) return this.each(function (b) { f(this).removeClass(a.call(this, b, this.className)) }); if (a && typeof a == "string" || a === b) { c = (a || "").split(p); for (d = 0, e = this.length; d < e; d++) { g = this[d]; if (g.nodeType === 1 && g.className) if (a) { h = (" " + g.className + " ").replace(o, " "); for (i = 0, j = c.length; i < j; i++) h = h.replace(" " + c[i] + " ", " "); g.className = f.trim(h) } else g.className = "" } } return this }, toggleClass: function (a, b) { var c = typeof a, d = typeof b == "boolean"; if (f.isFunction(a)) return this.each(function (c) { f(this).toggleClass(a.call(this, c, this.className, b), b) }); return this.each(function () { if (c === "string") { var e, g = 0, h = f(this), i = b, j = a.split(p); while (e = j[g++]) i = d ? i : !h.hasClass(e), h[i ? "addClass" : "removeClass"](e) } else if (c === "undefined" || c === "boolean") this.className && f._data(this, "__className__", this.className), this.className = this.className || a === !1 ? "" : f._data(this, "__className__") || "" }) }, hasClass: function (a) { var b = " " + a + " ", c = 0, d = this.length; for (; c < d; c++) if (this[c].nodeType === 1 && (" " + this[c].className + " ").replace(o, " ").indexOf(b) > -1) return !0; return !1 }, val: function (a) { var c, d, e, g = this[0]; { if (!!arguments.length) { e = f.isFunction(a); return this.each(function (d) { var g = f(this), h; if (this.nodeType === 1) { e ? h = a.call(this, d, g.val()) : h = a, h == null ? h = "" : typeof h == "number" ? h += "" : f.isArray(h) && (h = f.map(h, function (a) { return a == null ? "" : a + "" })), c = f.valHooks[this.type] || f.valHooks[this.nodeName.toLowerCase()]; if (!c || !("set" in c) || c.set(this, h, "value") === b) this.value = h } }) } if (g) { c = f.valHooks[g.type] || f.valHooks[g.nodeName.toLowerCase()]; if (c && "get" in c && (d = c.get(g, "value")) !== b) return d; d = g.value; return typeof d == "string" ? d.replace(q, "") : d == null ? "" : d } } } }), f.extend({ valHooks: { option: { get: function (a) { var b = a.attributes.value; return !b || b.specified ? a.value : a.text } }, select: { get: function (a) { var b, c, d, e, g = a.selectedIndex, h = [], i = a.options, j = a.type === "select-one"; if (g < 0) return null; c = j ? g : 0, d = j ? g + 1 : i.length; for (; c < d; c++) { e = i[c]; if (e.selected && (f.support.optDisabled ? !e.disabled : e.getAttribute("disabled") === null) && (!e.parentNode.disabled || !f.nodeName(e.parentNode, "optgroup"))) { b = f(e).val(); if (j) return b; h.push(b) } } if (j && !h.length && i.length) return f(i[g]).val(); return h }, set: function (a, b) { var c = f.makeArray(b); f(a).find("option").each(function () { this.selected = f.inArray(f(this).val(), c) >= 0 }), c.length || (a.selectedIndex = -1); return c } } }, attrFn: { val: !0, css: !0, html: !0, text: !0, data: !0, width: !0, height: !0, offset: !0 }, attr: function (a, c, d, e) { var g, h, i, j = a.nodeType; if (!!a && j !== 3 && j !== 8 && j !== 2) { if (e && c in f.attrFn) return f(a)[c](d); if (typeof a.getAttribute == "undefined") return f.prop(a, c, d); i = j !== 1 || !f.isXMLDoc(a), i && (c = c.toLowerCase(), h = f.attrHooks[c] || (u.test(c) ? x : w)); if (d !== b) { if (d === null) { f.removeAttr(a, c); return } if (h && "set" in h && i && (g = h.set(a, d, c)) !== b) return g; a.setAttribute(c, "" + d); return d } if (h && "get" in h && i && (g = h.get(a, c)) !== null) return g; g = a.getAttribute(c); return g === null ? b : g } }, removeAttr: function (a, b) { var c, d, e, g, h, i = 0; if (b && a.nodeType === 1) { d = b.toLowerCase().split(p), g = d.length; for (; i < g; i++) e = d[i], e && (c = f.propFix[e] || e, h = u.test(e), h || f.attr(a, e, ""), a.removeAttribute(v ? e : c), h && c in a && (a[c] = !1)) } }, attrHooks: { type: { set: function (a, b) { if (r.test(a.nodeName) && a.parentNode) f.error("type property can't be changed"); else if (!f.support.radioValue && b === "radio" && f.nodeName(a, "input")) { var c = a.value; a.setAttribute("type", b), c && (a.value = c); return b } } }, value: { get: function (a, b) { if (w && f.nodeName(a, "button")) return w.get(a, b); return b in a ? a.value : null }, set: function (a, b, c) { if (w && f.nodeName(a, "button")) return w.set(a, b, c); a.value = b } } }, propFix: { tabindex: "tabIndex", readonly: "readOnly", "for": "htmlFor", "class": "className", maxlength: "maxLength", cellspacing: "cellSpacing", cellpadding: "cellPadding", rowspan: "rowSpan", colspan: "colSpan", usemap: "useMap", frameborder: "frameBorder", contenteditable: "contentEditable" }, prop: function (a, c, d) { var e, g, h, i = a.nodeType; if (!!a && i !== 3 && i !== 8 && i !== 2) { h = i !== 1 || !f.isXMLDoc(a), h && (c = f.propFix[c] || c, g = f.propHooks[c]); return d !== b ? g && "set" in g && (e = g.set(a, d, c)) !== b ? e : a[c] = d : g && "get" in g && (e = g.get(a, c)) !== null ? e : a[c] } }, propHooks: { tabIndex: { get: function (a) { var c = a.getAttributeNode("tabindex"); return c && c.specified ? parseInt(c.value, 10) : s.test(a.nodeName) || t.test(a.nodeName) && a.href ? 0 : b } } } }), f.attrHooks.tabindex = f.propHooks.tabIndex, x = { get: function (a, c) { var d, e = f.prop(a, c); return e === !0 || typeof e != "boolean" && (d = a.getAttributeNode(c)) && d.nodeValue !== !1 ? c.toLowerCase() : b }, set: function (a, b, c) { var d; b === !1 ? f.removeAttr(a, c) : (d = f.propFix[c] || c, d in a && (a[d] = !0), a.setAttribute(c, c.toLowerCase())); return c } }, v || (y = { name: !0, id: !0, coords: !0 }, w = f.valHooks.button = { get: function (a, c) { var d; d = a.getAttributeNode(c); return d && (y[c] ? d.nodeValue !== "" : d.specified) ? d.nodeValue : b }, set: function (a, b, d) { var e = a.getAttributeNode(d); e || (e = c.createAttribute(d), a.setAttributeNode(e)); return e.nodeValue = b + "" } }, f.attrHooks.tabindex.set = w.set, f.each(["width", "height"], function (a, b) { f.attrHooks[b] = f.extend(f.attrHooks[b], { set: function (a, c) { if (c === "") { a.setAttribute(b, "auto"); return c } } }) }), f.attrHooks.contenteditable = { get: w.get, set: function (a, b, c) { b === "" && (b = "false"), w.set(a, b, c) } }), f.support.hrefNormalized || f.each(["href", "src", "width", "height"], function (a, c) { f.attrHooks[c] = f.extend(f.attrHooks[c], { get: function (a) { var d = a.getAttribute(c, 2); return d === null ? b : d } }) }), f.support.style || (f.attrHooks.style = { get: function (a) { return a.style.cssText.toLowerCase() || b }, set: function (a, b) { return a.style.cssText = "" + b } }), f.support.optSelected || (f.propHooks.selected = f.extend(f.propHooks.selected, { get: function (a) { var b = a.parentNode; b && (b.selectedIndex, b.parentNode && b.parentNode.selectedIndex); return null } })), f.support.enctype || (f.propFix.enctype = "encoding"), f.support.checkOn || f.each(["radio", "checkbox"], function () { f.valHooks[this] = { get: function (a) { return a.getAttribute("value") === null ? "on" : a.value } } }), f.each(["radio", "checkbox"], function () { f.valHooks[this] = f.extend(f.valHooks[this], { set: function (a, b) { if (f.isArray(b)) return a.checked = f.inArray(f(a).val(), b) >= 0 } }) }); var z = /^(?:textarea|input|select)$/i, A = /^([^\.]*)?(?:\.(.+))?$/, B = /(?:^|\s)hover(\.\S+)?\b/, C = /^key/, D = /^(?:mouse|contextmenu)|click/, E = /^(?:focusinfocus|focusoutblur)$/, F = /^(\w*)(?:#([\w\-]+))?(?:\.([\w\-]+))?$/, G = function (
    a) { var b = F.exec(a); b && (b[1] = (b[1] || "").toLowerCase(), b[3] = b[3] && new RegExp("(?:^|\\s)" + b[3] + "(?:\\s|$)")); return b }, H = function (a, b) { var c = a.attributes || {}; return (!b[1] || a.nodeName.toLowerCase() === b[1]) && (!b[2] || (c.id || {}).value === b[2]) && (!b[3] || b[3].test((c["class"] || {}).value)) }, I = function (a) { return f.event.special.hover ? a : a.replace(B, "mouseenter$1 mouseleave$1") }; f.event = { add: function (a, c, d, e, g) { var h, i, j, k, l, m, n, o, p, q, r, s; if (!(a.nodeType === 3 || a.nodeType === 8 || !c || !d || !(h = f._data(a)))) { d.handler && (p = d, d = p.handler, g = p.selector), d.guid || (d.guid = f.guid++), j = h.events, j || (h.events = j = {}), i = h.handle, i || (h.handle = i = function (a) { return typeof f != "undefined" && (!a || f.event.triggered !== a.type) ? f.event.dispatch.apply(i.elem, arguments) : b }, i.elem = a), c = f.trim(I(c)).split(" "); for (k = 0; k < c.length; k++) { l = A.exec(c[k]) || [], m = l[1], n = (l[2] || "").split(".").sort(), s = f.event.special[m] || {}, m = (g ? s.delegateType : s.bindType) || m, s = f.event.special[m] || {}, o = f.extend({ type: m, origType: l[1], data: e, handler: d, guid: d.guid, selector: g, quick: g && G(g), namespace: n.join(".") }, p), r = j[m]; if (!r) { r = j[m] = [], r.delegateCount = 0; if (!s.setup || s.setup.call(a, e, n, i) === !1) a.addEventListener ? a.addEventListener(m, i, !1) : a.attachEvent && a.attachEvent("on" + m, i) } s.add && (s.add.call(a, o), o.handler.guid || (o.handler.guid = d.guid)), g ? r.splice(r.delegateCount++, 0, o) : r.push(o), f.event.global[m] = !0 } a = null } }, global: {}, remove: function (a, b, c, d, e) { var g = f.hasData(a) && f._data(a), h, i, j, k, l, m, n, o, p, q, r, s; if (!!g && !!(o = g.events)) { b = f.trim(I(b || "")).split(" "); for (h = 0; h < b.length; h++) { i = A.exec(b[h]) || [], j = k = i[1], l = i[2]; if (!j) { for (j in o) f.event.remove(a, j + b[h], c, d, !0); continue } p = f.event.special[j] || {}, j = (d ? p.delegateType : p.bindType) || j, r = o[j] || [], m = r.length, l = l ? new RegExp("(^|\\.)" + l.split(".").sort().join("\\.(?:.*\\.)?") + "(\\.|$)") : null; for (n = 0; n < r.length; n++) s = r[n], (e || k === s.origType) && (!c || c.guid === s.guid) && (!l || l.test(s.namespace)) && (!d || d === s.selector || d === "**" && s.selector) && (r.splice(n--, 1), s.selector && r.delegateCount--, p.remove && p.remove.call(a, s)); r.length === 0 && m !== r.length && ((!p.teardown || p.teardown.call(a, l) === !1) && f.removeEvent(a, j, g.handle), delete o[j]) } f.isEmptyObject(o) && (q = g.handle, q && (q.elem = null), f.removeData(a, ["events", "handle"], !0)) } }, customEvent: { getData: !0, setData: !0, changeData: !0 }, trigger: function (c, d, e, g) { if (!e || e.nodeType !== 3 && e.nodeType !== 8) { var h = c.type || c, i = [], j, k, l, m, n, o, p, q, r, s; if (E.test(h + f.event.triggered)) return; h.indexOf("!") >= 0 && (h = h.slice(0, -1), k = !0), h.indexOf(".") >= 0 && (i = h.split("."), h = i.shift(), i.sort()); if ((!e || f.event.customEvent[h]) && !f.event.global[h]) return; c = typeof c == "object" ? c[f.expando] ? c : new f.Event(h, c) : new f.Event(h), c.type = h, c.isTrigger = !0, c.exclusive = k, c.namespace = i.join("."), c.namespace_re = c.namespace ? new RegExp("(^|\\.)" + i.join("\\.(?:.*\\.)?") + "(\\.|$)") : null, o = h.indexOf(":") < 0 ? "on" + h : ""; if (!e) { j = f.cache; for (l in j) j[l].events && j[l].events[h] && f.event.trigger(c, d, j[l].handle.elem, !0); return } c.result = b, c.target || (c.target = e), d = d != null ? f.makeArray(d) : [], d.unshift(c), p = f.event.special[h] || {}; if (p.trigger && p.trigger.apply(e, d) === !1) return; r = [[e, p.bindType || h]]; if (!g && !p.noBubble && !f.isWindow(e)) { s = p.delegateType || h, m = E.test(s + h) ? e : e.parentNode, n = null; for (; m; m = m.parentNode) r.push([m, s]), n = m; n && n === e.ownerDocument && r.push([n.defaultView || n.parentWindow || a, s]) } for (l = 0; l < r.length && !c.isPropagationStopped() ; l++) m = r[l][0], c.type = r[l][1], q = (f._data(m, "events") || {})[c.type] && f._data(m, "handle"), q && q.apply(m, d), q = o && m[o], q && f.acceptData(m) && q.apply(m, d) === !1 && c.preventDefault(); c.type = h, !g && !c.isDefaultPrevented() && (!p._default || p._default.apply(e.ownerDocument, d) === !1) && (h !== "click" || !f.nodeName(e, "a")) && f.acceptData(e) && o && e[h] && (h !== "focus" && h !== "blur" || c.target.offsetWidth !== 0) && !f.isWindow(e) && (n = e[o], n && (e[o] = null), f.event.triggered = h, e[h](), f.event.triggered = b, n && (e[o] = n)); return c.result } }, dispatch: function (c) { c = f.event.fix(c || a.event); var d = (f._data(this, "events") || {})[c.type] || [], e = d.delegateCount, g = [].slice.call(arguments, 0), h = !c.exclusive && !c.namespace, i = f.event.special[c.type] || {}, j = [], k, l, m, n, o, p, q, r, s, t, u; g[0] = c, c.delegateTarget = this; if (!i.preDispatch || i.preDispatch.call(this, c) !== !1) { if (e && (!c.button || c.type !== "click")) { n = f(this), n.context = this.ownerDocument || this; for (m = c.target; m != this; m = m.parentNode || this) if (m.disabled !== !0) { p = {}, r = [], n[0] = m; for (k = 0; k < e; k++) s = d[k], t = s.selector, p[t] === b && (p[t] = s.quick ? H(m, s.quick) : n.is(t)), p[t] && r.push(s); r.length && j.push({ elem: m, matches: r }) } } d.length > e && j.push({ elem: this, matches: d.slice(e) }); for (k = 0; k < j.length && !c.isPropagationStopped() ; k++) { q = j[k], c.currentTarget = q.elem; for (l = 0; l < q.matches.length && !c.isImmediatePropagationStopped() ; l++) { s = q.matches[l]; if (h || !c.namespace && !s.namespace || c.namespace_re && c.namespace_re.test(s.namespace)) c.data = s.data, c.handleObj = s, o = ((f.event.special[s.origType] || {}).handle || s.handler).apply(q.elem, g), o !== b && (c.result = o, o === !1 && (c.preventDefault(), c.stopPropagation())) } } i.postDispatch && i.postDispatch.call(this, c); return c.result } }, props: "attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "), fixHooks: {}, keyHooks: { props: "char charCode key keyCode".split(" "), filter: function (a, b) { a.which == null && (a.which = b.charCode != null ? b.charCode : b.keyCode); return a } }, mouseHooks: { props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "), filter: function (a, d) { var e, f, g, h = d.button, i = d.fromElement; a.pageX == null && d.clientX != null && (e = a.target.ownerDocument || c, f = e.documentElement, g = e.body, a.pageX = d.clientX + (f && f.scrollLeft || g && g.scrollLeft || 0) - (f && f.clientLeft || g && g.clientLeft || 0), a.pageY = d.clientY + (f && f.scrollTop || g && g.scrollTop || 0) - (f && f.clientTop || g && g.clientTop || 0)), !a.relatedTarget && i && (a.relatedTarget = i === a.target ? d.toElement : i), !a.which && h !== b && (a.which = h & 1 ? 1 : h & 2 ? 3 : h & 4 ? 2 : 0); return a } }, fix: function (a) { if (a[f.expando]) return a; var d, e, g = a, h = f.event.fixHooks[a.type] || {}, i = h.props ? this.props.concat(h.props) : this.props; a = f.Event(g); for (d = i.length; d;) e = i[--d], a[e] = g[e]; a.target || (a.target = g.srcElement || c), a.target.nodeType === 3 && (a.target = a.target.parentNode), a.metaKey === b && (a.metaKey = a.ctrlKey); return h.filter ? h.filter(a, g) : a }, special: { ready: { setup: f.bindReady }, load: { noBubble: !0 }, focus: { delegateType: "focusin" }, blur: { delegateType: "focusout" }, beforeunload: { setup: function (a, b, c) { f.isWindow(this) && (this.onbeforeunload = c) }, teardown: function (a, b) { this.onbeforeunload === b && (this.onbeforeunload = null) } } }, simulate: function (a, b, c, d) { var e = f.extend(new f.Event, c, { type: a, isSimulated: !0, originalEvent: {} }); d ? f.event.trigger(e, null, b) : f.event.dispatch.call(b, e), e.isDefaultPrevented() && c.preventDefault() } }, f.event.handle = f.event.dispatch, f.removeEvent = c.removeEventListener ? function (a, b, c) { a.removeEventListener && a.removeEventListener(b, c, !1) } : function (a, b, c) { a.detachEvent && a.detachEvent("on" + b, c) }, f.Event = function (a, b) { if (!(this instanceof f.Event)) return new f.Event(a, b); a && a.type ? (this.originalEvent = a, this.type = a.type, this.isDefaultPrevented = a.defaultPrevented || a.returnValue === !1 || a.getPreventDefault && a.getPreventDefault() ? K : J) : this.type = a, b && f.extend(this, b), this.timeStamp = a && a.timeStamp || f.now(), this[f.expando] = !0 }, f.Event.prototype = { preventDefault: function () { this.isDefaultPrevented = K; var a = this.originalEvent; !a || (a.preventDefault ? a.preventDefault() : a.returnValue = !1) }, stopPropagation: function () { this.isPropagationStopped = K; var a = this.originalEvent; !a || (a.stopPropagation && a.stopPropagation(), a.cancelBubble = !0) }, stopImmediatePropagation: function () { this.isImmediatePropagationStopped = K, this.stopPropagation() }, isDefaultPrevented: J, isPropagationStopped: J, isImmediatePropagationStopped: J }, f.each({ mouseenter: "mouseover", mouseleave: "mouseout" }, function (a, b) { f.event.special[a] = { delegateType: b, bindType: b, handle: function (a) { var c = this, d = a.relatedTarget, e = a.handleObj, g = e.selector, h; if (!d || d !== c && !f.contains(c, d)) a.type = e.origType, h = e.handler.apply(this, arguments), a.type = b; return h } } }), f.support.submitBubbles || (f.event.special.submit = { setup: function () { if (f.nodeName(this, "form")) return !1; f.event.add(this, "click._submit keypress._submit", function (a) { var c = a.target, d = f.nodeName(c, "input") || f.nodeName(c, "button") ? c.form : b; d && !d._submit_attached && (f.event.add(d, "submit._submit", function (a) { a._submit_bubble = !0 }), d._submit_attached = !0) }) }, postDispatch: function (a) { a._submit_bubble && (delete a._submit_bubble, this.parentNode && !a.isTrigger && f.event.simulate("submit", this.parentNode, a, !0)) }, teardown: function () { if (f.nodeName(this, "form")) return !1; f.event.remove(this, "._submit") } }), f.support.changeBubbles || (f.event.special.change = { setup: function () { if (z.test(this.nodeName)) { if (this.type === "checkbox" || this.type === "radio") f.event.add(this, "propertychange._change", function (a) { a.originalEvent.propertyName === "checked" && (this._just_changed = !0) }), f.event.add(this, "click._change", function (a) { this._just_changed && !a.isTrigger && (this._just_changed = !1, f.event.simulate("change", this, a, !0)) }); return !1 } f.event.add(this, "beforeactivate._change", function (a) { var b = a.target; z.test(b.nodeName) && !b._change_attached && (f.event.add(b, "change._change", function (a) { this.parentNode && !a.isSimulated && !a.isTrigger && f.event.simulate("change", this.parentNode, a, !0) }), b._change_attached = !0) }) }, handle: function (a) { var b = a.target; if (this !== b || a.isSimulated || a.isTrigger || b.type !== "radio" && b.type !== "checkbox") return a.handleObj.handler.apply(this, arguments) }, teardown: function () { f.event.remove(this, "._change"); return z.test(this.nodeName) } }), f.support.focusinBubbles || f.each({ focus: "focusin", blur: "focusout" }, function (a, b) { var d = 0, e = function (a) { f.event.simulate(b, a.target, f.event.fix(a), !0) }; f.event.special[b] = { setup: function () { d++ === 0 && c.addEventListener(a, e, !0) }, teardown: function () { --d === 0 && c.removeEventListener(a, e, !0) } } }), f.fn.extend({ on: function (a, c, d, e, g) { var h, i; if (typeof a == "object") { typeof c != "string" && (d = d || c, c = b); for (i in a) this.on(i, c, d, a[i], g); return this } d == null && e == null ? (e = c, d = c = b) : e == null && (typeof c == "string" ? (e = d, d = b) : (e = d, d = c, c = b)); if (e === !1) e = J; else if (!e) return this; g === 1 && (h = e, e = function (a) { f().off(a); return h.apply(this, arguments) }, e.guid = h.guid || (h.guid = f.guid++)); return this.each(function () { f.event.add(this, a, e, d, c) }) }, one: function (a, b, c, d) { return this.on(a, b, c, d, 1) }, off: function (a, c, d) { if (a && a.preventDefault && a.handleObj) { var e = a.handleObj; f(a.delegateTarget).off(e.namespace ? e.origType + "." + e.namespace : e.origType, e.selector, e.handler); return this } if (typeof a == "object") { for (var g in a) this.off(g, c, a[g]); return this } if (c === !1 || typeof c == "function") d = c, c = b; d === !1 && (d = J); return this.each(function () { f.event.remove(this, a, d, c) }) }, bind: function (a, b, c) { return this.on(a, null, b, c) }, unbind: function (a, b) { return this.off(a, null, b) }, live: function (a, b, c) { f(this.context).on(a, this.selector, b, c); return this }, die: function (a, b) { f(this.context).off(a, this.selector || "**", b); return this }, delegate: function (a, b, c, d) { return this.on(b, a, c, d) }, undelegate: function (a, b, c) { return arguments.length == 1 ? this.off(a, "**") : this.off(b, a, c) }, trigger: function (a, b) { return this.each(function () { f.event.trigger(a, b, this) }) }, triggerHandler: function (a, b) { if (this[0]) return f.event.trigger(a, b, this[0], !0) }, toggle: function (a) { var b = arguments, c = a.guid || f.guid++, d = 0, e = function (c) { var e = (f._data(this, "lastToggle" + a.guid) || 0) % d; f._data(this, "lastToggle" + a.guid, e + 1), c.preventDefault(); return b[e].apply(this, arguments) || !1 }; e.guid = c; while (d < b.length) b[d++].guid = c; return this.click(e) }, hover: function (a, b) { return this.mouseenter(a).mouseleave(b || a) } }), f.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu".split(" "), function (a, b) { f.fn[b] = function (a, c) { c == null && (c = a, a = null); return arguments.length > 0 ? this.on(b, null, a, c) : this.trigger(b) }, f.attrFn && (f.attrFn[b] = !0), C.test(b) && (f.event.fixHooks[b] = f.event.keyHooks), D.test(b) && (f.event.fixHooks[b] = f.event.mouseHooks) }), function () { function x(a, b, c, e, f, g) { for (var h = 0, i = e.length; h < i; h++) { var j = e[h]; if (j) { var k = !1; j = j[a]; while (j) { if (j[d] === c) { k = e[j.sizset]; break } if (j.nodeType === 1) { g || (j[d] = c, j.sizset = h); if (typeof b != "string") { if (j === b) { k = !0; break } } else if (m.filter(b, [j]).length > 0) { k = j; break } } j = j[a] } e[h] = k } } } function w(a, b, c, e, f, g) { for (var h = 0, i = e.length; h < i; h++) { var j = e[h]; if (j) { var k = !1; j = j[a]; while (j) { if (j[d] === c) { k = e[j.sizset]; break } j.nodeType === 1 && !g && (j[d] = c, j.sizset = h); if (j.nodeName.toLowerCase() === b) { k = j; break } j = j[a] } e[h] = k } } } var a = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g, d = "sizcache" + (Math.random() + "").replace(".", ""), e = 0, g = Object.prototype.toString, h = !1, i = !0, j = /\\/g, k = /\r\n/g, l = /\W/;[0, 0].sort(function () { i = !1; return 0 }); var m = function (b, d, e, f) { e = e || [], d = d || c; var h = d; if (d.nodeType !== 1 && d.nodeType !== 9) return []; if (!b || typeof b != "string") return e; var i, j, k, l, n, q, r, t, u = !0, v = m.isXML(d), w = [], x = b; do { a.exec(""), i = a.exec(x); if (i) { x = i[3], w.push(i[1]); if (i[2]) { l = i[3]; break } } } while (i); if (w.length > 1 && p.exec(b)) if (w.length === 2 && o.relative[w[0]]) j = y(w[0] + w[1], d, f); else { j = o.relative[w[0]] ? [d] : m(w.shift(), d); while (w.length) b = w.shift(), o.relative[b] && (b += w.shift()), j = y(b, j, f) } else { !f && w.length > 1 && d.nodeType === 9 && !v && o.match.ID.test(w[0]) && !o.match.ID.test(w[w.length - 1]) && (n = m.find(w.shift(), d, v), d = n.expr ? m.filter(n.expr, n.set)[0] : n.set[0]); if (d) { n = f ? { expr: w.pop(), set: s(f) } : m.find(w.pop(), w.length === 1 && (w[0] === "~" || w[0] === "+") && d.parentNode ? d.parentNode : d, v), j = n.expr ? m.filter(n.expr, n.set) : n.set, w.length > 0 ? k = s(j) : u = !1; while (w.length) q = w.pop(), r = q, o.relative[q] ? r = w.pop() : q = "", r == null && (r = d), o.relative[q](k, r, v) } else k = w = [] } k || (k = j), k || m.error(q || b); if (g.call(k) === "[object Array]") if (!u) e.push.apply(e, k); else if (d && d.nodeType === 1) for (t = 0; k[t] != null; t++) k[t] && (k[t] === !0 || k[t].nodeType === 1 && m.contains(d, k[t])) && e.push(j[t]); else for (t = 0; k[t] != null; t++) k[t] && k[t].nodeType === 1 && e.push(j[t]); else s(k, e); l && (m(l, h, e, f), m.uniqueSort(e)); return e }; m.uniqueSort = function (a) { if (u) { h = i, a.sort(u); if (h) for (var b = 1; b < a.length; b++) a[b] === a[b - 1] && a.splice(b--, 1) } return a }, m.matches = function (a, b) { return m(a, null, null, b) }, m.matchesSelector = function (a, b) { return m(b, null, null, [a]).length > 0 }, m.find = function (a, b, c) { var d, e, f, g, h, i; if (!a) return []; for (e = 0, f = o.order.length; e < f; e++) { h = o.order[e]; if (g = o.leftMatch[h].exec(a)) { i = g[1], g.splice(1, 1); if (i.substr(i.length - 1) !== "\\") { g[1] = (g[1] || "").replace(j, ""), d = o.find[h](g, b, c); if (d != null) { a = a.replace(o.match[h], ""); break } } } } d || (d = typeof b.getElementsByTagName != "undefined" ? b.getElementsByTagName("*") : []); return { set: d, expr: a } }, m.filter = function (a, c, d, e) { var f, g, h, i, j, k, l, n, p, q = a, r = [], s = c, t = c && c[0] && m.isXML(c[0]); while (a && c.length) { for (h in o.filter) if ((f = o.leftMatch[h].exec(a)) != null && f[2]) { k = o.filter[h], l = f[1], g = !1, f.splice(1, 1); if (l.substr(l.length - 1) === "\\") continue; s === r && (r = []); if (o.preFilter[h]) { f = o.preFilter[h](f, s, d, r, e, t); if (!f) g = i = !0; else if (f === !0) continue } if (f) for (n = 0; (j = s[n]) != null; n++) j && (i = k(j, f, n, s), p = e ^ i, d && i != null ? p ? g = !0 : s[n] = !1 : p && (r.push(j), g = !0)); if (i !== b) { d || (s = r), a = a.replace(o.match[h], ""); if (!g) return []; break } } if (a === q) if (g == null) m.error(a); else break; q = a } return s }, m.error = function (a) { throw new Error("Syntax error, unrecognized expression: " + a) }; var n = m.getText = function (a) { var b, c, d = a.nodeType, e = ""; if (d) { if (d === 1 || d === 9 || d === 11) { if (typeof a.textContent == "string") return a.textContent; if (typeof a.innerText == "string") return a.innerText.replace(k, ""); for (a = a.firstChild; a; a = a.nextSibling) e += n(a) } else if (d === 3 || d === 4) return a.nodeValue } else for (b = 0; c = a[b]; b++) c.nodeType !== 8 && (e += n(c)); return e }, o = m.selectors = { order: ["ID", "NAME", "TAG"], match: { ID: /#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/, CLASS: /\.((?:[\w\u00c0-\uFFFF\-]|\\.)+)/, NAME: /\[name=['"]*((?:[\w\u00c0-\uFFFF\-]|\\.)+)['"]*\]/, ATTR: /\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(?:(['"])(.*?)\3|(#?(?:[\w\u00c0-\uFFFF\-]|\\.)*)|)|)\s*\]/, TAG: /^((?:[\w\u00c0-\uFFFF\*\-]|\\.)+)/, CHILD: /:(only|nth|last|first)-child(?:\(\s*(even|odd|(?:[+\-]?\d+|(?:[+\-]?\d*)?n\s*(?:[+\-]\s*\d+)?))\s*\))?/, POS: /:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^\-]|$)/, PSEUDO: /:((?:[\w\u00c0-\uFFFF\-]|\\.)+)(?:\((['"]?)((?:\([^\)]+\)|[^\(\)]*)+)\2\))?/ }, leftMatch: {}, attrMap: { "class": "className", "for": "htmlFor" }, attrHandle: { href: function (a) { return a.getAttribute("href") }, type: function (a) { return a.getAttribute("type") } }, relative: { "+": function (a, b) { var c = typeof b == "string", d = c && !l.test(b), e = c && !d; d && (b = b.toLowerCase()); for (var f = 0, g = a.length, h; f < g; f++) if (h = a[f]) { while ((h = h.previousSibling) && h.nodeType !== 1); a[f] = e || h && h.nodeName.toLowerCase() === b ? h || !1 : h === b } e && m.filter(b, a, !0) }, ">": function (a, b) { var c, d = typeof b == "string", e = 0, f = a.length; if (d && !l.test(b)) { b = b.toLowerCase(); for (; e < f; e++) { c = a[e]; if (c) { var g = c.parentNode; a[e] = g.nodeName.toLowerCase() === b ? g : !1 } } } else { for (; e < f; e++) c = a[e], c && (a[e] = d ? c.parentNode : c.parentNode === b); d && m.filter(b, a, !0) } }, "": function (a, b, c) { var d, f = e++, g = x; typeof b == "string" && !l.test(b) && (b = b.toLowerCase(), d = b, g = w), g("parentNode", b, f, a, d, c) }, "~": function (a, b, c) { var d, f = e++, g = x; typeof b == "string" && !l.test(b) && (b = b.toLowerCase(), d = b, g = w), g("previousSibling", b, f, a, d, c) } }, find: { ID: function (a, b, c) { if (typeof b.getElementById != "undefined" && !c) { var d = b.getElementById(a[1]); return d && d.parentNode ? [d] : [] } }, NAME: function (a, b) { if (typeof b.getElementsByName != "undefined") { var c = [], d = b.getElementsByName(a[1]); for (var e = 0, f = d.length; e < f; e++) d[e].getAttribute("name") === a[1] && c.push(d[e]); return c.length === 0 ? null : c } }, TAG: function (a, b) { if (typeof b.getElementsByTagName != "undefined") return b.getElementsByTagName(a[1]) } }, preFilter: { CLASS: function (a, b, c, d, e, f) { a = " " + a[1].replace(j, "") + " "; if (f) return a; for (var g = 0, h; (h = b[g]) != null; g++) h && (e ^ (h.className && (" " + h.className + " ").replace(/[\t\n\r]/g, " ").indexOf(a) >= 0) ? c || d.push(h) : c && (b[g] = !1)); return !1 }, ID: function (a) { return a[1].replace(j, "") }, TAG: function (a, b) { return a[1].replace(j, "").toLowerCase() }, CHILD: function (a) { if (a[1] === "nth") { a[2] || m.error(a[0]), a[2] = a[2].replace(/^\+|\s*/g, ""); var b = /(-?)(\d*)(?:n([+\-]?\d*))?/.exec(a[2] === "even" && "2n" || a[2] === "odd" && "2n+1" || !/\D/.test(a[2]) && "0n+" + a[2] || a[2]); a[2] = b[1] + (b[2] || 1) - 0, a[3] = b[3] - 0 } else a[2] && m.error(a[0]); a[0] = e++; return a }, ATTR: function (a, b, c, d, e, f) { var g = a[1] = a[1].replace(j, ""); !f && o.attrMap[g] && (a[1] = o.attrMap[g]), a[4] = (a[4] || a[5] || "").replace(j, ""), a[2] === "~=" && (a[4] = " " + a[4] + " "); return a }, PSEUDO: function (b, c, d, e, f) { if (b[1] === "not") if ((a.exec(b[3]) || "").length > 1 || /^\w/.test(b[3])) b[3] = m(b[3], null, null, c); else { var g = m.filter(b[3], c, d, !0 ^ f); d || e.push.apply(e, g); return !1 } else if (o.match.POS.test(b[0]) || o.match.CHILD.test(b[0])) return !0; return b }, POS: function (a) { a.unshift(!0); return a } }, filters: { enabled: function (a) { return a.disabled === !1 && a.type !== "hidden" }, disabled: function (a) { return a.disabled === !0 }, checked: function (a) { return a.checked === !0 }, selected: function (a) { a.parentNode && a.parentNode.selectedIndex; return a.selected === !0 }, parent: function (a) { return !!a.firstChild }, empty: function (a) { return !a.firstChild }, has: function (a, b, c) { return !!m(c[3], a).length }, header: function (a) { return /h\d/i.test(a.nodeName) }, text: function (a) { var b = a.getAttribute("type"), c = a.type; return a.nodeName.toLowerCase() === "input" && "text" === c && (b === c || b === null) }, radio: function (a) { return a.nodeName.toLowerCase() === "input" && "radio" === a.type }, checkbox: function (a) { return a.nodeName.toLowerCase() === "input" && "checkbox" === a.type }, file: function (a) { return a.nodeName.toLowerCase() === "input" && "file" === a.type }, password: function (a) { return a.nodeName.toLowerCase() === "input" && "password" === a.type }, submit: function (a) { var b = a.nodeName.toLowerCase(); return (b === "input" || b === "button") && "submit" === a.type }, image: function (a) { return a.nodeName.toLowerCase() === "input" && "image" === a.type }, reset: function (a) { var b = a.nodeName.toLowerCase(); return (b === "input" || b === "button") && "reset" === a.type }, button: function (a) { var b = a.nodeName.toLowerCase(); return b === "input" && "button" === a.type || b === "button" }, input: function (a) { return /input|select|textarea|button/i.test(a.nodeName) }, focus: function (a) { return a === a.ownerDocument.activeElement } }, setFilters: { first: function (a, b) { return b === 0 }, last: function (a, b, c, d) { return b === d.length - 1 }, even: function (a, b) { return b % 2 === 0 }, odd: function (a, b) { return b % 2 === 1 }, lt: function (a, b, c) { return b < c[3] - 0 }, gt: function (a, b, c) { return b > c[3] - 0 }, nth: function (a, b, c) { return c[3] - 0 === b }, eq: function (a, b, c) { return c[3] - 0 === b } }, filter: { PSEUDO: function (a, b, c, d) { var e = b[1], f = o.filters[e]; if (f) return f(a, c, b, d); if (e === "contains") return (a.textContent || a.innerText || n([a]) || "").indexOf(b[3]) >= 0; if (e === "not") { var g = b[3]; for (var h = 0, i = g.length; h < i; h++) if (g[h] === a) return !1; return !0 } m.error(e) }, CHILD: function (a, b) { var c, e, f, g, h, i, j, k = b[1], l = a; switch (k) { case "only": case "first": while (l = l.previousSibling) if (l.nodeType === 1) return !1; if (k === "first") return !0; l = a; case "last": while (l = l.nextSibling) if (l.nodeType === 1) return !1; return !0; case "nth": c = b[2], e = b[3]; if (c === 1 && e === 0) return !0; f = b[0], g = a.parentNode; if (g && (g[d] !== f || !a.nodeIndex)) { i = 0; for (l = g.firstChild; l; l = l.nextSibling) l.nodeType === 1 && (l.nodeIndex = ++i); g[d] = f } j = a.nodeIndex - e; return c === 0 ? j === 0 : j % c === 0 && j / c >= 0 } }, ID: function (a, b) { return a.nodeType === 1 && a.getAttribute("id") === b }, TAG: function (a, b) { return b === "*" && a.nodeType === 1 || !!a.nodeName && a.nodeName.toLowerCase() === b }, CLASS: function (a, b) { return (" " + (a.className || a.getAttribute("class")) + " ").indexOf(b) > -1 }, ATTR: function (a, b) { var c = b[1], d = m.attr ? m.attr(a, c) : o.attrHandle[c] ? o.attrHandle[c](a) : a[c] != null ? a[c] : a.getAttribute(c), e = d + "", f = b[2], g = b[4]; return d == null ? f === "!=" : !f && m.attr ? d != null : f === "=" ? e === g : f === "*=" ? e.indexOf(g) >= 0 : f === "~=" ? (" " + e + " ").indexOf(g) >= 0 : g ? f === "!=" ? e !== g : f === "^=" ? e.indexOf(g) === 0 : f === "$=" ? e.substr(e.length - g.length) === g : f === "|=" ? e === g || e.substr(0, g.length + 1) === g + "-" : !1 : e && d !== !1 }, POS: function (a, b, c, d) { var e = b[2], f = o.setFilters[e]; if (f) return f(a, c, b, d) } } }, p = o.match.POS, q = function (a, b) { return "\\" + (b - 0 + 1) }; for (var r in o.match) o.match[r] = new RegExp(o.match[r].source + /(?![^\[]*\])(?![^\(]*\))/.source), o.leftMatch[r] = new RegExp(/(^(?:.|\r|\n)*?)/.source + o.match[r].source.replace(/\\(\d+)/g, q)); o.match.globalPOS = p; var s = function (a, b) { a = Array.prototype.slice.call(a, 0); if (b) { b.push.apply(b, a); return b } return a }; try { Array.prototype.slice.call(c.documentElement.childNodes, 0)[0].nodeType } catch (t) { s = function (a, b) { var c = 0, d = b || []; if (g.call(a) === "[object Array]") Array.prototype.push.apply(d, a); else if (typeof a.length == "number") for (var e = a.length; c < e; c++) d.push(a[c]); else for (; a[c]; c++) d.push(a[c]); return d } } var u, v; c.documentElement.compareDocumentPosition ? u = function (a, b) { if (a === b) { h = !0; return 0 } if (!a.compareDocumentPosition || !b.compareDocumentPosition) return a.compareDocumentPosition ? -1 : 1; return a.compareDocumentPosition(b) & 4 ? -1 : 1 } : (u = function (a, b) { if (a === b) { h = !0; return 0 } if (a.sourceIndex && b.sourceIndex) return a.sourceIndex - b.sourceIndex; var c, d, e = [], f = [], g = a.parentNode, i = b.parentNode, j = g; if (g === i) return v(a, b); if (!g) return -1; if (!i) return 1; while (j) e.unshift(j), j = j.parentNode; j = i; while (j) f.unshift(j), j = j.parentNode; c = e.length, d = f.length; for (var k = 0; k < c && k < d; k++) if (e[k] !== f[k]) return v(e[k], f[k]); return k === c ? v(a, f[k], -1) : v(e[k], b, 1) }, v = function (a, b, c) { if (a === b) return c; var d = a.nextSibling; while (d) { if (d === b) return -1; d = d.nextSibling } return 1 }), function () { var a = c.createElement("div"), d = "script" + (new Date).getTime(), e = c.documentElement; a.innerHTML = "<a name='" + d + "'/>", e.insertBefore(a, e.firstChild), c.getElementById(d) && (o.find.ID = function (a, c, d) { if (typeof c.getElementById != "undefined" && !d) { var e = c.getElementById(a[1]); return e ? e.id === a[1] || typeof e.getAttributeNode != "undefined" && e.getAttributeNode("id").nodeValue === a[1] ? [e] : b : [] } }, o.filter.ID = function (a, b) { var c = typeof a.getAttributeNode != "undefined" && a.getAttributeNode("id"); return a.nodeType === 1 && c && c.nodeValue === b }), e.removeChild(a), e = a = null }(), function () { var a = c.createElement("div"); a.appendChild(c.createComment("")), a.getElementsByTagName("*").length > 0 && (o.find.TAG = function (a, b) { var c = b.getElementsByTagName(a[1]); if (a[1] === "*") { var d = []; for (var e = 0; c[e]; e++) c[e].nodeType === 1 && d.push(c[e]); c = d } return c }), a.innerHTML = "<a href='#'></a>", a.firstChild && typeof a.firstChild.getAttribute != "undefined" && a.firstChild.getAttribute("href") !== "#" && (o.attrHandle.href = function (a) { return a.getAttribute("href", 2) }), a = null }(), c.querySelectorAll && function () { var a = m, b = c.createElement("div"), d = "__sizzle__"; b.innerHTML = "<p class='TEST'></p>"; if (!b.querySelectorAll || b.querySelectorAll(".TEST").length !== 0) { m = function (b, e, f, g) { e = e || c; if (!g && !m.isXML(e)) { var h = /^(\w+$)|^\.([\w\-]+$)|^#([\w\-]+$)/.exec(b); if (h && (e.nodeType === 1 || e.nodeType === 9)) { if (h[1]) return s(e.getElementsByTagName(b), f); if (h[2] && o.find.CLASS && e.getElementsByClassName) return s(e.getElementsByClassName(h[2]), f) } if (e.nodeType === 9) { if (b === "body" && e.body) return s([e.body], f); if (h && h[3]) { var i = e.getElementById(h[3]); if (!i || !i.parentNode) return s([], f); if (i.id === h[3]) return s([i], f) } try { return s(e.querySelectorAll(b), f) } catch (j) { } } else if (e.nodeType === 1 && e.nodeName.toLowerCase() !== "object") { var k = e, l = e.getAttribute("id"), n = l || d, p = e.parentNode, q = /^\s*[+~]/.test(b); l ? n = n.replace(/'/g, "\\$&") : e.setAttribute("id", n), q && p && (e = e.parentNode); try { if (!q || p) return s(e.querySelectorAll("[id='" + n + "'] " + b), f) } catch (r) { } finally { l || k.removeAttribute("id") } } } return a(b, e, f, g) }; for (var e in a) m[e] = a[e]; b = null } }(), function () { var a = c.documentElement, b = a.matchesSelector || a.mozMatchesSelector || a.webkitMatchesSelector || a.msMatchesSelector; if (b) { var d = !b.call(c.createElement("div"), "div"), e = !1; try { b.call(c.documentElement, "[test!='']:sizzle") } catch (f) { e = !0 } m.matchesSelector = function (a, c) { c = c.replace(/\=\s*([^'"\]]*)\s*\]/g, "='$1']"); if (!m.isXML(a)) try { if (e || !o.match.PSEUDO.test(c) && !/!=/.test(c)) { var f = b.call(a, c); if (f || !d || a.document && a.document.nodeType !== 11) return f } } catch (g) { } return m(c, null, null, [a]).length > 0 } } }(), function () { var a = c.createElement("div"); a.innerHTML = "<div class='test e'></div><div class='test'></div>"; if (!!a.getElementsByClassName && a.getElementsByClassName("e").length !== 0) { a.lastChild.className = "e"; if (a.getElementsByClassName("e").length === 1) return; o.order.splice(1, 0, "CLASS"), o.find.CLASS = function (a, b, c) { if (typeof b.getElementsByClassName != "undefined" && !c) return b.getElementsByClassName(a[1]) }, a = null } }(), c.documentElement.contains ? m.contains = function (a, b) { return a !== b && (a.contains ? a.contains(b) : !0) } : c.documentElement.compareDocumentPosition ? m.contains = function (a, b) { return !!(a.compareDocumentPosition(b) & 16) } : m.contains = function () { return !1 }, m.isXML = function (a) { var b = (a ? a.ownerDocument || a : 0).documentElement; return b ? b.nodeName !== "HTML" : !1 }; var y = function (a, b, c) { var d, e = [], f = "", g = b.nodeType ? [b] : b; while (d = o.match.PSEUDO.exec(a)) f += d[0], a = a.replace(o.match.PSEUDO, ""); a = o.relative[a] ? a + "*" : a; for (var h = 0, i = g.length; h < i; h++) m(a, g[h], e, c); return m.filter(f, e) }; m.attr = f.attr, m.selectors.attrMap = {}, f.find = m, f.expr = m.selectors, f.expr[":"] = f.expr.filters, f.unique = m.uniqueSort, f.text = m.getText, f.isXMLDoc = m.isXML, f.contains = m.contains }(); var L = /Until$/, M = /^(?:parents|prevUntil|prevAll)/, N = /,/, O = /^.[^:#\[\.,]*$/, P = Array.prototype.slice, Q = f.expr.match.globalPOS, R = { children: !0, contents: !0, next: !0, prev: !0 }; f.fn.extend({ find: function (a) { var b = this, c, d; if (typeof a != "string") return f(a).filter(function () { for (c = 0, d = b.length; c < d; c++) if (f.contains(b[c], this)) return !0 }); var e = this.pushStack("", "find", a), g, h, i; for (c = 0, d = this.length; c < d; c++) { g = e.length, f.find(a, this[c], e); if (c > 0) for (h = g; h < e.length; h++) for (i = 0; i < g; i++) if (e[i] === e[h]) { e.splice(h--, 1); break } } return e }, has: function (a) { var b = f(a); return this.filter(function () { for (var a = 0, c = b.length; a < c; a++) if (f.contains(this, b[a])) return !0 }) }, not: function (a) { return this.pushStack(T(this, a, !1), "not", a) }, filter: function (a) { return this.pushStack(T(this, a, !0), "filter", a) }, is: function (a) { return !!a && (typeof a == "string" ? Q.test(a) ? f(a, this.context).index(this[0]) >= 0 : f.filter(a, this).length > 0 : this.filter(a).length > 0) }, closest: function (a, b) { var c = [], d, e, g = this[0]; if (f.isArray(a)) { var h = 1; while (g && g.ownerDocument && g !== b) { for (d = 0; d < a.length; d++) f(g).is(a[d]) && c.push({ selector: a[d], elem: g, level: h }); g = g.parentNode, h++ } return c } var i = Q.test(a) || typeof a != "string" ? f(a, b || this.context) : 0; for (d = 0, e = this.length; d < e; d++) { g = this[d]; while (g) { if (i ? i.index(g) > -1 : f.find.matchesSelector(g, a)) { c.push(g); break } g = g.parentNode; if (!g || !g.ownerDocument || g === b || g.nodeType === 11) break } } c = c.length > 1 ? f.unique(c) : c; return this.pushStack(c, "closest", a) }, index: function (a) { if (!a) return this[0] && this[0].parentNode ? this.prevAll().length : -1; if (typeof a == "string") return f.inArray(this[0], f(a)); return f.inArray(a.jquery ? a[0] : a, this) }, add: function (a, b) { var c = typeof a == "string" ? f(a, b) : f.makeArray(a && a.nodeType ? [a] : a), d = f.merge(this.get(), c); return this.pushStack(S(c[0]) || S(d[0]) ? d : f.unique(d)) }, andSelf: function () { return this.add(this.prevObject) } }), f.each({ parent: function (a) { var b = a.parentNode; return b && b.nodeType !== 11 ? b : null }, parents: function (a) { return f.dir(a, "parentNode") }, parentsUntil: function (a, b, c) { return f.dir(a, "parentNode", c) }, next: function (a) { return f.nth(a, 2, "nextSibling") }, prev: function (a) { return f.nth(a, 2, "previousSibling") }, nextAll: function (a) { return f.dir(a, "nextSibling") }, prevAll: function (a) { return f.dir(a, "previousSibling") }, nextUntil: function (a, b, c) { return f.dir(a, "nextSibling", c) }, prevUntil: function (a, b, c) { return f.dir(a, "previousSibling", c) }, siblings: function (a) { return f.sibling((a.parentNode || {}).firstChild, a) }, children: function (a) { return f.sibling(a.firstChild) }, contents: function (a) { return f.nodeName(a, "iframe") ? a.contentDocument || a.contentWindow.document : f.makeArray(a.childNodes) } }, function (a, b) { f.fn[a] = function (c, d) { var e = f.map(this, b, c); L.test(a) || (d = c), d && typeof d == "string" && (e = f.filter(d, e)), e = this.length > 1 && !R[a] ? f.unique(e) : e, (this.length > 1 || N.test(d)) && M.test(a) && (e = e.reverse()); return this.pushStack(e, a, P.call(arguments).join(",")) } }), f.extend({ filter: function (a, b, c) { c && (a = ":not(" + a + ")"); return b.length === 1 ? f.find.matchesSelector(b[0], a) ? [b[0]] : [] : f.find.matches(a, b) }, dir: function (a, c, d) { var e = [], g = a[c]; while (g && g.nodeType !== 9 && (d === b || g.nodeType !== 1 || !f(g).is(d))) g.nodeType === 1 && e.push(g), g = g[c]; return e }, nth: function (a, b, c, d) { b = b || 1; var e = 0; for (; a; a = a[c]) if (a.nodeType === 1 && ++e === b) break; return a }, sibling: function (a, b) { var c = []; for (; a; a = a.nextSibling) a.nodeType === 1 && a !== b && c.push(a); return c } }); var V = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video", W = / jQuery\d+="(?:\d+|null)"/g, X = /^\s+/, Y = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig, Z = /<([\w:]+)/, $ = /<tbody/i, _ = /<|&#?\w+;/, ba = /<(?:script|style)/i, bb = /<(?:script|object|embed|option|style)/i, bc = new RegExp("<(?:" + V + ")[\\s/>]", "i"), bd = /checked\s*(?:[^=]|=\s*.checked.)/i, be = /\/(java|ecma)script/i, bf = /^\s*<!(?:\[CDATA\[|\-\-)/, bg = { option: [1, "<select multiple='multiple'>", "</select>"], legend: [1, "<fieldset>", "</fieldset>"], thead: [1, "<table>", "</table>"], tr: [2, "<table><tbody>", "</tbody></table>"], td: [3, "<table><tbody><tr>", "</tr></tbody></table>"], col: [2, "<table><tbody></tbody><colgroup>", "</colgroup></table>"], area: [1, "<map>", "</map>"], _default: [0, "", ""] }, bh = U(c); bg.optgroup = bg.option, bg.tbody = bg.tfoot = bg.colgroup = bg.caption = bg.thead, bg.th = bg.td, f.support.htmlSerialize || (bg._default = [1, "div<div>", "</div>"]), f.fn.extend({
        text: function (a) { return f.access(this, function (a) { return a === b ? f.text(this) : this.empty().append((this[0] && this[0].ownerDocument || c).createTextNode(a)) }, null, a, arguments.length) }, wrapAll: function (a) { if (f.isFunction(a)) return this.each(function (b) { f(this).wrapAll(a.call(this, b)) }); if (this[0]) { var b = f(a, this[0].ownerDocument).eq(0).clone(!0); this[0].parentNode && b.insertBefore(this[0]), b.map(function () { var a = this; while (a.firstChild && a.firstChild.nodeType === 1) a = a.firstChild; return a }).append(this) } return this }, wrapInner: function (a) { if (f.isFunction(a)) return this.each(function (b) { f(this).wrapInner(a.call(this, b)) }); return this.each(function () { var b = f(this), c = b.contents(); c.length ? c.wrapAll(a) : b.append(a) }) }, wrap: function (a) { var b = f.isFunction(a); return this.each(function (c) { f(this).wrapAll(b ? a.call(this, c) : a) }) }, unwrap: function () { return this.parent().each(function () { f.nodeName(this, "body") || f(this).replaceWith(this.childNodes) }).end() }, append: function () { return this.domManip(arguments, !0, function (a) { this.nodeType === 1 && this.appendChild(a) }) }, prepend: function () { return this.domManip(arguments, !0, function (a) { this.nodeType === 1 && this.insertBefore(a, this.firstChild) }) }, before: function () {
            if (this[0] && this[0].parentNode) return this.domManip(arguments, !1, function (a) { this.parentNode.insertBefore(a, this) }); if (arguments.length) {
                var a = f
                .clean(arguments); a.push.apply(a, this.toArray()); return this.pushStack(a, "before", arguments)
            }
        }, after: function () { if (this[0] && this[0].parentNode) return this.domManip(arguments, !1, function (a) { this.parentNode.insertBefore(a, this.nextSibling) }); if (arguments.length) { var a = this.pushStack(this, "after", arguments); a.push.apply(a, f.clean(arguments)); return a } }, remove: function (a, b) { for (var c = 0, d; (d = this[c]) != null; c++) if (!a || f.filter(a, [d]).length) !b && d.nodeType === 1 && (f.cleanData(d.getElementsByTagName("*")), f.cleanData([d])), d.parentNode && d.parentNode.removeChild(d); return this }, empty: function () { for (var a = 0, b; (b = this[a]) != null; a++) { b.nodeType === 1 && f.cleanData(b.getElementsByTagName("*")); while (b.firstChild) b.removeChild(b.firstChild) } return this }, clone: function (a, b) { a = a == null ? !1 : a, b = b == null ? a : b; return this.map(function () { return f.clone(this, a, b) }) }, html: function (a) { return f.access(this, function (a) { var c = this[0] || {}, d = 0, e = this.length; if (a === b) return c.nodeType === 1 ? c.innerHTML.replace(W, "") : null; if (typeof a == "string" && !ba.test(a) && (f.support.leadingWhitespace || !X.test(a)) && !bg[(Z.exec(a) || ["", ""])[1].toLowerCase()]) { a = a.replace(Y, "<$1></$2>"); try { for (; d < e; d++) c = this[d] || {}, c.nodeType === 1 && (f.cleanData(c.getElementsByTagName("*")), c.innerHTML = a); c = 0 } catch (g) { } } c && this.empty().append(a) }, null, a, arguments.length) }, replaceWith: function (a) { if (this[0] && this[0].parentNode) { if (f.isFunction(a)) return this.each(function (b) { var c = f(this), d = c.html(); c.replaceWith(a.call(this, b, d)) }); typeof a != "string" && (a = f(a).detach()); return this.each(function () { var b = this.nextSibling, c = this.parentNode; f(this).remove(), b ? f(b).before(a) : f(c).append(a) }) } return this.length ? this.pushStack(f(f.isFunction(a) ? a() : a), "replaceWith", a) : this }, detach: function (a) { return this.remove(a, !0) }, domManip: function (a, c, d) { var e, g, h, i, j = a[0], k = []; if (!f.support.checkClone && arguments.length === 3 && typeof j == "string" && bd.test(j)) return this.each(function () { f(this).domManip(a, c, d, !0) }); if (f.isFunction(j)) return this.each(function (e) { var g = f(this); a[0] = j.call(this, e, c ? g.html() : b), g.domManip(a, c, d) }); if (this[0]) { i = j && j.parentNode, f.support.parentNode && i && i.nodeType === 11 && i.childNodes.length === this.length ? e = { fragment: i } : e = f.buildFragment(a, this, k), h = e.fragment, h.childNodes.length === 1 ? g = h = h.firstChild : g = h.firstChild; if (g) { c = c && f.nodeName(g, "tr"); for (var l = 0, m = this.length, n = m - 1; l < m; l++) d.call(c ? bi(this[l], g) : this[l], e.cacheable || m > 1 && l < n ? f.clone(h, !0, !0) : h) } k.length && f.each(k, function (a, b) { b.src ? f.ajax({ type: "GET", global: !1, url: b.src, async: !1, dataType: "script" }) : f.globalEval((b.text || b.textContent || b.innerHTML || "").replace(bf, "/*$0*/")), b.parentNode && b.parentNode.removeChild(b) }) } return this }
    }), f.buildFragment = function (a, b, d) { var e, g, h, i, j = a[0]; b && b[0] && (i = b[0].ownerDocument || b[0]), i.createDocumentFragment || (i = c), a.length === 1 && typeof j == "string" && j.length < 512 && i === c && j.charAt(0) === "<" && !bb.test(j) && (f.support.checkClone || !bd.test(j)) && (f.support.html5Clone || !bc.test(j)) && (g = !0, h = f.fragments[j], h && h !== 1 && (e = h)), e || (e = i.createDocumentFragment(), f.clean(a, i, e, d)), g && (f.fragments[j] = h ? e : 1); return { fragment: e, cacheable: g } }, f.fragments = {}, f.each({ appendTo: "append", prependTo: "prepend", insertBefore: "before", insertAfter: "after", replaceAll: "replaceWith" }, function (a, b) { f.fn[a] = function (c) { var d = [], e = f(c), g = this.length === 1 && this[0].parentNode; if (g && g.nodeType === 11 && g.childNodes.length === 1 && e.length === 1) { e[b](this[0]); return this } for (var h = 0, i = e.length; h < i; h++) { var j = (h > 0 ? this.clone(!0) : this).get(); f(e[h])[b](j), d = d.concat(j) } return this.pushStack(d, a, e.selector) } }), f.extend({ clone: function (a, b, c) { var d, e, g, h = f.support.html5Clone || f.isXMLDoc(a) || !bc.test("<" + a.nodeName + ">") ? a.cloneNode(!0) : bo(a); if ((!f.support.noCloneEvent || !f.support.noCloneChecked) && (a.nodeType === 1 || a.nodeType === 11) && !f.isXMLDoc(a)) { bk(a, h), d = bl(a), e = bl(h); for (g = 0; d[g]; ++g) e[g] && bk(d[g], e[g]) } if (b) { bj(a, h); if (c) { d = bl(a), e = bl(h); for (g = 0; d[g]; ++g) bj(d[g], e[g]) } } d = e = null; return h }, clean: function (a, b, d, e) { var g, h, i, j = []; b = b || c, typeof b.createElement == "undefined" && (b = b.ownerDocument || b[0] && b[0].ownerDocument || c); for (var k = 0, l; (l = a[k]) != null; k++) { typeof l == "number" && (l += ""); if (!l) continue; if (typeof l == "string") if (!_.test(l)) l = b.createTextNode(l); else { l = l.replace(Y, "<$1></$2>"); var m = (Z.exec(l) || ["", ""])[1].toLowerCase(), n = bg[m] || bg._default, o = n[0], p = b.createElement("div"), q = bh.childNodes, r; b === c ? bh.appendChild(p) : U(b).appendChild(p), p.innerHTML = n[1] + l + n[2]; while (o--) p = p.lastChild; if (!f.support.tbody) { var s = $.test(l), t = m === "table" && !s ? p.firstChild && p.firstChild.childNodes : n[1] === "<table>" && !s ? p.childNodes : []; for (i = t.length - 1; i >= 0; --i) f.nodeName(t[i], "tbody") && !t[i].childNodes.length && t[i].parentNode.removeChild(t[i]) } !f.support.leadingWhitespace && X.test(l) && p.insertBefore(b.createTextNode(X.exec(l)[0]), p.firstChild), l = p.childNodes, p && (p.parentNode.removeChild(p), q.length > 0 && (r = q[q.length - 1], r && r.parentNode && r.parentNode.removeChild(r))) } var u; if (!f.support.appendChecked) if (l[0] && typeof (u = l.length) == "number") for (i = 0; i < u; i++) bn(l[i]); else bn(l); l.nodeType ? j.push(l) : j = f.merge(j, l) } if (d) { g = function (a) { return !a.type || be.test(a.type) }; for (k = 0; j[k]; k++) { h = j[k]; if (e && f.nodeName(h, "script") && (!h.type || be.test(h.type))) e.push(h.parentNode ? h.parentNode.removeChild(h) : h); else { if (h.nodeType === 1) { var v = f.grep(h.getElementsByTagName("script"), g); j.splice.apply(j, [k + 1, 0].concat(v)) } d.appendChild(h) } } } return j }, cleanData: function (a) { var b, c, d = f.cache, e = f.event.special, g = f.support.deleteExpando; for (var h = 0, i; (i = a[h]) != null; h++) { if (i.nodeName && f.noData[i.nodeName.toLowerCase()]) continue; c = i[f.expando]; if (c) { b = d[c]; if (b && b.events) { for (var j in b.events) e[j] ? f.event.remove(i, j) : f.removeEvent(i, j, b.handle); b.handle && (b.handle.elem = null) } g ? delete i[f.expando] : i.removeAttribute && i.removeAttribute(f.expando), delete d[c] } } } }); var bp = /alpha\([^)]*\)/i, bq = /opacity=([^)]*)/, br = /([A-Z]|^ms)/g, bs = /^[\-+]?(?:\d*\.)?\d+$/i, bt = /^-?(?:\d*\.)?\d+(?!px)[^\d\s]+$/i, bu = /^([\-+])=([\-+.\de]+)/, bv = /^margin/, bw = { position: "absolute", visibility: "hidden", display: "block" }, bx = ["Top", "Right", "Bottom", "Left"], by, bz, bA; f.fn.css = function (a, c) { return f.access(this, function (a, c, d) { return d !== b ? f.style(a, c, d) : f.css(a, c) }, a, c, arguments.length > 1) }, f.extend({ cssHooks: { opacity: { get: function (a, b) { if (b) { var c = by(a, "opacity"); return c === "" ? "1" : c } return a.style.opacity } } }, cssNumber: { fillOpacity: !0, fontWeight: !0, lineHeight: !0, opacity: !0, orphans: !0, widows: !0, zIndex: !0, zoom: !0 }, cssProps: { "float": f.support.cssFloat ? "cssFloat" : "styleFloat" }, style: function (a, c, d, e) { if (!!a && a.nodeType !== 3 && a.nodeType !== 8 && !!a.style) { var g, h, i = f.camelCase(c), j = a.style, k = f.cssHooks[i]; c = f.cssProps[i] || i; if (d === b) { if (k && "get" in k && (g = k.get(a, !1, e)) !== b) return g; return j[c] } h = typeof d, h === "string" && (g = bu.exec(d)) && (d = +(g[1] + 1) * +g[2] + parseFloat(f.css(a, c)), h = "number"); if (d == null || h === "number" && isNaN(d)) return; h === "number" && !f.cssNumber[i] && (d += "px"); if (!k || !("set" in k) || (d = k.set(a, d)) !== b) try { j[c] = d } catch (l) { } } }, css: function (a, c, d) { var e, g; c = f.camelCase(c), g = f.cssHooks[c], c = f.cssProps[c] || c, c === "cssFloat" && (c = "float"); if (g && "get" in g && (e = g.get(a, !0, d)) !== b) return e; if (by) return by(a, c) }, swap: function (a, b, c) { var d = {}, e, f; for (f in b) d[f] = a.style[f], a.style[f] = b[f]; e = c.call(a); for (f in b) a.style[f] = d[f]; return e } }), f.curCSS = f.css, c.defaultView && c.defaultView.getComputedStyle && (bz = function (a, b) { var c, d, e, g, h = a.style; b = b.replace(br, "-$1").toLowerCase(), (d = a.ownerDocument.defaultView) && (e = d.getComputedStyle(a, null)) && (c = e.getPropertyValue(b), c === "" && !f.contains(a.ownerDocument.documentElement, a) && (c = f.style(a, b))), !f.support.pixelMargin && e && bv.test(b) && bt.test(c) && (g = h.width, h.width = c, c = e.width, h.width = g); return c }), c.documentElement.currentStyle && (bA = function (a, b) { var c, d, e, f = a.currentStyle && a.currentStyle[b], g = a.style; f == null && g && (e = g[b]) && (f = e), bt.test(f) && (c = g.left, d = a.runtimeStyle && a.runtimeStyle.left, d && (a.runtimeStyle.left = a.currentStyle.left), g.left = b === "fontSize" ? "1em" : f, f = g.pixelLeft + "px", g.left = c, d && (a.runtimeStyle.left = d)); return f === "" ? "auto" : f }), by = bz || bA, f.each(["height", "width"], function (a, b) { f.cssHooks[b] = { get: function (a, c, d) { if (c) return a.offsetWidth !== 0 ? bB(a, b, d) : f.swap(a, bw, function () { return bB(a, b, d) }) }, set: function (a, b) { return bs.test(b) ? b + "px" : b } } }), f.support.opacity || (f.cssHooks.opacity = { get: function (a, b) { return bq.test((b && a.currentStyle ? a.currentStyle.filter : a.style.filter) || "") ? parseFloat(RegExp.$1) / 100 + "" : b ? "1" : "" }, set: function (a, b) { var c = a.style, d = a.currentStyle, e = f.isNumeric(b) ? "alpha(opacity=" + b * 100 + ")" : "", g = d && d.filter || c.filter || ""; c.zoom = 1; if (b >= 1 && f.trim(g.replace(bp, "")) === "") { c.removeAttribute("filter"); if (d && !d.filter) return } c.filter = bp.test(g) ? g.replace(bp, e) : g + " " + e } }), f(function () { f.support.reliableMarginRight || (f.cssHooks.marginRight = { get: function (a, b) { return f.swap(a, { display: "inline-block" }, function () { return b ? by(a, "margin-right") : a.style.marginRight }) } }) }), f.expr && f.expr.filters && (f.expr.filters.hidden = function (a) { var b = a.offsetWidth, c = a.offsetHeight; return b === 0 && c === 0 || !f.support.reliableHiddenOffsets && (a.style && a.style.display || f.css(a, "display")) === "none" }, f.expr.filters.visible = function (a) { return !f.expr.filters.hidden(a) }), f.each({ margin: "", padding: "", border: "Width" }, function (a, b) { f.cssHooks[a + b] = { expand: function (c) { var d, e = typeof c == "string" ? c.split(" ") : [c], f = {}; for (d = 0; d < 4; d++) f[a + bx[d] + b] = e[d] || e[d - 2] || e[0]; return f } } }); var bC = /%20/g, bD = /\[\]$/, bE = /\r?\n/g, bF = /#.*$/, bG = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg, bH = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i, bI = /^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/, bJ = /^(?:GET|HEAD)$/, bK = /^\/\//, bL = /\?/, bM = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, bN = /^(?:select|textarea)/i, bO = /\s+/, bP = /([?&])_=[^&]*/, bQ = /^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+))?)?/, bR = f.fn.load, bS = {}, bT = {}, bU, bV, bW = ["*/"] + ["*"]; try { bU = e.href } catch (bX) { bU = c.createElement("a"), bU.href = "", bU = bU.href } bV = bQ.exec(bU.toLowerCase()) || [], f.fn.extend({ load: function (a, c, d) { if (typeof a != "string" && bR) return bR.apply(this, arguments); if (!this.length) return this; var e = a.indexOf(" "); if (e >= 0) { var g = a.slice(e, a.length); a = a.slice(0, e) } var h = "GET"; c && (f.isFunction(c) ? (d = c, c = b) : typeof c == "object" && (c = f.param(c, f.ajaxSettings.traditional), h = "POST")); var i = this; f.ajax({ url: a, type: h, dataType: "html", data: c, complete: function (a, b, c) { c = a.responseText, a.isResolved() && (a.done(function (a) { c = a }), i.html(g ? f("<div>").append(c.replace(bM, "")).find(g) : c)), d && i.each(d, [c, b, a]) } }); return this }, serialize: function () { return f.param(this.serializeArray()) }, serializeArray: function () { return this.map(function () { return this.elements ? f.makeArray(this.elements) : this }).filter(function () { return this.name && !this.disabled && (this.checked || bN.test(this.nodeName) || bH.test(this.type)) }).map(function (a, b) { var c = f(this).val(); return c == null ? null : f.isArray(c) ? f.map(c, function (a, c) { return { name: b.name, value: a.replace(bE, "\r\n") } }) : { name: b.name, value: c.replace(bE, "\r\n") } }).get() } }), f.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "), function (a, b) { f.fn[b] = function (a) { return this.on(b, a) } }), f.each(["get", "post"], function (a, c) { f[c] = function (a, d, e, g) { f.isFunction(d) && (g = g || e, e = d, d = b); return f.ajax({ type: c, url: a, data: d, success: e, dataType: g }) } }), f.extend({ getScript: function (a, c) { return f.get(a, b, c, "script") }, getJSON: function (a, b, c) { return f.get(a, b, c, "json") }, ajaxSetup: function (a, b) { b ? b$(a, f.ajaxSettings) : (b = a, a = f.ajaxSettings), b$(a, b); return a }, ajaxSettings: { url: bU, isLocal: bI.test(bV[1]), global: !0, type: "GET", contentType: "application/x-www-form-urlencoded; charset=UTF-8", processData: !0, async: !0, accepts: { xml: "application/xml, text/xml", html: "text/html", text: "text/plain", json: "application/json, text/javascript", "*": bW }, contents: { xml: /xml/, html: /html/, json: /json/ }, responseFields: { xml: "responseXML", text: "responseText" }, converters: { "* text": a.String, "text html": !0, "text json": f.parseJSON, "text xml": f.parseXML }, flatOptions: { context: !0, url: !0 } }, ajaxPrefilter: bY(bS), ajaxTransport: bY(bT), ajax: function (a, c) { function w(a, c, l, m) { if (s !== 2) { s = 2, q && clearTimeout(q), p = b, n = m || "", v.readyState = a > 0 ? 4 : 0; var o, r, u, w = c, x = l ? ca(d, v, l) : b, y, z; if (a >= 200 && a < 300 || a === 304) { if (d.ifModified) { if (y = v.getResponseHeader("Last-Modified")) f.lastModified[k] = y; if (z = v.getResponseHeader("Etag")) f.etag[k] = z } if (a === 304) w = "notmodified", o = !0; else try { r = cb(d, x), w = "success", o = !0 } catch (A) { w = "parsererror", u = A } } else { u = w; if (!w || a) w = "error", a < 0 && (a = 0) } v.status = a, v.statusText = "" + (c || w), o ? h.resolveWith(e, [r, w, v]) : h.rejectWith(e, [v, w, u]), v.statusCode(j), j = b, t && g.trigger("ajax" + (o ? "Success" : "Error"), [v, d, o ? r : u]), i.fireWith(e, [v, w]), t && (g.trigger("ajaxComplete", [v, d]), --f.active || f.event.trigger("ajaxStop")) } } typeof a == "object" && (c = a, a = b), c = c || {}; var d = f.ajaxSetup({}, c), e = d.context || d, g = e !== d && (e.nodeType || e instanceof f) ? f(e) : f.event, h = f.Deferred(), i = f.Callbacks("once memory"), j = d.statusCode || {}, k, l = {}, m = {}, n, o, p, q, r, s = 0, t, u, v = { readyState: 0, setRequestHeader: function (a, b) { if (!s) { var c = a.toLowerCase(); a = m[c] = m[c] || a, l[a] = b } return this }, getAllResponseHeaders: function () { return s === 2 ? n : null }, getResponseHeader: function (a) { var c; if (s === 2) { if (!o) { o = {}; while (c = bG.exec(n)) o[c[1].toLowerCase()] = c[2] } c = o[a.toLowerCase()] } return c === b ? null : c }, overrideMimeType: function (a) { s || (d.mimeType = a); return this }, abort: function (a) { a = a || "abort", p && p.abort(a), w(0, a); return this } }; h.promise(v), v.success = v.done, v.error = v.fail, v.complete = i.add, v.statusCode = function (a) { if (a) { var b; if (s < 2) for (b in a) j[b] = [j[b], a[b]]; else b = a[v.status], v.then(b, b) } return this }, d.url = ((a || d.url) + "").replace(bF, "").replace(bK, bV[1] + "//"), d.dataTypes = f.trim(d.dataType || "*").toLowerCase().split(bO), d.crossDomain == null && (r = bQ.exec(d.url.toLowerCase()), d.crossDomain = !(!r || r[1] == bV[1] && r[2] == bV[2] && (r[3] || (r[1] === "http:" ? 80 : 443)) == (bV[3] || (bV[1] === "http:" ? 80 : 443)))), d.data && d.processData && typeof d.data != "string" && (d.data = f.param(d.data, d.traditional)), bZ(bS, d, c, v); if (s === 2) return !1; t = d.global, d.type = d.type.toUpperCase(), d.hasContent = !bJ.test(d.type), t && f.active++ === 0 && f.event.trigger("ajaxStart"); if (!d.hasContent) { d.data && (d.url += (bL.test(d.url) ? "&" : "?") + d.data, delete d.data), k = d.url; if (d.cache === !1) { var x = f.now(), y = d.url.replace(bP, "$1_=" + x); d.url = y + (y === d.url ? (bL.test(d.url) ? "&" : "?") + "_=" + x : "") } } (d.data && d.hasContent && d.contentType !== !1 || c.contentType) && v.setRequestHeader("Content-Type", d.contentType), d.ifModified && (k = k || d.url, f.lastModified[k] && v.setRequestHeader("If-Modified-Since", f.lastModified[k]), f.etag[k] && v.setRequestHeader("If-None-Match", f.etag[k])), v.setRequestHeader("Accept", d.dataTypes[0] && d.accepts[d.dataTypes[0]] ? d.accepts[d.dataTypes[0]] + (d.dataTypes[0] !== "*" ? ", " + bW + "; q=0.01" : "") : d.accepts["*"]); for (u in d.headers) v.setRequestHeader(u, d.headers[u]); if (d.beforeSend && (d.beforeSend.call(e, v, d) === !1 || s === 2)) { v.abort(); return !1 } for (u in { success: 1, error: 1, complete: 1 }) v[u](d[u]); p = bZ(bT, d, c, v); if (!p) w(-1, "No Transport"); else { v.readyState = 1, t && g.trigger("ajaxSend", [v, d]), d.async && d.timeout > 0 && (q = setTimeout(function () { v.abort("timeout") }, d.timeout)); try { s = 1, p.send(l, w) } catch (z) { if (s < 2) w(-1, z); else throw z } } return v }, param: function (a, c) { var d = [], e = function (a, b) { b = f.isFunction(b) ? b() : b, d[d.length] = encodeURIComponent(a) + "=" + encodeURIComponent(b) }; c === b && (c = f.ajaxSettings.traditional); if (f.isArray(a) || a.jquery && !f.isPlainObject(a)) f.each(a, function () { e(this.name, this.value) }); else for (var g in a) b_(g, a[g], c, e); return d.join("&").replace(bC, "+") } }), f.extend({ active: 0, lastModified: {}, etag: {} }); var cc = f.now(), cd = /(\=)\?(&|$)|\?\?/i; f.ajaxSetup({ jsonp: "callback", jsonpCallback: function () { return f.expando + "_" + cc++ } }), f.ajaxPrefilter("json jsonp", function (b, c, d) { var e = typeof b.data == "string" && /^application\/x\-www\-form\-urlencoded/.test(b.contentType); if (b.dataTypes[0] === "jsonp" || b.jsonp !== !1 && (cd.test(b.url) || e && cd.test(b.data))) { var g, h = b.jsonpCallback = f.isFunction(b.jsonpCallback) ? b.jsonpCallback() : b.jsonpCallback, i = a[h], j = b.url, k = b.data, l = "$1" + h + "$2"; b.jsonp !== !1 && (j = j.replace(cd, l), b.url === j && (e && (k = k.replace(cd, l)), b.data === k && (j += (/\?/.test(j) ? "&" : "?") + b.jsonp + "=" + h))), b.url = j, b.data = k, a[h] = function (a) { g = [a] }, d.always(function () { a[h] = i, g && f.isFunction(i) && a[h](g[0]) }), b.converters["script json"] = function () { g || f.error(h + " was not called"); return g[0] }, b.dataTypes[0] = "json"; return "script" } }), f.ajaxSetup({ accepts: { script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript" }, contents: { script: /javascript|ecmascript/ }, converters: { "text script": function (a) { f.globalEval(a); return a } } }), f.ajaxPrefilter("script", function (a) { a.cache === b && (a.cache = !1), a.crossDomain && (a.type = "GET", a.global = !1) }), f.ajaxTransport("script", function (a) { if (a.crossDomain) { var d, e = c.head || c.getElementsByTagName("head")[0] || c.documentElement; return { send: function (f, g) { d = c.createElement("script"), d.async = "async", a.scriptCharset && (d.charset = a.scriptCharset), d.src = a.url, d.onload = d.onreadystatechange = function (a, c) { if (c || !d.readyState || /loaded|complete/.test(d.readyState)) d.onload = d.onreadystatechange = null, e && d.parentNode && e.removeChild(d), d = b, c || g(200, "success") }, e.insertBefore(d, e.firstChild) }, abort: function () { d && d.onload(0, 1) } } } }); var ce = a.ActiveXObject ? function () { for (var a in cg) cg[a](0, 1) } : !1, cf = 0, cg; f.ajaxSettings.xhr = a.ActiveXObject ? function () { return !this.isLocal && ch() || ci() } : ch, function (a) { f.extend(f.support, { ajax: !!a, cors: !!a && "withCredentials" in a }) }(f.ajaxSettings.xhr()), f.support.ajax && f.ajaxTransport(function (c) { if (!c.crossDomain || f.support.cors) { var d; return { send: function (e, g) { var h = c.xhr(), i, j; c.username ? h.open(c.type, c.url, c.async, c.username, c.password) : h.open(c.type, c.url, c.async); if (c.xhrFields) for (j in c.xhrFields) h[j] = c.xhrFields[j]; c.mimeType && h.overrideMimeType && h.overrideMimeType(c.mimeType), !c.crossDomain && !e["X-Requested-With"] && (e["X-Requested-With"] = "XMLHttpRequest"); try { for (j in e) h.setRequestHeader(j, e[j]) } catch (k) { } h.send(c.hasContent && c.data || null), d = function (a, e) { var j, k, l, m, n; try { if (d && (e || h.readyState === 4)) { d = b, i && (h.onreadystatechange = f.noop, ce && delete cg[i]); if (e) h.readyState !== 4 && h.abort(); else { j = h.status, l = h.getAllResponseHeaders(), m = {}, n = h.responseXML, n && n.documentElement && (m.xml = n); try { m.text = h.responseText } catch (a) { } try { k = h.statusText } catch (o) { k = "" } !j && c.isLocal && !c.crossDomain ? j = m.text ? 200 : 404 : j === 1223 && (j = 204) } } } catch (p) { e || g(-1, p) } m && g(j, k, m, l) }, !c.async || h.readyState === 4 ? d() : (i = ++cf, ce && (cg || (cg = {}, f(a).unload(ce)), cg[i] = d), h.onreadystatechange = d) }, abort: function () { d && d(0, 1) } } } }); var cj = {}, ck, cl, cm = /^(?:toggle|show|hide)$/, cn = /^([+\-]=)?([\d+.\-]+)([a-z%]*)$/i, co, cp = [["height", "marginTop", "marginBottom", "paddingTop", "paddingBottom"], ["width", "marginLeft", "marginRight", "paddingLeft", "paddingRight"], ["opacity"]], cq; f.fn.extend({ show: function (a, b, c) { var d, e; if (a || a === 0) return this.animate(ct("show", 3), a, b, c); for (var g = 0, h = this.length; g < h; g++) d = this[g], d.style && (e = d.style.display, !f._data(d, "olddisplay") && e === "none" && (e = d.style.display = ""), (e === "" && f.css(d, "display") === "none" || !f.contains(d.ownerDocument.documentElement, d)) && f._data(d, "olddisplay", cu(d.nodeName))); for (g = 0; g < h; g++) { d = this[g]; if (d.style) { e = d.style.display; if (e === "" || e === "none") d.style.display = f._data(d, "olddisplay") || "" } } return this }, hide: function (a, b, c) { if (a || a === 0) return this.animate(ct("hide", 3), a, b, c); var d, e, g = 0, h = this.length; for (; g < h; g++) d = this[g], d.style && (e = f.css(d, "display"), e !== "none" && !f._data(d, "olddisplay") && f._data(d, "olddisplay", e)); for (g = 0; g < h; g++) this[g].style && (this[g].style.display = "none"); return this }, _toggle: f.fn.toggle, toggle: function (a, b, c) { var d = typeof a == "boolean"; f.isFunction(a) && f.isFunction(b) ? this._toggle.apply(this, arguments) : a == null || d ? this.each(function () { var b = d ? a : f(this).is(":hidden"); f(this)[b ? "show" : "hide"]() }) : this.animate(ct("toggle", 3), a, b, c); return this }, fadeTo: function (a, b, c, d) { return this.filter(":hidden").css("opacity", 0).show().end().animate({ opacity: b }, a, c, d) }, animate: function (a, b, c, d) { function g() { e.queue === !1 && f._mark(this); var b = f.extend({}, e), c = this.nodeType === 1, d = c && f(this).is(":hidden"), g, h, i, j, k, l, m, n, o, p, q; b.animatedProperties = {}; for (i in a) { g = f.camelCase(i), i !== g && (a[g] = a[i], delete a[i]); if ((k = f.cssHooks[g]) && "expand" in k) { l = k.expand(a[g]), delete a[g]; for (i in l) i in a || (a[i] = l[i]) } } for (g in a) { h = a[g], f.isArray(h) ? (b.animatedProperties[g] = h[1], h = a[g] = h[0]) : b.animatedProperties[g] = b.specialEasing && b.specialEasing[g] || b.easing || "swing"; if (h === "hide" && d || h === "show" && !d) return b.complete.call(this); c && (g === "height" || g === "width") && (b.overflow = [this.style.overflow, this.style.overflowX, this.style.overflowY], f.css(this, "display") === "inline" && f.css(this, "float") === "none" && (!f.support.inlineBlockNeedsLayout || cu(this.nodeName) === "inline" ? this.style.display = "inline-block" : this.style.zoom = 1)) } b.overflow != null && (this.style.overflow = "hidden"); for (i in a) j = new f.fx(this, b, i), h = a[i], cm.test(h) ? (q = f._data(this, "toggle" + i) || (h === "toggle" ? d ? "show" : "hide" : 0), q ? (f._data(this, "toggle" + i, q === "show" ? "hide" : "show"), j[q]()) : j[h]()) : (m = cn.exec(h), n = j.cur(), m ? (o = parseFloat(m[2]), p = m[3] || (f.cssNumber[i] ? "" : "px"), p !== "px" && (f.style(this, i, (o || 1) + p), n = (o || 1) / j.cur() * n, f.style(this, i, n + p)), m[1] && (o = (m[1] === "-=" ? -1 : 1) * o + n), j.custom(n, o, p)) : j.custom(n, h, "")); return !0 } var e = f.speed(b, c, d); if (f.isEmptyObject(a)) return this.each(e.complete, [!1]); a = f.extend({}, a); return e.queue === !1 ? this.each(g) : this.queue(e.queue, g) }, stop: function (a, c, d) { typeof a != "string" && (d = c, c = a, a = b), c && a !== !1 && this.queue(a || "fx", []); return this.each(function () { function h(a, b, c) { var e = b[c]; f.removeData(a, c, !0), e.stop(d) } var b, c = !1, e = f.timers, g = f._data(this); d || f._unmark(!0, this); if (a == null) for (b in g) g[b] && g[b].stop && b.indexOf(".run") === b.length - 4 && h(this, g, b); else g[b = a + ".run"] && g[b].stop && h(this, g, b); for (b = e.length; b--;) e[b].elem === this && (a == null || e[b].queue === a) && (d ? e[b](!0) : e[b].saveState(), c = !0, e.splice(b, 1)); (!d || !c) && f.dequeue(this, a) }) } }), f.each({ slideDown: ct("show", 1), slideUp: ct("hide", 1), slideToggle: ct("toggle", 1), fadeIn: { opacity: "show" }, fadeOut: { opacity: "hide" }, fadeToggle: { opacity: "toggle" } }, function (a, b) { f.fn[a] = function (a, c, d) { return this.animate(b, a, c, d) } }), f.extend({ speed: function (a, b, c) { var d = a && typeof a == "object" ? f.extend({}, a) : { complete: c || !c && b || f.isFunction(a) && a, duration: a, easing: c && b || b && !f.isFunction(b) && b }; d.duration = f.fx.off ? 0 : typeof d.duration == "number" ? d.duration : d.duration in f.fx.speeds ? f.fx.speeds[d.duration] : f.fx.speeds._default; if (d.queue == null || d.queue === !0) d.queue = "fx"; d.old = d.complete, d.complete = function (a) { f.isFunction(d.old) && d.old.call(this), d.queue ? f.dequeue(this, d.queue) : a !== !1 && f._unmark(this) }; return d }, easing: { linear: function (a) { return a }, swing: function (a) { return -Math.cos(a * Math.PI) / 2 + .5 } }, timers: [], fx: function (a, b, c) { this.options = b, this.elem = a, this.prop = c, b.orig = b.orig || {} } }), f.fx.prototype = { update: function () { this.options.step && this.options.step.call(this.elem, this.now, this), (f.fx.step[this.prop] || f.fx.step._default)(this) }, cur: function () { if (this.elem[this.prop] != null && (!this.elem.style || this.elem.style[this.prop] == null)) return this.elem[this.prop]; var a, b = f.css(this.elem, this.prop); return isNaN(a = parseFloat(b)) ? !b || b === "auto" ? 0 : b : a }, custom: function (a, c, d) { function h(a) { return e.step(a) } var e = this, g = f.fx; this.startTime = cq || cr(), this.end = c, this.now = this.start = a, this.pos = this.state = 0, this.unit = d || this.unit || (f.cssNumber[this.prop] ? "" : "px"), h.queue = this.options.queue, h.elem = this.elem, h.saveState = function () { f._data(e.elem, "fxshow" + e.prop) === b && (e.options.hide ? f._data(e.elem, "fxshow" + e.prop, e.start) : e.options.show && f._data(e.elem, "fxshow" + e.prop, e.end)) }, h() && f.timers.push(h) && !co && (co = setInterval(g.tick, g.interval)) }, show: function () { var a = f._data(this.elem, "fxshow" + this.prop); this.options.orig[this.prop] = a || f.style(this.elem, this.prop), this.options.show = !0, a !== b ? this.custom(this.cur(), a) : this.custom(this.prop === "width" || this.prop === "height" ? 1 : 0, this.cur()), f(this.elem).show() }, hide: function () { this.options.orig[this.prop] = f._data(this.elem, "fxshow" + this.prop) || f.style(this.elem, this.prop), this.options.hide = !0, this.custom(this.cur(), 0) }, step: function (a) { var b, c, d, e = cq || cr(), g = !0, h = this.elem, i = this.options; if (a || e >= i.duration + this.startTime) { this.now = this.end, this.pos = this.state = 1, this.update(), i.animatedProperties[this.prop] = !0; for (b in i.animatedProperties) i.animatedProperties[b] !== !0 && (g = !1); if (g) { i.overflow != null && !f.support.shrinkWrapBlocks && f.each(["", "X", "Y"], function (a, b) { h.style["overflow" + b] = i.overflow[a] }), i.hide && f(h).hide(); if (i.hide || i.show) for (b in i.animatedProperties) f.style(h, b, i.orig[b]), f.removeData(h, "fxshow" + b, !0), f.removeData(h, "toggle" + b, !0); d = i.complete, d && (i.complete = !1, d.call(h)) } return !1 } i.duration == Infinity ? this.now = e : (c = e - this.startTime, this.state = c / i.duration, this.pos = f.easing[i.animatedProperties[this.prop]](this.state, c, 0, 1, i.duration), this.now = this.start + (this.end - this.start) * this.pos), this.update(); return !0 } }, f.extend(f.fx, { tick: function () { var a, b = f.timers, c = 0; for (; c < b.length; c++) a = b[c], !a() && b[c] === a && b.splice(c--, 1); b.length || f.fx.stop() }, interval: 13, stop: function () { clearInterval(co), co = null }, speeds: { slow: 600, fast: 200, _default: 400 }, step: { opacity: function (a) { f.style(a.elem, "opacity", a.now) }, _default: function (a) { a.elem.style && a.elem.style[a.prop] != null ? a.elem.style[a.prop] = a.now + a.unit : a.elem[a.prop] = a.now } } }), f.each(cp.concat.apply([], cp), function (a, b) { b.indexOf("margin") && (f.fx.step[b] = function (a) { f.style(a.elem, b, Math.max(0, a.now) + a.unit) }) }), f.expr && f.expr.filters && (f.expr.filters.animated = function (a) { return f.grep(f.timers, function (b) { return a === b.elem }).length }); var cv, cw = /^t(?:able|d|h)$/i, cx = /^(?:body|html)$/i; "getBoundingClientRect" in c.documentElement ? cv = function (a, b, c, d) { try { d = a.getBoundingClientRect() } catch (e) { } if (!d || !f.contains(c, a)) return d ? { top: d.top, left: d.left } : { top: 0, left: 0 }; var g = b.body, h = cy(b), i = c.clientTop || g.clientTop || 0, j = c.clientLeft || g.clientLeft || 0, k = h.pageYOffset || f.support.boxModel && c.scrollTop || g.scrollTop, l = h.pageXOffset || f.support.boxModel && c.scrollLeft || g.scrollLeft, m = d.top + k - i, n = d.left + l - j; return { top: m, left: n } } : cv = function (a, b, c) { var d, e = a.offsetParent, g = a, h = b.body, i = b.defaultView, j = i ? i.getComputedStyle(a, null) : a.currentStyle, k = a.offsetTop, l = a.offsetLeft; while ((a = a.parentNode) && a !== h && a !== c) { if (f.support.fixedPosition && j.position === "fixed") break; d = i ? i.getComputedStyle(a, null) : a.currentStyle, k -= a.scrollTop, l -= a.scrollLeft, a === e && (k += a.offsetTop, l += a.offsetLeft, f.support.doesNotAddBorder && (!f.support.doesAddBorderForTableAndCells || !cw.test(a.nodeName)) && (k += parseFloat(d.borderTopWidth) || 0, l += parseFloat(d.borderLeftWidth) || 0), g = e, e = a.offsetParent), f.support.subtractsBorderForOverflowNotVisible && d.overflow !== "visible" && (k += parseFloat(d.borderTopWidth) || 0, l += parseFloat(d.borderLeftWidth) || 0), j = d } if (j.position === "relative" || j.position === "static") k += h.offsetTop, l += h.offsetLeft; f.support.fixedPosition && j.position === "fixed" && (k += Math.max(c.scrollTop, h.scrollTop), l += Math.max(c.scrollLeft, h.scrollLeft)); return { top: k, left: l } }, f.fn.offset = function (a) { if (arguments.length) return a === b ? this : this.each(function (b) { f.offset.setOffset(this, a, b) }); var c = this[0], d = c && c.ownerDocument; if (!d) return null; if (c === d.body) return f.offset.bodyOffset(c); return cv(c, d, d.documentElement) }, f.offset = { bodyOffset: function (a) { var b = a.offsetTop, c = a.offsetLeft; f.support.doesNotIncludeMarginInBodyOffset && (b += parseFloat(f.css(a, "marginTop")) || 0, c += parseFloat(f.css(a, "marginLeft")) || 0); return { top: b, left: c } }, setOffset: function (a, b, c) { var d = f.css(a, "position"); d === "static" && (a.style.position = "relative"); var e = f(a), g = e.offset(), h = f.css(a, "top"), i = f.css(a, "left"), j = (d === "absolute" || d === "fixed") && f.inArray("auto", [h, i]) > -1, k = {}, l = {}, m, n; j ? (l = e.position(), m = l.top, n = l.left) : (m = parseFloat(h) || 0, n = parseFloat(i) || 0), f.isFunction(b) && (b = b.call(a, c, g)), b.top != null && (k.top = b.top - g.top + m), b.left != null && (k.left = b.left - g.left + n), "using" in b ? b.using.call(a, k) : e.css(k) } }, f.fn.extend({ position: function () { if (!this[0]) return null; var a = this[0], b = this.offsetParent(), c = this.offset(), d = cx.test(b[0].nodeName) ? { top: 0, left: 0 } : b.offset(); c.top -= parseFloat(f.css(a, "marginTop")) || 0, c.left -= parseFloat(f.css(a, "marginLeft")) || 0, d.top += parseFloat(f.css(b[0], "borderTopWidth")) || 0, d.left += parseFloat(f.css(b[0], "borderLeftWidth")) || 0; return { top: c.top - d.top, left: c.left - d.left } }, offsetParent: function () { return this.map(function () { var a = this.offsetParent || c.body; while (a && !cx.test(a.nodeName) && f.css(a, "position") === "static") a = a.offsetParent; return a }) } }), f.each({ scrollLeft: "pageXOffset", scrollTop: "pageYOffset" }, function (a, c) { var d = /Y/.test(c); f.fn[a] = function (e) { return f.access(this, function (a, e, g) { var h = cy(a); if (g === b) return h ? c in h ? h[c] : f.support.boxModel && h.document.documentElement[e] || h.document.body[e] : a[e]; h ? h.scrollTo(d ? f(h).scrollLeft() : g, d ? g : f(h).scrollTop()) : a[e] = g }, a, e, arguments.length, null) } }), f.each({ Height: "height", Width: "width" }, function (a, c) { var d = "client" + a, e = "scroll" + a, g = "offset" + a; f.fn["inner" + a] = function () { var a = this[0]; return a ? a.style ? parseFloat(f.css(a, c, "padding")) : this[c]() : null }, f.fn["outer" + a] = function (a) { var b = this[0]; return b ? b.style ? parseFloat(f.css(b, c, a ? "margin" : "border")) : this[c]() : null }, f.fn[c] = function (a) { return f.access(this, function (a, c, h) { var i, j, k, l; if (f.isWindow(a)) { i = a.document, j = i.documentElement[d]; return f.support.boxModel && j || i.body && i.body[d] || j } if (a.nodeType === 9) { i = a.documentElement; if (i[d] >= i[e]) return i[d]; return Math.max(a.body[e], i[e], a.body[g], i[g]) } if (h === b) { k = f.css(a, c), l = parseFloat(k); return f.isNumeric(l) ? l : k } f(a).css(c, h) }, c, a, arguments.length, null) } }), a.jQuery = a.$ = f, typeof define == "function" && define.amd && define.amd.jQuery && define("jquery", [], function () { return f })
})(window);
        
		
           }
		    var activePage = 1;
          
            var totalPage = 0; 
		    var  pageCount = 0;
		    function ShowCurrentPage() {
			
                totalPage = $('.VATTEMP').length;
                // draw controls
                showPaginationBar(totalPage);
				pageCount =totalPage;
                // show first page
                showPageContent(1);
            };
			   function showPaginationBar (numPages) {
                var pagins = '';
                for (var i = 1; i <= numPages; i++) {
				  $($('.VATTEMP')[i-1]).hide();
                    pagins += '<span class="number" id="ap' + i + '" onclick="showPageContent(' + i + '); return false;">' + i + '</span>';
                }
				
                $('.pagination span:first-child').after(pagins);
					$('#prev').click(function () {
                if (activePage > 1)
                    showPageContent(activePage - 1);
            });
            // and Next
            $('#next').click(function () {
                if (activePage < pageCount)
                    showPageContent(activePage + 1);
            });
            };
			   function showPageContent (page) {
			   
			   $($('.VATTEMP')[activePage-1]).hide();
			   
			           $($('.VATTEMP')[page-1]).show();
                $(".number").removeClass("selected");
                $("#ap" + page).addClass("selected");
                activePage = page;
			   
           
            };
			
		
		
		
		
		
		
		
		
		</script>
		
		]]>
				</xsl:text>
                <script>

                    function displayCert(certName){window.external.displayCert(certName);}function htmlEncode(value) {return $('<div />').text(value).html();}function htmlDecode(value) {return $('<div />').html(value).text();}



                </script>
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
