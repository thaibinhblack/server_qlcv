<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html" pageEncoding="UTF-8"  %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>         
        <meta name="google-site-verification" content="u6uNEfD4cb3gidezi4r_6aI8Wb1E07-ufBeCQpvmlqQ" />
        <title>Hệ thống chăm sóc sức khỏe</title>
        <link rel="icon" href="<c:url value="/resources/images/favicon.ico" />" type="image/x-icon"/> 
        <link rel="shortcut icon" href="<c:url value="/resources/images/favicon.ico" />" type="image/x-icon"/> 

        <!-- jQuery file -->

        <link href="<c:url value="/resources/css/divheader.css" />" rel="stylesheet"/>         
        <link href="<c:url value="/resources/css/style_new.css" />" rel="stylesheet"/>

        <!--Jquery-->
        <link rel="stylesheet" href="<c:url value="/resources/css/jquery-ui-redmond.1.9.1.css" />" />
        <script src="<c:url value="/resources/js/jquery.min.1.8.3.js" />"></script>    
        <script src="<c:url value="/resources/js/jquery-ui.1.9.1.js" />"></script>
        <!--Grid-->
        <link href="<c:url value="/resources/jqueryui/themes/redmond/jquery-ui.css" />" rel="stylesheet"/>
        <link href="<c:url value="/resources/jqgrid/css/ui.jqgrid.css" />" rel="stylesheet"/>           
        <script src="<c:url value="/resources/jqgrid/js/i18n/grid.locale-en.js" />"></script>            
        <script src="<c:url value="/resources/jqgrid/js/jquery.jqGrid.src.js" />"></script>
        <script src="<c:url value="/resources/js/common_function.js" />"></script>
        <script src="<c:url value="/resources/js/export_file.js" />"></script>
        <script src="<c:url value="/resources/js/jquery.inputmask.bundle.min.js" />"></script>
        <script src="<c:url value="/resources/contextmenu/jquery.contextMenu.js" />"></script>
        <link href="<c:url value="/resources/contextmenu/jquery.contextMenu.css" />" rel="stylesheet"/>
        <link href="<c:url value="/resources/dialog/jquery.alerts.1.css" />" rel="stylesheet"/>           
        <script src="<c:url value="/resources/dialog/jquery.alerts.js" />"></script>
        <link href="<c:url value="/resources/dialog/jBox.css" />" rel="stylesheet"/>           
        <script src="<c:url value="/resources/dialog/jBox.js" />"></script>
        <link href="<c:url value="/resources/combogrid/css/smoothness/jquery.ui.combogrid.css" />" rel="stylesheet"/>           
        <script src="<c:url value="/resources/combogrid/plugin/jquery.ui.combogrid-1.6.3.js" />"></script>
        <script src="<c:url value="/resources/js/tableExport.js" />"></script>
        <script src="<c:url value="/resources/js/jquery.base64.js" />"></script>
        <script src="<c:url value="/resources/js/excellentexport.js" />"></script>
        <!-- Begin An Giang - Tâm 0918197999 ngày 20/06/2017: In phiếu điều trị và phiếu khám nhập viện tại Danh sách nhập viện bằng APP -->
        <script src="<c:url value="/resources/js/read_file.js" />"></script>
        <!-- Begin An Giang - Tâm 0918197999 ngày 20/06/2017: In phiếu điều trị và phiếu khám nhập viện tại Danh sách nhập viện bằng APP-->
        <!--CMU BS DATE PICKER-->
        <script src="<c:url value="/resources/js/datetimepicker.js" />"></script>
        <link href="<c:url value="/resources/css/datetimepicker.css" />" rel="stylesheet"/>
        <link href="<c:url value="/resources/bootstrap/css/select2.min.css"/>" rel="stylesheet">
        <script src="<c:url value="/resources/bootstrap/js/select2.min.js"/>" ></script>
        <style>
            #dialog_nhapvien td{
                font-size: 12px;
            }
            .width_1 {
                width:755px;
            }
            .width_2 {
                width:120px;
            }
            .width_3 {
                width:90px;
            }
            .width_4 {
                width:200px;
            }
            .width_5 {
                width:660px;
            }
        </style>
        <script>
            var makhambenh_nv, sovaovien = "0";
            function load_tt_phieudieutri(makhambenh, icd) {
                $("#makhambenh_pdt").val(makhambenh);
                $("#matoathuoc_pdt").val(makhambenh.replace("kb", "tt"));
                var url_tt = "thongtinhanhchinhchuyentuyen?makb=" + makhambenh + "&dvtt=${Sess_DVTT}";
                $.getJSON(url_tt, function (result) {
                    $.each(result, function (i, field) {
                        $("#mayte_pdt").val(field.MA_BENH_NHAN);
                        $("#hoten_pdt").val(field.TEN_BENH_NHAN);
                        $("#sobhyt_pdt").val(field.SO_THE_BHYT);
                        if (field.SO_THE_BHYT != "") {
                            var madt = $("#sobhyt_pdt").val().substring(0, 3);
                            var urlthe = "kiemtrathebhyt?madt=" + madt;
                            $.ajax({
                                url: urlthe
                            }).done(function (data) {
                                var arr = data.toString().split(":");
                                $("#doituong_pdt").val(arr[0]);
                            });
                        }
                        $("#tuoi_pdt").val(field.TUOI);
                        $("#tlmg_pdt").val(field.TI_LE_MIEN_GIAM);
                        $("#diachi_pdt").val(field.DIA_CHI);
                    });
                });
                $("#icd_pdt").val(icd);
                var url = "laymotabenhly?icd=" + icd;
                $.ajax({
                    url: url
                }).done(function (data) {
                    if (data.trim() != "") {
                        arr = data.split("!!!");
                        $("#icd_pdt").val($("#icd_pdt").val().toString().toUpperCase());
                        $("#cb_icd_pdt").val(arr[1]);
                        $("#mabenhly_pdt").val(arr[0]);
                    }
                    else {
                        $("#cb_icd_pdt").val("");
                        $("#mabenhly_pdt").val("");
                    }
                });
                var url_pdt = "phieudieutrinoitru_select?makhambenh=" + makhambenh + "&dvtt=${Sess_DVTT}";
                $.getJSON(url_pdt, function (result) {
                    $.each(result, function (i, field) {
                        $("#mach_pdt").val(field.MACH);
                        $("#nhiptho_pdt").val(field.NHIP_THO);
                        $("#nhietdo_pdt").val(field.NHIET_DO);
                        $("#huyetaptren_pdt").val(field.HUYET_AP_CAO);
                        $("#huyetapduoi_pdt").val(field.HUYET_AP_THAP);
                        $("#chieucao_pdt").val(field.CHIEU_CAO);
                        $("#cannang_pdt").val(field.CAN_NANG);
                        $("#matoathuoc_pdt").val(field.MA_TOA_THUOC);
                        $("#dientienbenh_pdt").val(field.DIEN_TIEN_BENH);
                        $("#cls_pdt").val(field.CAN_LAM_SANG);
                        $("#chandoan_pdt").val(field.CHAN_DOAN);
                    });
                }).done(function () {
                    var url = 'phieudieutrinoitru_chitiettoathuoc_select?matoathuoc=' + makhambenh.replace("kb", "tt") + "&dvtt=${Sess_DVTT}";
                    $("#list_thuocvattu_pdt").jqGrid('setGridParam', {datatype: 'json', url: url}).trigger('reloadGrid');
                });
            }
            $(function () {
                var row_data;
                function datetimeFmatter(cellvalue, options, rowObject)
                {
                    var d = new Date(cellvalue);
                    return format_date(d.getDate()) + "/" + format_date(d.getMonth() + 1) + "/" + d.getFullYear() + " " + format_date(d.getHours()) + ":" + format_date(d.getMinutes()) + ":" + format_date(d.getSeconds());
                }
                function format_date(value) {
                    if (value.toString().length == 1)
                        value = "0" + value;
                    return value;
                }
                $("#list_benhnhan").jqGrid({
                    url: '',
                    datatype: "local",
                    loadonce: true,
                    height: 400,
                    width: 980, //1010,
                    colNames: ["Khoa nội trú", "Ngày nhập viện", "Mã y tế", "Họ tên", "Nam", "Tuổi/tháng", "Thẻ", "STT BA", "Số BA",
                        "madoituong", "tylemiengiam", "noidangky", "ngaybatdau", "ngayhethan", "dungtuyen", "ICD Nhập viện",// AGG Quí chỉnh sửa bổ sung ICD nhập viện ngày 05/12/2016
                        "tenbenhphu", "hinhthucnhapvien", "noigioithieu", "lydonhapvien", "khoachidinh",
                        "nhapvienvaokhoa","MA_PHONGKHAM_DT","TEN_PHONGKHAM_DT",  "stt_logkhoaphong", "vaovienlanthu", "makhambenhngoaitru_nhapvien",
                        "tennoigioithieu", "icdnguyennhan", "sobenhan", "sobenhan_tt", "Địa chỉ", "Đợt điều trị"],
                    colModel: [
                        {name: 'TEN_PHONGBAN', index: 'TEN_PHONGBAN', width: 100},
                        {name: 'NGAYNHAPVIEN', index: 'NGAYNHAPVIEN', width: 100},
                        {name: 'MA_BENH_NHAN', index: 'MA_BENH_NHAN', width: 30},
                        {name: 'TEN_BENH_NHAN', index: 'TEN_BENH_NHAN', width: 100, searchoptions: {dataInit: function (el) {
                                    setTimeout(function () {
                                        $(el).focus().trigger({type: 'keypress', charCode: 13});
                                    }, 20);
                                }
                            }},
                        {name: 'GIOI_TINH', index: 'GIOI_TINH', width: 30, formatter: 'checkbox', formatoptions: {value: 'true:false'}, align: 'center'},
                        {name: 'TUOI', index: 'TUOI', width: 30},
                        {name: 'SOBAOHIEMYTE', index: 'SOBAOHIEMYTE', width: 100},
                        {name: 'STT_BENHAN', index: 'STT_BENHAN', width: 50},
                        {name: 'SOBENHAN', index: 'SOBENHAN', width: 50},
                        {name: "MADOITUONG", index: "MADOITUONG", hidden: true},
                        {name: 'TYLEBAOHIEM', index: 'TYLEBAOHIEM', hidden: true},
                        {name: 'NOIDANGKYBANDAU', index: 'NOIDANGKYBANDAU', hidden: true},
                        {name: 'NGAYBATDAU_THEBHYT', index: 'NGAYBATDAU_THEBHYT', hidden: true},
                        {name: 'NGAYHETHAN_THEBHYT', index: 'NGAYHETHAN_THEBHYT', hidden: true},
                        {name: 'DUNGTUYEN', index: 'DUNGTUYEN', hidden: true},
                        {name: 'ICD_NHAPVIEN', index: 'ICD_NHAPVIEN',width: 70}, // AGG Quí chỉnh sửa bổ sung ICD nhập viện ngày 05/12/2016
                        {name: 'TENBENHPHU_NHAPVIEN', index: 'TENBENHPHU_NHAPVIEN', hidden: true},
                        {name: 'HINHTHUCNHAPVIEN', index: 'HINHTHUCNHAPVIEN', hidden: true},
                        {name: 'NOIGIOITHIEU', index: 'NOIGIOITHIEU', hidden: true},
                        {name: 'LYDO_TRANGTHAI_BN_NHAPVIEN', index: 'LYDO_TRANGTHAI_BN_NHAPVIEN', hidden: true},
                        {name: 'KHOACHIDINHNHAPVIEN', index: 'KHOACHIDINHNHAPVIEN', hidden: true},
                        {name: 'NHAPVIENVAOKHOA', index: 'NHAPVIENVAOKHOA', hidden: true},
                        {name: 'MA_PHONGKHAM_DT', index: 'MA_PHONGKHAM_DT', hidden: true},
                        {name: 'TEN_PHONGKHAM_DT', index: 'TEN_PHONGKHAM_DT', hidden: true},
                        {name: 'STT_LOGKHOAPHONG', index: 'STT_LOGKHOAPHONG', hidden: true},
                        {name: 'VAOVIENLANTHU', index: 'VAOVIENLANTHU', hidden: true},
                        {name: 'MAKHAMBENHNGOAITRU_NHAPVIEN', index: 'MAKHAMBENHNGOAITRU_NHAPVIEN', hidden: true},
                        {name: 'TEN_NOIGIOITHIEU', index: 'TEN_NOIGIOITHIEU', hidden: true},
                        {name: 'CHANDOAN_NGUYENNHAN', index: 'CHANDOAN_NGUYENNHAN', hidden: true},
                        {name: 'SOBENHAN', index: 'SOBENHAN', hidden: true},
                        {name: 'SOBENHAN_TT', index: 'SOBENHAN_TT', hidden: true},
                        {name: 'DIA_CHI', index: 'DIA_CHI', width: 70},
                        {name: 'STT_DOTDIEUTRI', index: 'STT_DOTDIEUTRI', width: 50}
                    ],
                    //sortname: 'stt_benhan',
                    viewrecords: true,
                    rowNum: 1000000,
                    caption: "Danh sách bệnh nhân nhập viện",
//                    grouping: true,
//                    groupingView: {
//                        groupField: ['ten_phongban'],
//                        groupColumnShow: [false],
//                        groupText: ['<b>{0}</b>'],
//                        groupCollapse: false
//                    },
                    ignoreCase: true,
                    onRightClickRow: function (id1) {
                        if (id1) {
                            $('#list_benhnhan').jqGrid('setSelection', id1);

                            $.contextMenu({
                                selector: '#list_benhnhan tr',
                                callback: function (key, options) {
                                    if (key == "huy") {
                                        var id = $("#list_benhnhan").jqGrid('getGridParam', 'selrow');
                                        var ret = $("#list_benhnhan").jqGrid('getRowData', id);
                                        jConfirm('Bạn có muốn hủy nhập viện cho bệnh nhân <b>' + ret.TEN_BENH_NHAN + "</b>?", 'Cảnh báo', function (r) {
                                            if (r.toString() == "true") {
                                                var arr = ["${Sess_DVTT}", ret.STT_BENHAN, ret.STT_DOTDIEUTRI, ret.STT_LOGKHOAPHONG, ret.TEN_BENH_NHAN];
                                                var url = "xoatiepnhannhapvien?url=" + convertArray(arr);
                                                $.ajax({
                                                    url: url
                                                }).done(function (data) {
                                                    if (data == "1") {
                                                        jAlert("Bệnh nhân đang điều trị", 'Cảnh báo');
                                                    }
                                                    else if (data == "2") {
                                                        jAlert("Bệnh nhân đã xuất viện", 'Cảnh báo');
                                                    }
													else if (data == "5") {
                                                        jAlert("Bệnh nhân đã tạm ứng tiền nội trú", 'Cảnh báo');
                                                    }
                                                    reload_grid();
                                                });
                                            }
                                        });
                                    }
                                    if (key == "capnhatnhapvien") {
                                        tt_nhapvien = 1;
                                        $("#nhapvien").val("Cập nhật");
                                        $("#ngaynhapvien").attr("disabled", false);
                                        $("#gionhapvien").attr("disabled", false);
                                        var id = $("#list_benhnhan").jqGrid('getGridParam', 'selrow');
                                        row_data = $("#list_benhnhan").jqGrid('getRowData', id);
                                        clear_inputnhapvien();
                                        var ngaygio = row_data.NGAYNHAPVIEN.split(" ");
                                        $("#ngaynhapvien").val(ngaygio[0]);
                                        $("#gionhapvien").val(ngaygio[1]);
                                        $("#hoten_nhapvien").val(row_data.TEN_BENH_NHAN);
                                        $("#sobhyt_nhapvien").val(row_data.SOBAOHIEMYTE);
                                        $("#tuoi_nhapvien").val(row_data.TUOI);
                                        $("#tlmiengiam_nhapvien").val(row_data.TYLEBAOHIEM);
                                        $("#diachi_nhapvien").val(row_data.DIA_CHI);
                                        $("#maicd_nhapvien").val(row_data.ICD_NHAPVIEN);
                                        makhambenh_nv = row_data.MAKHAMBENHNGOAITRU_NHAPVIEN;
                                        var khoanhapvien_edit = row_data.NHAPVIENVAOKHOA;// EDIT_THEM PHÒNG ĐIỀU TRỊ - VEN HGI
                                        var maphongnhapvien = row_data.MA_PHONGKHAM_DT;
                                        if ($("#maicd_nhapvien").val() !== "") {
                                            var url = "laymotabenhly?icd=" + $("#maicd_nhapvien").val();
                                            $.ajax({
                                                url: url
                                            }).done(function (data) {
                                                var arr = data.split("!!!");
                                                $("#tenicd_nhapvien").val(arr[1]);
                                                $("#mabenhly_nhapvien").val(arr[0]);
                                            });
                                            // BEGIN THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
                                            var url1 = "layphongbenh_theokhoa?khoa=" + khoanhapvien_edit + "&dvtt=${Sess_DVTT}";
                                                $.ajax({
                                                    url: url1
                                                }).done(function (data) {
                                                    if (data) {
                                                        $("#phongnhapvien_bant_edit").empty();
                                                        $.each(data, function (i) {
                                                            $("<option value='" + data[i].MA_PHONG_BENH + "'>" + data[i].TEN_PHONG_BENH + "</option>").appendTo("#phongnhapvien_bant_edit");
                                                        });
                                                        $("#phongnhapvien_bant_edit").val(maphongnhapvien);
                                                    }
                                                });
                                            // END THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
                                        }
                                        $("#benhphu_nhapvien").val(row_data.TENBENHPHU_NHAPVIEN);
                                        $("#lydonhapvien_nhapvien").val(row_data.LYDO_TRANGTHAI_BN_NHAPVIEN);
                                        $("#khoanhapvien").val(row_data.NHAPVIENVAOKHOA);
                                        $("input[name=noigioithieu][value=" + row_data.NOIGIOITHIEU + "]").prop('checked', true);
                                        $("#tennoigioithieu").val(row_data.TEN_NOIGIOITHIEU);
                                        $("#maicdnguyenhan_nhapvien").val(row_data.CHANDOAN_NGUYENNHAN);
                                        $("#mabenhan").val(row_data.SOBENHAN);
                                        $("#mabenhan_tt").val(row_data.SOBENHAN_TT);

                                        stt_benhan = row_data.STT_BENHAN;
                                        if ($("#maicdnguyenhan_nhapvien").val() !== "") {
                                            var url = "laymotabenhly?icd=" + $("#maicdnguyenhan_nhapvien").val();
                                            $.ajax({
                                                url: url
                                            }).done(function (data) {
                                                var arr = data.split("!!!");
                                                $("#tenicdnguyennhan_nhapvien").val(arr[1]);
                                                $("#mabenhlynguyennhan_nhapvien").val(arr[0]);
                                            });
                                        }
                                        $("#taophieudieutri_nv").show();
                                        $("#taophieudieutri").hide();
                                        dialog_nhapvien.dialog("open");
                                    }
                                },
                                items: {
                                    "capnhatnhapvien": {
                                        name: "Cập nhật thông tin nhập viện"
                                    },
                                    "huy": {name: "Hủy nhập viện"}
                                }
                            });
                        }
                    },
                    footerrow: true,
                    loadComplete: function () {
                        $("#list_benhnhan").jqGrid('setGridParam', {loadonce: true});
                        var $self = $(this);
                        //var count_dv = $self.jqGrid("getCol", "ten_donvi", false, "count");
                        var count_dv = $("#list_benhnhan").getGridParam("records");
                        count_dv = "Tổng: " + count_dv + " bệnh nhân";
                        $self.jqGrid("footerData", "set", {TEN_BENH_NHAN: count_dv});
                        var rowIDs = jQuery("#list_benhnhan").getDataIDs(); 
                        for (var i=0;i<rowIDs.length;i=i+1){ 
                            rowData=jQuery("#list_benhnhan").getRowData(rowIDs[i]);
                            //set row attributes
                            var trElement = jQuery("#"+ rowIDs[i],jQuery('#list_benhnhan'));
                            trElement.removeClass('ui-widget-content');
                            trElement.addClass("intro");              
                            //BEGIN THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
                            if (rowData.BANT == '1') {  
                                //set color of second cell to red
                                $('#'+rowIDs[i]+' td:eq(4)').css({'background-color':'#819FF7'});  //$('#'+rowIDs[i]+' td:eq(1)'): tô màu cụ thể cho từng ô
                            } 
                            //END THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
                        }
                    }
                });
                $("#list_benhnhan").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
                $(":input").inputmask();
                $("#tungay").inputmask({
                    mask: "1/2/y h:s",
                    placeholder: "dd/mm/yyyy hh:mm",
                    alias: "datetime",
                    hourFormat: "24"
                });
                $("#denngay").inputmask({
                    mask: "1/2/y h:s",
                    placeholder: "dd/mm/yyyy hh:mm",
                    alias: "datetime",
                    hourFormat: "24"
                });
                $("#tungay").datetimepicker({
                    dateFormat: "dd/mm/yy"
                });
                $("#denngay").datetimepicker({
                    dateFormat: "dd/mm/yy"
                });
                $("#tungay").val("${ngayhientai} 00:00");
                $("#denngay").val("${ngayhientai} 23:59");
                $("#xemdanhsach").click(function (evt) {
                    reload_grid();
                });
                $("#xuatbaocao").click(function (evt) {
                    var tungay = $("#tungay").val();
                    var denngay = $("#denngay").val();
                    //VTU: 19/10/2016
                    var khoa = $("#phongban").val();
                    var phong = $("#phong").val();
                    var loaibaocao = $("#hinhthuc").val();
                    // Begin AGG Quí bổ sung option cho lọc theo dân tộc, giới tính 13/12/2016
                    var gioitinh = $("#gioitinh").val();
                    var dantoc = $("#dantoc").val();
                    var doituong = $("#doituong").val();
                    var arr = ["${Sess_DVTT}", tungay, denngay, loaibaocao, khoa, phong,gioitinh,dantoc];
                    // End AGG Quí bổ sung option cho lọc theo dân tộc, giới tính 13/12/2016
                    // VTU:19/10/2016

                    var url = "";
                    url = "indsbenhnhannhapvien_formkhambenh?url=" + convertArray(arr) + "&doituong=" + doituong;
                    $(location).attr('href', url);
                });
                $("#nhapvien").click(function (evt) {
                    var ngay = $("#ngaynhapvien").val();
                    var gio = $("#gionhapvien").val();
                    var icd = $("#maicd_nhapvien").val();
                    var tenicd = $("#tenicd_nhapvien").val();
                    var mabenhchinh = $("#mabenhly_nhapvien").val();
                    var benhphu = $("#benhphu_nhapvien").val();
                    var khoanhapvien = $("#khoanhapvien").val();
                    var tenkhoanhapvien = $("#khoanhapvien option:selected").text();
                    var phongnhapvien = $("#phongnhapvien_bant_edit").val();// EDIT_THEM PHÒNG ĐIỀU TRỊ - VEN HGI
                    var tenphongnhapvien = $("#phongnhapvien_bant_edit option:selected").text();// EDIT_THEM PHÒNG ĐIỀU TRỊ - VEN HGI
                        tenphongnhapvien = tenphongnhapvien =="" ? "null" : tenphongnhapvien;
                    var khoanhapvien = $("#khoanhapvien").val();
                    var tenkhoanhapvien = $("#khoanhapvien option:selected").text();
                    var lydo = $("#lydonhapvien_nhapvien").val();
                    var noigioithieu = $('input[name=noigioithieu]:checked').val();
                    var tennoigioithieu = $("#tennoigioithieu").val();
                    var icdnguyennhan = $("#maicdnguyenhan_nhapvien").val();
                    //BEGIN THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
                    var arr = [convertStr_MysqlDate(ngay), gio, icd, tenicd, mabenhchinh, benhphu, lydo,
                        tenkhoanhapvien, khoanhapvien, stt_benhan, row_data.STT_DOTDIEUTRI,
                        noigioithieu, tennoigioithieu, icdnguyennhan, "${Sess_DVTT}", phongnhapvien, tenphongnhapvien];
                    if (khoanhapvien == "" || khoanhapvien == "-1" )
                        jAlert("Vui lòng chọn khoa nhập viện cho bệnh nhân", 'Cảnh báo');
                    else if (icd == "" || tenicd == "" || mabenhchinh == "")
                        jAlert("Vui lòng nhập bệnh nhập viện cho bệnh nhân", 'Cảnh báo');
                    else {
                        if (row_data.STT_BENHAN != "") {
                            var url = "capnhat_thongtinnhapvien?url=" + convertArray(arr);
                            $.ajax({
                                url: url
                            }).done(function (data) {
                                jAlert("Cập nhật thành công", 'Thông báo');
                                //reload_grid();
                            });
                        }
                    }
                });
                $("#taophieudieutri_nv").click(function () {
                    load_tt_phieudieutri(makhambenh_nv, $("#maicd_nhapvien").val());
                    phieudieutri_dialog.dialog("open");
                });

                //====VTU: 19/10/2016=================
                $("#phongban").change(function (evt) {
                    var url = "layphongbenh_theokhoa?khoa=" + $("#phongban").val() + "&dvtt=${Sess_DVTT}";
                    $.ajax({
                        url: url
                    }).done(function (data) {
                        if (data) {
                            $("#phong").empty();
                            $("<option value='-1'>-- Tất cả phòng --</option>").appendTo("#phong");
                            $.each(data, function (i) {
                                $("<option value='" + data[i].MA_PHONG_BENH + "'>" + data[i].TEN_PHONG_BENH + "</option>").appendTo("#phong");
                            });
                        }
                    });
                });

                //====and VTU: 19/10/2016=================
                function reload_grid() {
                    var tungay = $("#tungay").val();
                    var denngay = $("#denngay").val();
                    var loaibc = $("#hinhthuc").val();
                    //=VTU:19/10/2016==
                    var khoa = $("#phongban").val();
                    var phong = $("#phong").val();
                    // Begin AGG Quí bổ sung option cho lọc theo dân tộc, giới tính 13/12/2016
                    var gioitinh = $("#gioitinh").val();
                    var dantoc = $("#dantoc").val();
                    var doituong = $("#doituong").val();
                    var arr = ["${Sess_DVTT}", tungay, denngay, loaibc, khoa, phong,gioitinh,dantoc];
                     // End AGG Quí bổ sung option cho lọc theo dân tộc, giới tính 13/12/2016
                    //=and VTU:19/10/2016
                    var url = 'danhsachbenhnhan_nhapvien_theotrangthai?url=' + convertArray(arr) + "&doituong=" + doituong;
                    //  jAlert(url);
                    $("#list_benhnhan").jqGrid('setGridParam', {datatype: 'json', url: url}).trigger('reloadGrid');

                }

            });


        </script>
    </head>
    <body>
        <div id="panel_all">
            <%@include file="../../../resources/Theme/include_pages/menu.jsp"%>
            <div id="panelwrap">
                <div class="center_content"> 
                    <table width="100%" align="center" id="table_bd">
                        <tr>
                            <td align="center">
                                <div class="panel_with_title">
                                    <div class="panel_title">Danh sách bệnh nhân nhập viện</div>
                                    <div class="panel_body">
                                        <form name="form1" method="post" action="">
                                            <table width="656" border="0">
                                                <!-- ======================================== VTU sửa ngày 19/10/2016 ==============================================================-->

                                                <tr>
                                                    <td>Khoa </td>
                                                    <td  width="190">  <select name="phongban" class="width100" id="phongban" style ="width:200px" >
                                                            <option value="-1">-- Tất cả khoa --</option>
                                                            <c:forEach var="i" items="${phongban}">
                                                                <option value="${i.MA_PHONGBAN}">${i.TEN_PHONGBAN}</option>
                                                            </c:forEach>
                                                        </select></td>
                                                    <td>Phòng </td>
                                                    <td width="200" >  <select name="phong"  class="width100" style ="width:200px"  id="phong">
                                                            <option value="-1">-- Tất cả phòng --</option>
                                                            <c:forEach var="i" items="${phongbenh}">
                                                                <option value="${i.MA_PHONG_BENH}">${i.TEN_PHONG_BENH}</option>
                                                            </c:forEach>
                                                        </select></td> 
                                                </tr>


                                                <!-- END VTU: 19/10/2016 -->
                                                <tr>
                                                    <td>Từ ngày</td>
                                                    <td><input name="idtiepnhan" type="hidden" class="" id="idtiepnhan"  /><input name="tungay" type="text" class="width_2" id="tungay" data-inputmask="'alias': 'date'" /></td>
                                                    <td width="158">Đến ngày</td>
                                                    <td width="170"><input name="denngay" type="text" class="width_2" id="denngay" data-inputmask="'alias': 'date'" /></td>
                                                </tr>
                                            <!-- AGG Quí 13/12/2016 bổ sung option cho lọc theo dân tộc, giới tính -->
                                            <tr>
                                            <td style="width:150px;" >Dân tộc</td>
                                                    <td><select name="dantoc" class="width_2" id="dantoc">
                                                            <option value="-1" selected="selected">--- Tất cả ---</option>
                                                            <c:forEach var="i" items="${dantoc}">
                                                                <option value="${i.ma_dantoc}">${i.ten_dantoc}</option>
                                                            </c:forEach>
                                                        </select></td>
                                            <td style="width:150px;" >Giới tính</td>
                                                    <td>
                                                        <select name="gioitinh" class="width_2" id="gioitinh">
                                                            <option value="-1">--Tất cả--</option>
                                                            <option value="1">Nam</option>
                                                            <option value="0">Nữ</option>
                                                        </select>
                                                    </td>
                                        </tr>
                                            <!-- AGG Quí 13/12/2016 bổ sung option cho lọc theo dân tộc, giới tính -->
                                                <tr>
                                                    <td width="141">Hình thức báo cáo</td>
                                                    <td width="169"><select name="hinhthuc" class="width_2" id="hinhthuc">
                                                            <c:forEach var="i" items="${loaibaocao}">
                                                                <option value="${i.ma}">${i.ten}</option>
                                                            </c:forEach>
                                                        </select></td>
                                                    <td>Đối tượng</td>
                                                    <td>
                                                        <select name="doituong" class="width_2" id="doituong">
                                                            <option value="-1">--Tất cả--</option>
                                                            <option value="1">BANT</option>
                                                            <option value="0" selected>Nội trú</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4"><input type="button" name="xemdanhsach" id="xemdanhsach" value="Xem danh sách" class="button_shadow" style="width:120px"/>
                                                        <input type="button" name="xuatbaocao" id="xuatbaocao" value="Xuất báo cáo" class="button_shadow" style="width:100px"/></td>
                                                </tr>
                                            </table>
                                        </form>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center"><table id="list_benhnhan" style="font-size: 12px; font-family:Verdana"></table>
                                <div id="export_file"></div>
                            </td>
                        </tr>
                    </table>
                </div> <!--end of center_content-->
				<%@include file="../../../resources/Theme/include_pages/footer.jsp"%>
            </div>
        </div>
        <%@include file="Nhapvien.jsp"%>
        <%@include file="Phieudieutri.jsp"%>
        <%@include file="Phieunhapvien.jsp"%>
    </body>
</html>
