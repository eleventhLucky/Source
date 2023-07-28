<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Insert title here</title>

            <%-- <jsp:include page="base.jsp" flush="false" /> --%>

            <script>
                var cntGridVisit1 = 0;
                var isExcelVisit1 = false;

                $(function () {

                    setCombo("searchOpt0", "visit1_opt0"); // 상세검색
                    $("#searchOpt1").jqxInput({ minLength: 1 });
                    setCombo("searchOpt2", "visit1_opt2");	//작성자구분
                    setCombo("searchOpt3", "", "getCombo_visit1_opt3"); //결재상태
                    setCombo("searchOpt11", "visit1_opt11"); //접견자구분
                    setCombo("searchOpt12", "s1013", "cateCombo", "cateName", "cateName");  //방문장소
                    setCombo("searchOpt13", "s1011", "cateCombo", "cateName", "cateName");  //방문유형
                    setCombo("searchOpt14", "s1014", "cateCombo", "cateName", "cateName");  //접견장소
                    setCombo("searchOpt5", "", "getCombo_visit1_opt5");    //결재자구분
                    $("#searchOpt6").jqxInput({ minLength: 1 });
                    setCombo("searchOpt8", '<c:out value="${visit1_opt8}"/>');
                    $("#searchOpt8").jqxComboBox({ width: 100 });

                    $("#searchOpt9").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
                    $("#searchOpt10").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
                    
                    $("#searchOpt9").val('');
                    $("#searchOpt10").val('');
                    
                    setTriggerSearch("searchOpt1");


                    var cellsrenderer1 = function (row, columnfield, value, defaulthtml, columnproperties) {
                        //return '<a href="${pageContext.request.contextPath}/lucky>'+value+'</a>'
                        //return '<a href="lucky">lucky</a>';
                        //return '<span style="margin: 4px;  color: #0000ff;">' + value + '</span>';
                        //return "<div style='background: #0000ff;'>" + value + "</div>"
                        return '<div class="grid-cell-link"><a href="javascript:detail_view(9)" >' + value + '</a></div>';
                    };

                    // prepare the data
                    $("#grdMain").jqxGrid(
                        {
                            columnsresize: true,
                            width: '100%',
                            height: '760px',
                            pageable: true,
                            pagesize: 20,
                            pagesizeoptions: ['5', '10', '15', '20', '30', '50', '100', '300', '500', 'Total'],
                            virtualmode: true,
                            rendergridrows: function (obj) {
                                return obj.data;
                            },

                            columns: [
                                { text: '순번', datafield: 'Idx', width: 50, align: 'center', cellsalign: 'center' },
                                { text: '문서번호', datafield: 'DocCode', width: 150, align: 'center', cellsalign: 'center', cellsrenderer: cellsrenderer1 },
                                { text: '작성자', datafield: 'WriteName', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '접견자', datafield: 'ReqName', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '<c:out value="${submitDateText}"/>', datafield: 'AppDate', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '신청일', datafield: 'ReqDate', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '방문유형', datafield: 'ValueSt3', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '방문장소', datafield: 'ValueSt5', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '접견장소', datafield: 'ValueSt6', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '결재상태', datafield: 'DocTypeName', width: 150, align: 'center', cellsalign: 'center' },

                                { text: '내방예약기간', datafield: 'ValueDate', width: 300, align: 'center', cellsalign: 'center' },
                                { text: '내방객', datafield: 'ValueSub1', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '업체명', datafield: 'ValueSub2', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '내방차량', datafield: 'ValueSub3', width: 150, align: 'center', cellsalign: 'center' },
                                { text: '반입물품', datafield: 'ValueSub4', width: 150, align: 'center', cellsalign: 'center' },
                            ]
                        });

                    $("#grdMain").on("pagechanged", function (event) {
                        // event arguments.
                        var args = event.args;
                        // page number.
                        var pagenum = args.pagenum;
                        // page size.
                        var pagesize = args.pagesize;

                    });

                    $('#btnReset').on('click', function () {
                        $("#searchOpt0").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt1").val("");
                        $("#searchOpt2").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt3").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt11").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt12").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt13").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt14").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt5").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt6").val("");
                        $("#searchOpt7").val("");
                        $("#searchOpt8").jqxComboBox({selectedIndex: 0});
                        $("#searchOpt9").val('');
                        $("#searchOpt10").val('');
                    });


                    $('#btnSearch').on('click', function () {
                        isExcelVisit1 = false;

                        var url = "/visit1Search";
                        // prepare the data
                        var source =
                        {
                            datatype: "json",
                            datafields: [
                                { name: 'Ino', type: 'string' },
                                { name: 'Idx', type: 'string' },
                                { name: 'DocCode', type: 'string' },
                                { name: 'WriteName', type: 'string' },
                                { name: 'ReqName', type: 'string' },
                                { name: 'AppDate', type: 'string' },
                                { name: 'ReqDate', type: 'string' },
                                { name: 'ValueSt3', type: 'string' },
                                { name: 'ValueSt5', type: 'string' },
                                { name: 'ValueSt6', type: 'string' },
                                { name: 'DocType', type: 'string' },
                                { name: 'DocTypeName', type: 'string' },
                                { name: 'ValueDate', type: 'string' },
                                { name: 'ValueSub1', type: 'string' },
                                { name: 'ValueSub2', type: 'string' },
                                { name: 'ValueSub3', type: 'string' },
                                { name: 'ValueSub4', type: 'string' },
                                { name: 'ValueSub4', type: 'int' }
                            ],
                            type: "POST",
                            beforeprocessing: function (data) {
                                if (data.length > 0) {
                                    cntGridVisit1 = data[0].totalCount;
                                    source.totalrecords = data[0].totalCount;
                                } else {
                                    cntGridVisit1 = 0;
                                    source.totalrecords = 0;
                                }

                            },
                            data:
                            {
                                searchOpt0: $("#searchOpt0").val(),
                                searchOpt1: $("#searchOpt1").val(),
                                searchOpt2: $("#searchOpt2").val(),
                                searchOpt3: $("#searchOpt3").val(),
                                searchOpt11: $("#searchOpt11").val(),
                                searchOpt12: $("#searchOpt12").val(),
                                searchOpt13: $("#searchOpt13").val(),
                                searchOpt14: $("#searchOpt14").val(),
                                searchOpt5: $("#searchOpt5").val(),
                                searchOpt6: $("#searchOpt6").val(),
                                searchOpt7: $("#searchOpt7").val(),
                                searchOpt8: $("#searchOpt8").val(),
                                searchOpt9: $("#searchOpt9").val(),
                                searchOpt10: $("#searchOpt10").val(),
                                excel: 'N',
                            },
                            id: 'id',
                            url: url
                        };

                        $("#grdMain").on("bindingcomplete", function (event) { });

                        var dataAdapter = new $.jqx.dataAdapter(source);


                        $("#grdMain").jqxGrid(
                            {
                                source: dataAdapter,
                                columnsresize: true,
                                width: '100%',
                                height: '760px',
                                virtualmode: true,
                                rendergridrows: function (obj) {
                                    return obj.data;
                                },

                            });


                    }); //$('#btnSearch').on('click'

                    $("#btnSearch").trigger("click");

                });


                function fnCallbackMember(data) {
                    $("#searchOpt6").val(data.username);
                    $("#searchOpt7").val(data.loginid);
                }

                function detail_view(inx) {
                    if (inx == "0") {
                        //window.open('lucky', '_self');
                        moveWindowWithPost('visit1Edit', {});
                    } else if (inx == "9") {
                        var selectedrowindex = $("#grdMain").jqxGrid('getselectedrowindex');
                        var datarow = $("#grdMain").jqxGrid('getrowdata', selectedrowindex);
                        if (datarow.DocType == "0")
                            moveWindowWithPost('visit1Edit'
                                , {
                                    docCode: datarow.DocCode,
                                    ino: datarow.Ino
                                }
                            );
                        else
                            moveWindowWithPost('visit1View', { DocCode: datarow.DocCode });
                    }
                }

                function fnExcel() {
                    isExcelVisit1 = true;
                    //var rows = $('#grdMain').jqxGrid('getrows');
                    if (cntGridVisit1 > 10000) {
                    	swalAlert('조회 건수가 10000 이상입니다. \n조회 조건을 확인해 주십시오.','info');
                        return;
                    }
                    var url = "/visit1Search";
                    var source =
                    {
                        datatype: "json",
                        datafields: [
                            { name: 'Ino', type: 'string' },
                            { name: 'Idx', type: 'string' },
                            { name: 'DocCode', type: 'string' },
                            { name: 'WriteName', type: 'string' },
                            { name: 'ReqName', type: 'string' },
                            { name: 'AppDate', type: 'string' },
                            { name: 'ReqDate', type: 'string' },
                            { name: 'ValueSt3', type: 'string' },
                            { name: 'ValueSt5', type: 'string' },
                            { name: 'ValueSt6', type: 'string' },
                            { name: 'DocType', type: 'string' },
                            { name: 'DocTypeName', type: 'string' },
                            { name: 'ValueDate', type: 'string' },
                            { name: 'ValueSub1', type: 'string' },
                            { name: 'ValueSub2', type: 'string' },
                            { name: 'ValueSub3', type: 'string' },
                            { name: 'ValueSub4', type: 'string' },
                            { name: 'ValueSub4', type: 'int' }
                        ],
                        type: "POST",
                        beforeprocessing: function (data) {
                            cntGridVisit1 = data[0].totalCount;
                            source.totalrecords = data[0].totalCount;
                        },
                        data:
                        {
                            searchOpt0: $("#searchOpt0").val(),
                            searchOpt1: $("#searchOpt1").val(),
                            searchOpt2: $("#searchOpt2").val(),
                            searchOpt3: $("#searchOpt3").val(),
                            searchOpt11: $("#searchOpt11").val(),
                            searchOpt12: $("#searchOpt12").val(),
                            searchOpt13: $("#searchOpt13").val(),
                            searchOpt14: $("#searchOpt14").val(),
                            searchOpt5: $("#searchOpt5").val(),
                            searchOpt6: $("#searchOpt6").val(),
                            searchOpt7: $("#searchOpt7").val(),
                            searchOpt8: $("#searchOpt8").val(),
                            searchOpt9: $("#searchOpt9").val(),
                            searchOpt10: $("#searchOpt10").val(),
                            excel: 'Y',
                        },
                        id: 'id',
                        url: url
                    };

                    $("#grdMain").on("bindingcomplete", function (event) {
                        if (isExcelVisit1) {
                            $("#grdMain").jqxGrid('exportdata', 'xlsx', '방문예약신청');
                        }
                    });

                    var dataAdapter = new $.jqx.dataAdapter(source);


                    $("#grdMain").jqxGrid(
                        {
                            source: dataAdapter,
                            columnsresize: true,
                            virtualmode: false,
                            width: '100%',
                            height: '760px',


                        });

                }

            </script>
        </head>

        <body>
            <div class="main-wrap">
                <div class="tit-wrap">
                    <h1>방문예약신청</h1>
                    <span class="ic_area">
                        <a id="menu_ico"><label class="ico"></label></a>
                    </span>
                </div>
                

                <div id='jqxWidget'>
                    <input type="hidden" id="hidExcel"></input>
                    <div class="scr-wrap">
                        <div class="scr-row">
                            <div class="scr-col-1">상세검색</div>
                            <div class="scr-col-5">
                                <div class="fl-line">
                                    <div id="searchOpt0"></div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <input type="text" id="searchOpt1" />
                                    </div>
                                </div>
                            </div>
                            <div class="scr-col-1">작성자구분</div>
                            <div class="scr-col-2">
                                <div id="searchOpt2"></div>
                            </div>

                            <div class="scr-col-1">결재상태</div>
                            <div class="scr-col-2">
                                <div id="searchOpt3"></div>
                            </div>
                        </div>
                        <div class="scr-row">
                            <div class="scr-col-1">접견자구분</div>
                            <div class="scr-col-2">
                                <div id="searchOpt11"></div>
                            </div>

                            <div class="scr-col-1">방문장소</div>
                            <div class="scr-col-2">
                                <div id="searchOpt12"></div>
                            </div>
                            <div class="scr-col-1">방문유형</div>
                            <div class="scr-col-2">
                                <div id="searchOpt13"></div>
                            </div>
                            <div class="scr-col-1">접견장소</div>
                            <div class="scr-col-2">
                                <div id="searchOpt14"></div>
                            </div>
                        </div>

                        <div class="scr-row">

                            <div class="scr-col-1">결재자구분</div>
                            <div class="scr-col-5">
                                <div class="fl-line">
                                    <div id="searchOpt5"></div>
                                    <div class="mr-3"></div>
                                    <input type="text" id="searchOpt6" readonly="readonly" />
                                    <input type="hidden" id="searchOpt7" value="" />
                                    <div class="mr-3"></div>
                                    <button class="btn-inner ic-search"
                                        onclick="javascript:fnEmpSearchPopup({'width':'1000', 'height':'600'}, fnCallbackMember)"></button>
                                </div>
                            </div>

                            <div class="scr-col-1">기간선택</div>
                            <div class="scr-col-5">
                                <div class="fl-line">
                                    <div>
                                        <div id="searchOpt8"></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <div id='searchOpt9'></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <button id="btnToday1" class="btn-inner todayButton"
                                            relDatePick="searchOpt9">오늘</button>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div class="mr-3">~</div>
                                    <div>
                                        <div id='searchOpt10'></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <button id="btnToday2" class="btn-inner todayButton"
                                            relDatePick="searchOpt10">오늘</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="btn-wrap-scr">

                            <button id="btnSearch" class="btn B">조회</button>
                            <button id="btnReset" class="btn B">초기화</button>
                        </div>

                    </div>
                    <div class="btn-wrap-act">
                        <button id="btnExcel" value="click" onclick="fnExcel()" class="btn">Excel</button>
                        <a href="javascript:detail_view('0')"><button class="btn">신규등록</button></a>
                    </div>

                    <div id="grdMain"></div>
                </div>
            </div>
        </body>

        </html>