<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Insert title here</title>

			<script>
				var cntGridVisit1 = 0;
				var isExcelVisit1 = false;

				$(function () {

					setCombo("searchOpt0", "visit4_opt0"); // 상세검색
					$("#searchOpt1").jqxInput({ minLength: 1 });
					setCombo("searchOpt2", "visit4_opt2");	//상태구분
					setCombo("searchOpt5", "visit4_opt5");  //기간선택
					$("#searchOpt5").jqxComboBox({ width: 100 });

					$("#searchOpt6").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
					$("#searchOpt7").jqxDateTimeInput({ formatString: 'yyyy-MM-dd', width: 100 });
					$("#searchOpt6").val("");
					$("#searchOpt7").val("");

					setTriggerSearch("searchOpt1");
					// prepare the data
					setGridVisitor();
					//     	$("#btnSearch").trigger("click");


				});


				function setGridVisitor() {
					var sourceVisitor =
					{
						datatype: "json",
						datafields: [
							{ name: 'ino', type: 'string' },
							{ name: 'blockCode', type: 'string' },
							{ name: 'blockName', type: 'string' },
							{ name: 'blockCompname', type: 'string' },
							{ name: 'blockGrdname', type: 'string' },
							{ name: 'blockTel', type: 'string' },
							{ name: 'carInfo', type: 'string' },
							{ name: 'blockDate', type: 'string' },
							{ name: 'status', type: 'string' },

						],
						type: "POST",
						beforeprocessing: function (data) {
							if (data.length > 0) {
								cntGridVisit1 = data[0].totalCount;
								sourceVisitor.totalrecords = data[0].totalCount;
							} else {
								cntGridVisit1 = 0;
								sourceVisitor.totalrecords = 0;
							}
						},
						data:
						{
							searchOpt0: $("#searchOpt0").val(),
							searchOpt1: $("#searchOpt1").val(),
							searchOpt2: $("#searchOpt2").val(),
							searchOpt5: $("#searchOpt5").val(),
							searchOpt6: $("#searchOpt6").val(),
							searchOpt7: $("#searchOpt7").val(),
							excel: 'N',
						},
						id: 'id',
						url: "/visit4Search"
					};

					$("#grdMain").on("bindingcomplete", function (event) {
						var localObjVisitor = {};
						localObjVisitor.emptydatastring = "등록된 내방객정보가 없습니다.";

						$("#grdMain").jqxGrid('localizestrings', localObjVisitor);

					});
					var daVisitor = new $.jqx.dataAdapter(sourceVisitor);

					var cellsrenderer1 = function (row, columnfield, value, defaulthtml, columnproperties) {
						return '<div class="grid-cell-link"><a href="javascript:detail_view(9)" >' + value + '</a></div>';
					};

					$("#grdMain").jqxGrid(
						{
							columnsresize: true,
							width: '100%',
							height: '720px',
							pageable: true,
							pagesize: 20,
							pagesizeoptions: ['5', '10', '15', '20', '30', '50', '100', '300', '500', 'Total'],
							virtualmode: true,
							source: daVisitor,
							rendergridrows: function (obj) {
								return obj.data;
							},

							columns: [
								{ text: '출입불가자 번호', datafield: 'blockCode', align: 'center', cellsalign: 'center', width: 180, cellsrenderer: cellsrenderer1 },
								{ text: '출입불가자명', datafield: 'blockName', align: 'center', cellsalign: 'center', width: 150 },
								{ text: '회사명', datafield: 'blockCompname', align: 'center', cellsalign: 'left', width: 200 },
								{ text: '직책명', datafield: 'blockGrdname', align: 'center', cellsalign: 'center', width: 70 },
								{ text: '연락처', datafield: 'blockTel', align: 'center', cellsalign: 'center', width: 150 },
								{ text: '차량번호', datafield: 'carInfo', align: 'center', cellsalign: 'center', width: 150 },
								{ text: '최근조회일', datafield: 'blockDate', align: 'center', cellsalign: 'center' },
							]

						});

					$('#btnSearch').on('click', function () {
						sourceVisitor.data = {
							searchOpt0: $("#searchOpt0").val(),
							searchOpt1: $("#searchOpt1").val(),
							searchOpt2: $("#searchOpt2").val(),
							searchOpt5: $("#searchOpt5").val(),
							searchOpt6: $("#searchOpt6").val(),
							searchOpt7: $("#searchOpt7").val(),
							excel: 'N',

						};
						daVisitor = new $.jqx.dataAdapter(sourceVisitor);
						$("#grdMain").jqxGrid({ source: daVisitor });
					});

				}

				function detail_view(inx) {
					if (inx == "0") {
						//window.open('lucky', '_self');
						moveWindowWithPost('visit4Edit', {});
					} else if (inx == "9") {
						var selectedrowindex = $("#grdMain").jqxGrid('getselectedrowindex');
						var datarow = $("#grdMain").jqxGrid('getrowdata', selectedrowindex);
						moveWindowWithPost('visit4Edit'
							, {
								blockCode: datarow.blockCode,
								ino: datarow.Ino
							}
						);
					}
				}




				function fnSearch() {
					setGridVisitor();
				}

				function fnReset() {
					$("#searchOpt0").jqxComboBox({selectedIndex: 0});
					$("#searchOpt1").val("");
					$("#searchOpt2").jqxComboBox({selectedIndex: 0});
					$("#searchOpt5").jqxComboBox({selectedIndex: 0});
					$("#searchOpt6").val("");
					$("#searchOpt7").val("");
				}

				function fnExcel() {
					isExcelVisit1 = true;
					//var rows = $('#grdMain').jqxGrid('getrows');
					if (cntGridVisit1 > 10000) {
						alert('조회 건수가 10000 이상입니다. \n조회 조건을 확인해 주십시오.');
						return;
					}

					var sourceVisitor =
					{
						datatype: "json",
						datafields: [
							{ name: 'ino', type: 'string' },
							{ name: 'blockCode', type: 'string' },
							{ name: 'blockName', type: 'string' },
							{ name: 'blockCompname', type: 'string' },
							{ name: 'blockGrdname', type: 'string' },
							{ name: 'blockTel', type: 'string' },
							{ name: 'carInfo', type: 'string' },
							{ name: 'blockDate', type: 'string' },
							{ name: 'status', type: 'string' },

						],
						type: "POST",
						beforeprocessing: function (data) {
							if (data.length > 0) {
								cntGridVisit1 = data[0].totalCount;
								sourceVisitor.totalrecords = data[0].totalCount;
							} else {
								cntGridVisit1 = 0;
								sourceVisitor.totalrecords = 0;
							}
						},
						data:
						{
							searchOpt0: $("#searchOpt0").val(),
							searchOpt1: $("#searchOpt1").val(),
							searchOpt2: $("#searchOpt2").val(),
							searchOpt5: $("#searchOpt5").val(),
							searchOpt6: $("#searchOpt6").val(),
							searchOpt7: $("#searchOpt7").val(),
							excel: 'Y',
						},
						id: 'id',
						url: "/visit4Search"
					};

					$("#grdMain").on("bindingcomplete", function (event) {
						if (isExcelVisit1) {
							$("#grdMain").jqxGrid('exportdata', 'xlsx', '출입불가정보관리');
						}
					});

					var dataAdapter = new $.jqx.dataAdapter(sourceVisitor);

					$("#grdMain").jqxGrid(
						{
							source: dataAdapter,
							columnsresize: true,
							virtualmode: false,
							width: '100%',
							height: '720px',


						});

				}

			</script>
		</head>

		<body>
			<div class="main-wrap">
				<div class="tit-wrap">
					<h1>출입불가자 정보 관리</h1>
					<span class="ic_area">
						<label class="ico" for="modal-1"></label>
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
							<div class="scr-col-1">상태구분</div>
							<div class="scr-col-2">
								<div id="searchOpt2"></div>
							</div>

						</div>

						<div class="scr-row">

							<div class="scr-col-1">기간선택</div>
							<div class="scr-col-5">
								<div class="fl-line">
									<div>
										<div id="searchOpt5"></div>
									</div>
									<div class="mr-3"></div>
									<div>
										<div id='searchOpt6'></div>
									</div>
									<div class="mr-3"></div>
									<div>
										<button id="btnToday1" class="btn-inner todayButton"
											relDatePick="searchOpt6">오늘</button>
									</div>
									<div class="mr-3"></div>
									<div class="mr-3">~</div>
									<div>
										<div id='searchOpt7'></div>
									</div>
									<div class="mr-3"></div>
									<div>
										<button id="btnToday2" class="btn-inner todayButton"
											relDatePick="searchOpt7">오늘</button>
									</div>
								</div>
							</div>
						</div>

						<div class="btn-wrap-scr">

							<button id="btnSearch" class="btn B">조회</button>
							<button id="btnReset" class="btn B" onclick="fnReset()">초기화</button>
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