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

			$.post("/frm_visit2_visitor_list"
				, {
					docCode: '<c:out value="${indata.docCode}"/>',
					rnx: "1",
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
					rnx: "1"
				}
				, function (data) {
					$("#frm_visit2_goods_list").html(data);//
				}
			);

		});



	</script>





</head>

<body>
	<div id="divApproval" class="main-wrap">
		<div class="tit-wrap">
			<h1>방문예약관리</h1>
			<div class="btn-wrap-act">
				<button class="btn" id="btnList" value="click"
					onclick="moveWindowWithPost('visit2')">리스트</button>
			</div>
		</div>
		<!-- 기본정보영역 table start -->


			<div class="stit-wrap mgt0">
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
				<h3>문서정보</h3>
			</div>
			<div>



				<!-- 문서정보 기본정보 테이블 -->
				<div class="view-wrap">
					<div class="v-row">
						<div class="v-col-1">문서번호</div>
						<div class="v-col-3">
							${indata.docCode}
						</div>
						<div class="v-col-1">결재상태</div>
						<div class="v-col-3">
							${indata.appTypeName}
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
						<div class="v-col-7">
							${indata.valueSt3}
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
		<!-- 내방객정보 -->
		<div class="view-wrap">
			<div id="frm_visit2_visitor_list"></div>
			<!-- 아이템 정보 -->
			<div class="mgb15"></div>
			<div id="frm_visit2_goods_list"></div>
		</div>
		</div>




</body>

</html>