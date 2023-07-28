	<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<link rel="stylesheet" type="text/css" href="../css/defalt.css" />
			<title>Insert title here</title>

			<%-- <jsp:include page="base.jsp" flush="false" /> --%>

			<script>

				$(function () {


					//debugger; //if('<c:out value="${indata.docType}"/>' == '2'
					if ('<c:out value="${indata.docType}"/>' == '2'
						|| ('<c:out value="${indata.docType}"/>' == '1' && '<c:out value="${indata.ssoStatus}"/>' == '2')
					) {

						$.post("/frm_visit2_visitor_list"
							, {
								docCode: '<c:out value="${indata.docCode}"/>',
								rnx: "0",
								valueDate2 : '<c:out value="${indata.valueDate2}"/>',
							}
							, function (data) {
								$("#frm_visit2_visitor_list").html(data);//
							}
						);

						$.post("/frm_visit2_goods_list"
							, {
								docCode: '<c:out value="${indata.docCode}"/>',
								valueOpt2: '<c:out value="${indata.valueOpt2}"/>',
								rnx: "0"
							}
							, function (data) {
								$("#frm_visit2_goods_list").html(data);//
							}
						);

						$("#divTitle4grdVisitor").hide();//결재 끝난거는 기본 정보에 내방객 리스트 안보이게 함
						$("#spanItem").hide();

					} else {//결재 끝난거는 기본 정보에 내방객 리스트 안보이게 함
						setGridVisitor();

						if ('<c:out value="${indata.valueOpt2}"/>' == '1') {
							setGridItem();
						} else {
							$("#spanItem").hide();
						}
					}

				});

				function printDiv() {

					fnScreenPrint(document.body.innerHTML);
				}

			</script>

			<script>
				function app_process(gubun) {
					// debugger;
					if (gubun == 1) {
						$.ajax({
							type: "POST",
							//url: "/approvalSubmit",
							url: "saveSignDocument",
							dataType: "text",
							data: {
								docCode: '<c:out value="${indata.docCode}"/>',
								inhtml: $('#divApproval').html()
							},
							success: (retdata) => {
								// debugger;
								var data = { docCode: retdata, menuCode: '010101', subCode: '<c:out value="${indata.valueSt8}"/>' }
								fnApprovalPopup(data, fnCallbackApproval);


							},
							error: (request, status, error) => {
								alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
							}
						});

						// 		data =  {
						//     				docCode : '<c:out value="${indata.docCode}"/>' ,
						//     				menuCode : '010101' ,
						//     			}
					}

					if (gubun == 2) {
						//ASIS 는 include_app_script.asp 에서 결재선을 저장해서 report2_process submit 해서 app_data2 에 데이타를 넣는다.
						//난 이해 안감. 그냥 doc_type = "2", sso_status = "2" 만 하자.

						$.ajax({
							type: "POST",
							url: "updateTBDocu4reg",
							dataType: "text",
							data: {
								docCode: '<c:out value="${indata.docCode}"/>'
							},
							success: (retdata) => {
								moveWindowWithPost('visit1');

							},
							error: (request, status, error) => {
								alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
							}
						});
					}

				}

				function fnCallbackApproval(data) {
					moveWindowWithPost('visit1');
// 					if('13'=='<c:out value="${indata.valueSt8}"/>' ){ /* 방문장소가 평택 */

// 			    		$.ajax({
// 			                type: "POST",
// 			                url: "saveParking13",
// 			                dataType : "text",
// 			                data: { docCode: '<c:out value="${indata.docCode}"/>'
// 			                	},
// 			                success: (retdata) => {
			                	
// 			                	fnSendVisit1Mesage();
// 			                },
// 			                error : (request, status, error) => {
// 			                	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
// 			            	}
// 			            });

// 			    	} else {
			    		
// 			    		fnSendVisit1Mesage();
// 			    	}
				}
				
				function fnSendVisit1Mesage(){
					$.ajax({
		                type: "POST",
		                url: "sendVisit1Mesage",
		                dataType : "text",
		                data: { docCode: '<c:out value="${indata.docCode}"/>'
		                	},
		                success: (retdata) => {
		                	moveWindowWithPost('visit1');
		                },
		                error : (request, status, error) => {
		                	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
		            	}
		            });
				}
				
			</script>

			<script>
				function setGridVisitor() {
					var sourceVisitor =
					{
						datatype: "json",
						datafields: [
							{ name: 'docCode', type: 'string' },
							{ name: 'valueSt1', type: 'string' },
							{ name: 'valueSt2', type: 'string' },
							{ name: 'valueSt3', type: 'string' },
							{ name: 'valueSt4', type: 'string' },
							{ name: 'carInfo', type: 'string' },
							{ name: 'valueSt9', type: 'string' },
							{ name: 'valueSt10', type: 'string' },

						],
						type: "POST",

						data:
						{
							doc_code: '<c:out value="${indata.docCode}"/>',
						},
						id: 'id',
						url: "/visit1View_visitor"
					};

					$("#grdVisitor").on("bindingcomplete", function (event) {
						var localObjVisitor = {};
						localObjVisitor.emptydatastring = "등록된 내방객정보가 없습니다.";

						$("#grdVisitor").jqxGrid('localizestrings', localObjVisitor);

					});
					var daVisitor = new $.jqx.dataAdapter(sourceVisitor);

					$("#grdVisitor").jqxGrid(
						{
							columnsresize: true,
							width: '100%',
							source: daVisitor,
							autoheight: true,

							columns: [
								{ text: '성명', datafield: 'valueSt1', align: 'center', width: 100 },
								{ text: '회사명', datafield: 'valueSt2', align: 'center', width: 150 },
								{ text: '직책', datafield: 'valueSt3', align: 'center', width: 150 },
								{ text: '연락처', datafield: 'valueSt4', align: 'center', width: 150 },
								{ text: '차량번호', datafield: 'carInfo', align: 'center', width: 150 },
								{ text: '차량종류', datafield: 'valueSt9', align: 'center', width: 100 },
								{ text: '차량모델', datafield: 'valueSt10', align: 'center', }
							]

						});



				}
			</script>

			<script>
				function setGridItem() {
					var sourceItem =
					{
						datatype: "json",
						datafields: [
							{ name: 'valueSt1', type: 'string' },
							{ name: 'valueSt2', type: 'string' },
							{ name: 'valueSt3', type: 'string' },
							{ name: 'valueSt4', type: 'string' },
							{ name: 'valueSt5', type: 'string' },
							{ name: 'valueSt6', type: 'string' },

						],
						type: "POST",

						data:
						{
							doc_code: '<c:out value="${indata.docCode}"/>',
						},
						id: 'id',
						url: "/visit1View_item"
					};

					$("#grdItem").on("bindingcomplete", function (event) {
						var localObjItem = {};
						localObjItem.emptydatastring = "등록된 반입물품정보가 없습니다.";

						$("#grdItem").jqxGrid('localizestrings', localObjItem);
					});
					var daItem = new $.jqx.dataAdapter(sourceItem);

					$("#grdItem").jqxGrid(
						{
							columnsresize: true,
							width: '100%',
							source: daItem,
							autoheight: true,
							columns: [
								{ text: '품명', datafield: 'valueSt1', align: 'center', width: 100 },
								{ text: '모델명(규격)', datafield: 'valueSt2', align: 'center', width: 250 },
								{ text: '제조번호(S/N)', datafield: 'valueSt3', align: 'center', },
								{ text: '단위', datafield: 'valueSt5', align: 'center', width: 100 },
								{ text: '비고', datafield: 'valueSt6', align: 'center', width: 100 }
							]
						});


				}
			</script>

			<script>

				function move_edit() {
					data = {
						ino: '<c:out value="${indata.ino}"/>',
						docCode: '<c:out value="${indata.docCode}"/>'
					}
					moveWindowWithPost('visit1Edit', data)
				}

				function delVisit1View() {
					
					swal({
			            title: '방문예약 신청 삭제',
			            text: "방문예약신청을 삭제하시겠습니까?",
			            icon: 'warning',
			            showCancelButton: true,
			            confirmButtonColor: '#3085d6',
			            cancelButtonColor: '#d33',
			            confirmButtonText: '삭제',
			            cancelButtonText: '취소'
			    	 }).then((result) => {
			             if (result.value) {
			            	 $.ajax({
									type: "POST",
									url: "/deleteVisit1View",
									dataType: "json",
									data:
									{
										doc_code: '<c:out value="${indata.docCode}"/>',
										ino: '<c:out value="${indata.ino}"/>'
									},
									success: (data) => {
										moveWindowWithPost('visit1');
									},
									error: (request, status, error) => {
										alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
									}
								});
			             }
			    	 });
					
					
				}

				function reuseVisit1View() {
					
					swal({
			            title: '방문예약 신청 재사용',
			            text: "방문예약신청을 재사용하시겠습니까?",
			            icon: 'warning',
			            showCancelButton: true,
			            confirmButtonColor: '#3085d6',
			            cancelButtonColor: '#d33',
			            confirmButtonText: '확인',
			            cancelButtonText: '취소'
			    	 }).then((result) => {
			             if (result.value) {
			            	 $.ajax({
									type: "POST",
									url: "/reuseVisit1View",
									dataType: "text",
									data:
									{
										old_doc_code: '<c:out value="${indata.docCode}"/>'
									},
									success: (data) => {
										moveWindowWithPost('visit1Edit', { docCode: data })
									},
									error: (request, status, error) => {
										alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
									}
								});
			             }
			    	 });
					
					
					

				}

				function command_process(k) {
					
				}
			</script>

		</head>

		<body>
			<!-- 본문영역 start -->
			<div class="main-wrap">
				<div class="tit-wrap">
					<h1>방문예약신청</h1>
					<span class="ic_area2"></span>
					<div class="btn-wrap-act">
						<c:choose>
							<c:when test="${indata.docType eq '0'}">
								<button class="btn" id="btnDelete" value="click" onclick="delVisit1View()">삭제</button>
								<button class="btn" id="btnEdit" value="click" onclick="move_edit()">편집</button>
								<c:if test="${submit_type eq '1'}">
									<button class="btn" id="btnApproval" value="click" onclick="app_process(1)">결재
										상신</button>
								</c:if>
								<c:if test="${submit_type eq '2'}">
									<button class="btn" id="btnRegister" value="click"
										onclick="app_process(2)">등록</button>
								</c:if>
							</c:when>
							<c:otherwise>
								<c:if test="${indata.docType eq '1'}">
									<button class="btn" id="btnApproval" value="click" onclick="app_process(1)">결재
										확인</button>
								</c:if>
								<button class="btn" id="btnReinsert" value="click"
									onclick="reuseVisit1View()">재사용신청</button>
								<!-- 처리완료 버튼 필요함. move_process(51) -->

							</c:otherwise>
						</c:choose>


						<button class="btn" id="btnList" value="click"
							onclick="moveWindowWithPost('visit1')">리스트</button>

					</div>
				</div>

				<div class="stit-wrap approval-wrap-title mgt0">
					<h3>결재상태</h3>
				</div>
				<div class="view-wrap approval-wrap mgb8">
					<div class="v-row">
						<div class="v-col-1">결재상태</div>
						<div class="v-col-11">
							<span class="approval-lable">${docTypeName}</span>
						</div>
					</div>
				</div>
				<!-- <div>
					<div class="stit-wrap">
						<h3>결재상태</h3>
					</div>
				</div>

				<div class="view-wrap mgb8">
					<div class="v-row">
						<div class="v-col-1">결재상태</div>
						<div class="v-col-11">
							${docTypeName}
						</div>
					</div>
				</div> -->

				<!-- 타이틀영역 start -->
				<!-- <div class="stit-wrap">
					<h3>기본정보</h3>
				</div> -->
				<!-- 타이틀영역 end -->
				<!-- 기본정보영역 table start -->
				<div id="divApproval" class="">

					<div class="stit-wrap">
						<h3>작성자정보</h3>
					</div>

					<jsp:include page="include/include_app_writer.jsp" flush="false">
						<jsp:param name="id" value="${indata.writeId}" />
						<jsp:param name="name" value="${indata.writeName}" />
						<jsp:param name="dept" value="${indata.writeDeptname}" />
						<jsp:param name="telephone" value="${indata.writeComptel}" />
						<jsp:param name="mobilephone" value="${indata.writeMobile}" />
					</jsp:include>

					<div class="stit-wrap">
						<h3>기본정보</h3>
					</div>
					<div>



						<!-- 문서정보 기본정보 테이블 -->
						<div class="view-wrap">
							<div class="v-row">
								<div class="v-col-1">문서번호</div>
								<div class="v-col-7">
									${indata.docCode}
								</div>
								<div class="v-col-1">접견자</div>
								<div class="v-col-3">
									<span>${indata.reqTypeName} </span>
									<div class="mr-3"></div>
									${indata.reqName}
								</div>
							</div>
							<div class="v-row">
								<div class="v-col-1">부서명</div>
								<div class="v-col-3">
									${indata.reqDeptname}
								</div>
								<div class="v-col-1">전화번호</div>
								<div class="v-col-3">
									${indata.reqComptel}
								</div>

								<div class="v-col-1">핸드폰</div>
								<div class="v-col-3">
									${indata.reqMobile}
								</div>
							</div>
							<div class="v-row">
								<div class="v-col-1">방문기간</div>
								<div class="v-col-11">
									<span>${indata.valueDate1} ${indata.valueSt1}</span>
									~
									<span>${indata.valueDate2} ${indata.valueSt2}</span>
								</div>
							</div>
							<div class="v-row">
								<div class="v-col-1">차량여부</div>
								<div class="v-col-3">
									${indata.valueOpt1 eq "1" ? "있음" : "없음"}
								</div>
								<div class="v-col-1">방문유형</div>
								<div class="v-col-3">
									${indata.valueSt3}
								</div>
								<div class="v-col-1">SMS 발송여부</div>
								<div class="v-col-3">
									${indata.valueOpt3 eq "Y" ? "Y" : "N"}
								</div>
							</div>
							<div class="v-row">
								<div class="v-col-1">방문목적</div>
								<div class="v-col-3">
									${indata.valueSt4}
								</div>
								<div class="v-col-1">방문상세목적</div>
								<div class="v-col-7">
									${indata.valueLt1}
								</div>
							</div>
							<div class="v-row">
								<div class="v-col-1">반입물품</div>
								<div class="v-col-3">
									${indata.valueOpt2 eq "1" ? "있음" : "없음"}
								</div>
								<div class="v-col-1">방문장소</div>
								<div class="v-col-3">
									${indata.valueSt5}
								</div>

								<div class="v-col-1">접견장소</div>
								<div class="v-col-3">
									${indata.valueSt6}
								</div>
							</div>
						</div>
					</div>

					<div class="stit-wrap" id="divTitle4grdVisitor">
						<h3>내방객정보</h3>
					</div>
					<div id="grdVisitor">

					</div>

					<div id="spanItem" class="stit-wrap">
						<h3>반입물품</h3>
					</div>

					<div id="grdItem"></div>

					<div class="tbB">
						<table summary="기본정보">
							<caption>기본정보</caption>
						</table>
					</div>


					<!-- 기본정보영역 table end -->

					<c:if test="${not empty indata.valueLt7 && not empty indata.valueOpt3}">

						<div class="tbB">
							<table>
								<colgroup>
									<col width="120px">
									<col width="">
									<col width="120px">
									<col width="">
								</colgroup>
								<tr>
									<th colspan="4"> test ${indata.valueLt7}</th>
								</tr>
								<tr>
									<th>발송방법</th>
									<td>${indata.valueLt9}</td>
									<th>발송주소</th>
									<td>${indata.valueLt8}</td>
								</tr>
								<tr>
									<th>발송여부</th>
									<td>
										<c:if test="${indata.valueOpt3 eq '0'}">
											발송대상
										</c:if>
										<c:if test="${indata.valueOpt3 eq '1'}">
											발송완료
										</c:if>
										<c:if test="${indata.valueOpt3 eq '2'}">
											발송실패
										</c:if>
									</td>

									<th>발송일시</th>
									<td>${indata.valueLt10}</td>
								</tr>
							</table>
						</div>
					</c:if>

					<div>
						<!-- include_app_msg.asp -->
						<c:choose>
							<c:when test="${not empty indata.delStatus}">
								<font color=darkred><b>이미 삭제된 문서입니다.</b></font>
							</c:when>
							<c:otherwise>
								<c:if test="${indata.docType eq '0'}">
									<b>임시저장 상태 입니다. 등록,상신 해 주시기 바랍니다.</b>
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>



				</div>

				<!-- 내방객정보 -->
				<div class="view-wrap">
					<div id="frm_visit2_visitor_list"></div>
					<!-- 아이템 정보 -->
					<div id="frm_visit2_goods_list"></div>
				</div>
			</div>
			<!-- 본문영역 end -->
			<!-- <div id="popApproval" style="display: none" > -->
			<!--  <div> -->
			<!--     결재 상세 -->
			<!--  </div> -->
			<!--   	 <div> -->
			<!-- 		<div class="view-wrap">  -->
			<!-- 			<div class="v-row"> -->
			<!-- 				<div class="v-col-2">검색 : </div> -->
			<!-- 				<div class="v-col-1"> -->
			<!-- 					<div id="cboPopVisit1SearchType"></div> -->
			<!-- 				</div> -->
			<!-- 				<div class="v-col-4"> -->
			<!-- 					<input type="text" id="txtPopVisitor" /> -->
			<!-- 				</div> -->
			<!-- 				<div class="v-col-1"> -->
			<!-- 					<button onclick="javascript:fnPopVisitorSearchQuery();">조회</button> -->
			<!-- 				</div> -->
			<!-- 				<div class="v-col-1"> -->
			<!-- 					<button onclick="javascript:fnPopVisitorSearchReset();">초기화</button> -->
			<!-- 				</div> -->
			<!-- 				<div class="v-col-3"> -->
			<!-- 				</div> -->
			<!-- 			</div> -->
			<!-- 		</div> -->

			<!-- 	</div> -->
			<!-- </div> -->
		</body>

		</html>