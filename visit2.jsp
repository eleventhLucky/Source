<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>

    <%-- <jsp:include page="base.jsp" flush="false" /> --%>

    <script>
        var cntGridVisit2 = 0;
        var isExcelVisit2 = false;
        var source = {};

        var cellsrenderer1 = function (row, columnfield, value, defaulthtml, columnproperties) {
            return '<div class="grid-cell-link"><a href="javascript:detail_view(9)" >' + value + '</a></div>';
        };
        
        $(function () {

            setCombo("searchOpt0", "visit2_opt0"); // 상세검색
            $("#searchOpt1").jqxInput({ minLength: 1 });
            setCombo("searchOpt2", "s1013", "cateCombo", "cateName", "cateName");  //방문장소
            setCombo("searchOpt3", "visit2_opt3");	// 방문여부
            setCombo("searchOpt5", "s1011", "cateCombo", "cateName", "cateName");  //방문유형
            setCombo("searchOpt6", "s1014", "cateCombo", "cateName", "cateName");  //접견장소
            
            setCombo("searchOpt7", "visit2_opt7"); //내방예약기간
            $("#searchOpt8").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
            $("#searchOpt9").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
            $("#searchOpt8").val('');
            $("#searchOpt9").val('');
            
            setTriggerSearch("searchOpt1");
            setGridMain();

        });
		</script>
		
		<script>
		function setGridMain() {

			var url = "/visit2Search";
			// prepare the data
			source =
			{
				datatype: "json",
				datafields: [
					{ name: 'ino', type: 'string' },
					{ name: 'seq', type: 'string' },
					{ name: 'docCode', type: 'string' }, 	// 문서번호
					{ name: 'docType', type: 'string' },
					{ name: 'writeName', type: 'string' }, 	// 작성자
					{ name: 'reqName', type: 'string' },	// 접견자
					{ name: 'valueLt2', type: 'string' }, 	// 방문장소
					{ name: 'valueLt3', type: 'string' }, 	// 방문유형
					{ name: 'etc2', type: 'string' }, 		// 내방예약기간
					{ name: 'valueSt1', type: 'string' }, 	// 내방객
					{ name: 'carInfo', type: 'string' }, 	// 내방차량
					{ name: 'etc1', type: 'string' }, 		// 내방여부
					{ name: 'reqDate10', type: 'string' }, 	// 신청일
					{ name: 'valueLt4', type: 'string' },  	// 접견장소
					{ name: 'valueSt2', type: 'string' },   // 업체명
					{ name: 'valueLt5', type: 'string' },  	// 반입물품
					{ name: 'valueDate3', type: 'string' },  // 실내방일

				],
				type: "POST",
				beforeprocessing: function (data) {

					if (data.length > 0) {
						cntGridMeal = data[0].totalCount;
						source.totalrecords = data[0].totalCount;
					} else {
						cntGridMeal = 0;
						source.totalrecords = 0;
					}
				},
				data:
				{
					SEARCHK0: $("#searchOpt0").val(),
                    SEARCHK1: $("#searchOpt1").val(),
                    SEARCHK2: $("#searchOpt2").val(),
                    SEARCHK3: $("#searchOpt3").val(),
                    SEARCHK5: $("#searchOpt5").val(),
                    SEARCHK6: $("#searchOpt6").val(),
                    SEARCHK7: $("#searchOpt7").val(),
                    SEARCHK8: $("#searchOpt8").jqxDateTimeInput('getText'),
                    SEARCHK9: $("#searchOpt9").jqxDateTimeInput('getText'),
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
					height: '720px',
					pageable: true,
					pagesize: 20,
					pagesizeoptions: ['5', '10', '15', '20', '30', '50', '100', '300', '500', 'Total'],
					virtualmode: true,
					rendergridrows: function (obj) {
						return obj.data;
					},

					columns: [
                        { text: '순번', datafield: 'seq', width: 50, align: 'center', cellsalign: 'center' },
                        { text: '문서번호', datafield: 'docCode', width: 150, align: 'center', cellsalign: 'center', cellsrenderer: cellsrenderer1 },
                        { text: '접견자', datafield: 'reqName', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '신청일', datafield: 'reqDate10', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '방문유형', datafield: 'valueLt3', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '방문장소', datafield: 'valueLt2', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '접견장소', datafield: 'valueLt4', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '내방예약기간', datafield: 'etc2', width: 200, align: 'center', cellsalign: 'center' },
                        { text: '내방객', datafield: 'valueSt1', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '업체명', datafield: 'valueSt2', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '내방차량', datafield: 'carInfo', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '반입물품', datafield: 'valueLt5', width: 150, align: 'center', cellsalign: 'center' },
                        { text: '내방여부', datafield: 'etc1', width: 80, align: 'center', cellsalign: 'center' },
                        { text: '실내방일', datafield: 'valueDate3', width: 150, align: 'center', cellsalign: 'center' },

                        
                        
                    ]

				});

			$('#btnSearch').on('click', function () {
				isExcelMeal = false;
				source.data = {
						SEARCHK0: $("#searchOpt0").val(),
                        SEARCHK1: $("#searchOpt1").val(),
                        SEARCHK2: $("#searchOpt2").val(),
                        SEARCHK3: $("#searchOpt3").val(),
                        SEARCHK5: $("#searchOpt5").val(),
                        SEARCHK6: $("#searchOpt6").val(),
                        SEARCHK7: $("#searchOpt7").val(),
                        SEARCHK8: $("#searchOpt8").jqxDateTimeInput('getText'),
                        SEARCHK9: $("#searchOpt9").jqxDateTimeInput('getText'),
                        excel: 'N',


				};
				dataAdapter = new $.jqx.dataAdapter(source);
				$("#grdMain").jqxGrid({ virtualmode: true, source: dataAdapter });
			});
			
			$('#btnReset').on('click', function () {
                $("#searchOpt0").jqxComboBox({selectedIndex: 0});
                $("#searchOpt1").val("");
                $("#searchOpt2").jqxComboBox({selectedIndex: 0});
                $("#searchOpt3").jqxComboBox({selectedIndex: 0});
                $("#searchOpt5").jqxComboBox({selectedIndex: 0});
                $("#searchOpt6").jqxComboBox({selectedIndex: 0});
                $("#searchOpt7").jqxComboBox({selectedIndex: 0});
                $("#searchOpt8").val('');
                $("#searchOpt9").val('');
                
            });

		}
		</script>
		
		
		<script>
        function detail_view(inx) {
            if (inx == "0") {
                
            } else if (inx == "9") {
                var selectedrowindex = $("#grdMain").jqxGrid('getselectedrowindex');
                var datarow = $("#grdMain").jqxGrid('getrowdata', selectedrowindex);
                moveWindowWithPost('visit2Edit'
                    , {
                        docCode: datarow.docCode,
                        ino: datarow.ino
                    }
                );
            }
        }
        </script>
        <script>
        function fnExcel() {
			isExcelMeal = true;
			//var rows = $('#grdMain').jqxGrid('getrows');
			if (cntGridMeal > 10000) {
				alert('조회 건수가 10000 이상입니다. \n조회 조건을 확인해 주십시오.');
				return;
			}

			source.data = {
					SEARCHK0: $("#searchOpt0").val(),
                    SEARCHK1: $("#searchOpt1").val(),
                    SEARCHK2: $("#searchOpt2").val(),
                    SEARCHK3: $("#searchOpt3").val(),
                    SEARCHK5: $("#searchOpt5").val(),
                    SEARCHK6: $("#searchOpt6").val(),
                    SEARCHK7: $("#searchOpt7").val(),
                    SEARCHK8: $("#searchOpt8").jqxDateTimeInput('getText'),
                    SEARCHK9: $("#searchOpt9").jqxDateTimeInput('getText'),
					excel: 'Y',


			};
			var dataAdapter = new $.jqx.dataAdapter(source);
			$("#grdMain").jqxGrid({ virtualmode: false, source: dataAdapter });

			$("#grdMain").on("bindingcomplete", function (event) {
				if (isExcelMeal) {
					$("#grdMain").jqxGrid('exportdata', 'xlsx', '방문예약관리');
				}
			});


		}

    </script>
</head>

        <body>
            <div class="main-wrap">
                <div class="tit-wrap">
                    <h1>방문예약관리</h1>
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
                            <div class="scr-col-1">기간선택</div>
                            <div class="scr-col-5">
                                <div class="fl-line">
                                    <div>
                                        <div id="searchOpt7"></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <div id='searchOpt8'></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <button id="btnToday1" class="btn-inner todayButton"
                                            relDatePick="searchOpt8">오늘</button>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div class="mr-3">~</div>
                                    <div>
                                        <div id='searchOpt9'></div>
                                    </div>
                                    <div class="mr-3"></div>
                                    <div>
                                        <button id="btnToday2" class="btn-inner todayButton"
                                            relDatePick="searchOpt9">오늘</button>
                                    </div>
                                </div>
                            </div>

                            
                        </div>
                        <div class="scr-row">
                            <div class="scr-col-1">방문여부</div>
                            <div class="scr-col-2">
                                <div id="searchOpt3"></div>
                            </div>

                            <div class="scr-col-1">방문장소</div>
                            <div class="scr-col-2">
                                <div id="searchOpt2"></div>
                            </div>
                            <div class="scr-col-1">방문유형</div>
                            <div class="scr-col-2">
                                <div id="searchOpt5"></div>
                            </div>
                            <div class="scr-col-1">접견장소</div>
                            <div class="scr-col-2">
                                <div id="searchOpt6"></div>
                            </div>
                        </div>

                        <div class="btn-wrap-scr">

                            <button id="btnSearch" class="btn B">조회</button>
                            <button id="btnReset" class="btn B">초기화</button>
                        </div>

                    </div>
                    <div class="btn-wrap-act">
                        <button id="btnExcel" value="click" onclick="fnExcel()" class="btn">Excel</button>
                    </div>

                    <div id="grdMain"></div>
                </div>
            </div>
        </body>

        </html>