<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../css/defalt.css" />
<title>Insert title here</title>

<%-- <jsp:include page="base.jsp" flush="false"/> --%>

   	<script>

   	var dVisit3Edit;

    $(function(){



    	var javaList = '${indata}'; //jstl로 받아서 변수 지정
    	var data = fn_javaList2Json(javaList);
    	if(data.length > 0) dVisit3Edit = data[0];

    	setCombo("cboStatus", "visit4_opt2", "", "", "", "", "S");
    	<c:if test="${not empty indata.status}">
			$('#cboStatus').val('<c:out value="${indata.status}"/>');
		</c:if>

    	$("#dtpVisitDate").jqxDateTimeInput({ formatString: 'yyyy-MM-dd hh:mm:ss' , width:155 ,disabled: true});
    	$("#dtpVisitDate").val('<c:out value="${indata.visitDate}"/>');

    	setCombo("cboCarNumber1", "s1017", "cateCombo", "cateName","cateName", "70", "S");
    	setCombo("cboCarType1", "s1015", "cateCombo", "cateName","cateName", "", "S");

    	<c:if test="${not empty indata.carNumber1}">
				$('#cboCarNumber1').val('<c:out value="${indata.carNumber1}"/>');
		</c:if>
		<c:if test="${not empty indata.carType1}">
			$('#cboCarType1').val('<c:out value="${indata.carType1}"/>');
		</c:if>


    	<c:if test="${not empty ino}">
	    	setGridVisitorLog();
	    	setGridVisitorSysLog();
	    	setGridDocuSub();
	    	setGridVisitorBlock();
    	</c:if>

    });

	function save_visit3Edit(cu){

 		fnGetIndata();
     	if(!validation_visit3Edit()) return;



    	$.ajax({
            type: "POST",
            url: "/visit3Edit_Save",
            dataType : "text",
            data:
        	{
            	ino : dVisit3Edit.ino,
            	status : dVisit3Edit.status,
            	visitorCode : dVisit3Edit.visitorCode,
            	visitorName : dVisit3Edit.visitorName,
            	visitorCompname : dVisit3Edit.visitorCompname,
            	visitorGrdname : dVisit3Edit.visitorGrdname,
            	visitorTel : dVisit3Edit.visitorTel,
            	carNumber1 : dVisit3Edit.carNumber1,
            	carNumber2 : dVisit3Edit.carNumber2,
            	carNumber3 : dVisit3Edit.carNumber3,
            	carNumber4 : dVisit3Edit.carNumber4,
            	carType1 : dVisit3Edit.carType1,
            	carType2 : dVisit3Edit.carType2,
            	visitDate : dVisit3Edit.visitDate,
            	visitorDeptname : dVisit3Edit.visitorDeptname,
            	visitorMail : dVisit3Edit.visitorMail,
            	visitorAddress : dVisit3Edit.visitorAddress,
        	},
            success: (data) => {
            	moveWindowWithPost('visit3');
            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });


    }

	function fnGetIndata(){
		dVisit3Edit.ino = '${indata.ino}'; //fn_javaList2Json 때문에 문자로 들어가서 다시 넣어줌.

		dVisit3Edit.status =  $('#cboStatus').val();
		dVisit3Edit.visitorName =  $('#txtVisitorName').val();
		dVisit3Edit.visitorCompname = $('#txtVisitorCompname').val();
		dVisit3Edit.visitorDeptname =  $('#txtVisitorDeptname').val();
		dVisit3Edit.visitorGrdname =  $('#txtVisitorGrdname').val();
		dVisit3Edit.visitorTel =  $('#txtVisitorTel').val().replace(/(^\s*)|(\s*$)/gi, "");
		dVisit3Edit.visitorMail =  $('#txtVisitorMail').val();
		dVisit3Edit.visitorAddress =  $('#txtVisitorAddress').val();
		dVisit3Edit.carNumber1 =  $('#cboCarNumber1').val();
		dVisit3Edit.carNumber2 =  $('#txtCarNumber2').val();
		dVisit3Edit.carNumber3 =  $('#txtCarNumber3').val();
		dVisit3Edit.carNumber4 =  $('#txtCarNumber4').val();
		dVisit3Edit.carType1 =  $('#cboCarType1').val();
		dVisit3Edit.carType2 =  $('#txtCarType2').val();
		dVisit3Edit.visitDate =  $('#dtpVisitDate').val();

	}


	function validation_visit3Edit(){

		if(isEmpty(dVisit3Edit.status)) {
    		alert('상태는 필수입니다.');
    		$('#cboStatus').focus();
    		return false;
    	}

    	if(isEmpty(dVisit3Edit.visitorName)) {
    		alert('내방객 성명은 필수입니다.');
    		$('#txtVisitorName').focus();
    		return false;
    	}


    	if(isEmpty(dVisit3Edit.visitorCompname)) {
    		alert('내방객 회사명은 필수입니다.');
    		$('#txtVisitorCompname').focus();
    		return false;
    	}


    	if(isEmpty(dVisit3Edit.visitorTel)) {
    		alert('내방객 연락처는 필수입니다.');
    		$('#txtVisitorTel').focus();
    		return false;
    	}
    	if(!isValidateTel(dVisit3Edit.visitorTel)) {
    		alert('내방객 연락처형식이 맞지 않습니다.\nex) 012-345-6789');
    		return false;
    	}

    	if(isEmpty(dVisit3Edit.visitorMail)==false) {
    		if(!isValidateEmail(dVisit3Edit.visitorMail)) {
    			alert('내방객 이메일형식이 맞지 않습니다.\nex) abc@def.com');
        		return false;
        	}

    	}

    	var visitorCarRegion = $('#cboCarNumber1').val();
    	var visitorCarNum1 = $('#txtCarNumber2').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarNum2 = $('#txtCarNumber3').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarNum3 = $('#txtCarNumber4').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarModel = $('#cboCarType1').val();
    	var visitorCarModelText = $('#txtCarType2').val().replace(/(^\s*)|(\s*$)/gi, "");

    	var carData = visitorCarRegion + visitorCarNum1 + visitorCarNum2 + visitorCarNum3 + visitorCarModel + visitorCarModelText;
    	if( !isEmpty(carData) ){

    		if(isEmpty(visitorCarRegion)  ) {
        		alert('차량정보 차량지역은 필수입니다.');
        		$('#cboCarNumber1').focus();
        		return false;
        	}

        	if (isValidateCar(visitorCarRegion,visitorCarNum1,visitorCarNum2,visitorCarNum3)==false) {
    			alert('차량번호 형식이 맞지 않습니다.\nex) 경기 12 가 3456');
    			return;
    		}

        	if(isEmpty(visitorCarModel) ) {
        		alert('차량모델 차종선택은 필수입니다.');
        		return false;
        	}

//         	if(isEmpty(visitorCarModelText)) {
//         		alert('차량모델명은 필수입니다.');
//         		$('#txtCarType2').focus();
//         		return false;
//         	}

    	}



    	return true;
    }


    function delete_visit3Edit(){
    	
		swal({
            title: '내방객정보를 삭제',
            text: "내방객정보를 삭제하시겠습니까?",
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
                     url: "/deleteVisit3View",
                     dataType : "text",
                     data:
                 	{
                     	visitorCode : '<c:out value="${indata.visitorCode}"/>',
                 	},
                     success: (data) => {
                     	moveWindowWithPost('visit3');
                     },
                     error : (request, status, error) => {
                     	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                 	}
                 });
             }
    	 });
		
    }


    </script>

	<script>
		function setGridVisitorLog(){
			var sourceLog =
	        {
	            datatype: "json",
	            datafields: [
	            	{ name: 'seq', type: 'string' },
	                { name: 'visitorCode', type: 'string' },
	                { name: 'visitorName', type: 'string' },
	                { name: 'visitorCompname', type: 'string' },
	                { name: 'visitorGrdname', type: 'string' },
	                { name: 'visitorTel', type: 'string' },
	                { name: 'carInfo', type: 'string' },
	                { name: 'visitDate', type: 'string' },
	                { name: 'status', type: 'string' },
	                { name: 'signYn', type: 'string' },

	            ],
	            type: "POST",

	            data:
	            	{
	            	visitorCode : '<c:out value="${indata.visitorCode}"/>',
	            	},
	            id: 'id',
	            url: "/visit3View_visitorLog"
	        };

	    	$("#grdVisitorLog").on("bindingcomplete", function (event) {
	    		var localObjVisitor = {};
		   	     localObjVisitor.emptydatastring = "수기 방문이력 정보가 없습니다.";

		   	   	 $("#grdVisitorLog").jqxGrid('localizestrings', localObjVisitor);

	    	});
	        var daLog = new $.jqx.dataAdapter(sourceLog);

	   	    $("#grdVisitorLog").jqxGrid(
	      	{
				columnsresize: true,
				width : '100%',
				source: daLog,
				autoheight: true,

				columns: [
					 { text: '순번'	, datafield: 'seq', align:'center', width: 50 , cellsalign:'center'},
					 { text: '내방객명'	, datafield: 'visitorName', align:'center',width: 150 , cellsalign:'center'},
					 { text: '회사명'	, datafield: 'visitorCompname', align:'center',width: 150 , cellsalign:'center'},
					 { text: '직책명'	, datafield: 'visitorGrdname', align:'center',width: 70 , cellsalign:'center'},
					 { text: '연락처'	, datafield: 'visitorTel', align:'center',width: 150 , cellsalign:'center'},
					 { text: '차량정보'	, datafield: 'carInfo', align:'center',width: 150 , cellsalign:'center'},
					 { text: '최근방문일', datafield: 'visitDate', align:'center',width: 150 , cellsalign:'center'},
					 { text: '접견자/사유'	, datafield: 'visitorAddress',align:'center', cellsalign:'left'  }
				]

			});
		}
	</script>
	<script>
		function setGridVisitorSysLog(){
			var sourceSysLog =
	        {
	            datatype: "json",
	            datafields: [
	            	{ name: 'seq', type: 'string' },
	                { name: 'valueSt1', type: 'string' },
	                { name: 'valueSt2', type: 'string' },
	                { name: 'valueSt3', type: 'string' },
	                { name: 'valueSt4', type: 'string' },
	                { name: 'valueSt5', type: 'string' },
	                { name: 'valueSt6', type: 'string' },
	                { name: 'valueSt7', type: 'string' },
	                { name: 'valueSt8', type: 'string' },
	                { name: 'valueLt7', type: 'string' },
	                { name: 'valueLt8', type: 'string' },
	                { name: 'carInfo', type: 'string' },
	                { name: 'valueDate3', type: 'string' },
	                { name: 'regName', type: 'string' },

	            ],
	            type: "POST",

	            data:
	            	{
	            	visitorCode : '<c:out value="${indata.visitorCode}"/>',
	            	},
	            id: 'id',
	            url: "/visit3View_visitorSysLog"
	        };

	    	$("#grdVisitorSysLog").on("bindingcomplete", function (event) {
	    		var localObjVisitor = {};
		   	     localObjVisitor.emptydatastring = "시스템 방문이력 정보가 없습니다.";

		   	   	 $("#grdVisitorSysLog").jqxGrid('localizestrings', localObjVisitor);

	    	});
	        var daSysLog = new $.jqx.dataAdapter(sourceSysLog);

	   	    $("#grdVisitorSysLog").jqxGrid(
	      	{
				columnsresize: true,
				width : '100%',
				source: daSysLog,
				autoheight: true,

				columns: [
					 { text: '순번'	, datafield: 'seq', align:'center', width: 50 , cellsalign:'center'},
					 { text: '내방객명'	, datafield: 'valueSt1', align:'center',width: 150 , cellsalign:'center'},
					 { text: '회사명'	, datafield: 'valueSt2', align:'center',width: 150 , cellsalign:'center'},
					 { text: '직책명'	, datafield: 'valueSt3', align:'center',width: 70 , cellsalign:'center'},
					 { text: '연락처'	, datafield: 'valueSt4', align:'center',width: 150 , cellsalign:'center'},
					 { text: '차량정보'	, datafield: 'carInfo', align:'center',width: 150 , cellsalign:'center'},
					 { text: '최근방문일', datafield: 'valueDate3', align:'center' , cellsalign:'center'},
					 { text: '표찰'	, datafield: 'valueLt8', align:'center', width: 70 , cellsalign:'center'},
					 { text: '접견자'	, datafield: 'regName',align:'center',width: 100, cellsalign:'left'  }
				]

			});
		}
	</script>
	<script>
		function setGridDocuSub(){
			var source =
	        {
	            datatype: "json",
	            datafields: [
	            	{ name: 'seq', type: 'string' },
	                { name: 'valueSt1', type: 'string' },
	                { name: 'valueSt2', type: 'string' },
	                { name: 'valueSt3', type: 'string' },
	                { name: 'valueSt4', type: 'string' },
	                { name: 'valueSt5', type: 'string' },
	                { name: 'valueLt7', type: 'string' },
	                { name: 'valueLt8', type: 'string' },
	                { name: 'carInfo', type: 'string' },
	                { name: 'valueDate3', type: 'string' },
	                { name: 'regName', type: 'string' },

	            ],
	            type: "POST",

	            data:
	            	{
	            	visitorCode : '<c:out value="${indata.visitorCode}"/>',
	            	},
	            id: 'id',
	            url: "/visit3View_docuSub"
	        };

	    	$("#grdDocuSub").on("bindingcomplete", function (event) {
	    		var localObjVisitor = {};
		   	     localObjVisitor.emptydatastring = "방문신청 정보가 없습니다.";

		   	   	 $("#grdDocuSub").jqxGrid('localizestrings', localObjVisitor);

	    	});
	        var daDocu = new $.jqx.dataAdapter(source);

	   	    $("#grdDocuSub").jqxGrid(
	      	{
				columnsresize: true,
				width : '100%',
				source: daDocu,
				autoheight: true,

				columns: [
					 { text: '순번'	, datafield: 'seq', align:'center', width: 50 , cellsalign:'center'},
					 { text: '내방객명'	, datafield: 'valueSt1', align:'center',width: 150 , cellsalign:'center'},
					 { text: '회사명'	, datafield: 'valueSt2', align:'center',width: 150 , cellsalign:'center'},
					 { text: '직책명'	, datafield: 'valueSt3', align:'center',width: 70 , cellsalign:'center'},
					 { text: '연락처'	, datafield: 'valueSt4', align:'center',width: 150 , cellsalign:'center'},
					 { text: '차량정보'	, datafield: 'valueSt5', align:'center',width: 150 , cellsalign:'center'},
					 { text: '최근방문일', datafield: 'valueDate3', align:'center' , cellsalign:'center'},
					 { text: '표찰'	, datafield: 'valueLt8', align:'center', width: 70 , cellsalign:'center'},
					 { text: '접견자'	, datafield: 'regName',align:'center',width: 100, cellsalign:'left'  }
				]

			});
		}
	</script>
	<script>
		function setGridVisitorBlock(){
			var source =
	        {
	            datatype: "json",
	            datafields: [
	            	{ name: 'seq', type: 'string' },
	                { name: 'blockName', type: 'string' },
	                { name: 'blockCompname', type: 'string' },
	                { name: 'blockGrdname', type: 'string' },
	                { name: 'blockTel', type: 'string' },
	                { name: 'carInfo', type: 'string' },
	                { name: 'blockDate', type: 'string' },
	                { name: 'blockAddress', type: 'string' },

	            ],
	            type: "POST",

	            data:
	            	{
	            	visitorName : '<c:out value="${indata.visitorName}"/>',
	            	visitorTel : '<c:out value="${indata.visitorTel}"/>',
	            	},
	            id: 'id',
	            url: "/visit3View_visitorBlock"
	        };

	    	$("#grdVisitorBlock").on("bindingcomplete", function (event) {
	    		var localObjVisitor = {};
		   	     localObjVisitor.emptydatastring = "수기 출입불가이력 정보가 없습니다.";

		   	   	 $("#grdVisitorBlock").jqxGrid('localizestrings', localObjVisitor);

	    	});
	        var daDocu = new $.jqx.dataAdapter(source);

	   	    $("#grdVisitorBlock").jqxGrid(
	      	{
				columnsresize: true,
				width : '100%',
				source: daDocu,
				autoheight: true,

				columns: [
					 { text: '순번'	, datafield: 'seq', align:'center', width: 50 , cellsalign:'center'},
					 { text: '출입불가자명'	, datafield: 'blockName', align:'center',width: 150 , cellsalign:'center'},
					 { text: '회사명'	, datafield: 'blockCompname', align:'center',width: 150 , cellsalign:'center'},
					 { text: '직책명'	, datafield: 'blockGrdname', align:'center',width: 70 , cellsalign:'center'},
					 { text: '연락처'	, datafield: 'blockTel', align:'center',width: 150 , cellsalign:'center'},
					 { text: '차량정보'	, datafield: 'carInfo', align:'center',width: 150 , cellsalign:'center'},
					 { text: '최근조회일', datafield: 'blockDate', align:'center',width: 150 , cellsalign:'center'},
					 { text: '등록자/사유'	, datafield: 'blockAddress',align:'center', cellsalign:'left'  }
				]

			});
		}
	</script>



</head>
<body>
<!-- 본문영역 start -->
    <div class="main-wrap">
		<div class="tit-wrap">
			<h1>내방객 정보 관리</h1>
			<div class="btn-wrap-act">
				<c:if test="${not empty ino }">
					<button class="btn" id="btnDelete" value="click" onclick="delete_visit3Edit()">삭제</button>
					<button class="btn" id="btnSave" value="click" onclick="save_visit3Edit('U')">저장</button>
				</c:if>

				<c:if test="${empty ino}">
					<button
						class="btn bl"
						id="btnSave"
						value="click"
						onclick="save_visit3Edit('C')">저장</button>
				</c:if>


				<button
					class="btn"
					id="btnList"
					value="click"
					onclick="moveWindowWithPost('visit3')">리스트</button>
			</div>
		</div>




    	<div class="stit-wrap mgt0">
			<h3>기본정보</h3>
		</div>
		<!-- 문서정보 기본정보 테이블 -->
		<div class="view-wrap">
			<div class="v-row">
				<div class="v-col-1">내방객번호</div>
				<div class="v-col-5">
					${indata.visitorCode}
				</div>
				<div class="v-col-1"><span class="star"></span>상태</div>
				<div class="v-col-5">
					<div id="cboStatus"></div>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1"><span class="star"></span>내방객명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorName" value="${indata.visitorName}" />
				</div>
				<div class="v-col-1"><span class="star"></span>회사명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorCompname" value="${indata.visitorCompname}"/>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1">부서명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorDeptname" value="${indata.visitorDeptname}"/>
				</div>
				<div class="v-col-1">직책명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorGrdname" value="${indata.visitorGrdname}"/>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1"><span class="star"></span>연락처</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorTel" value="${indata.visitorTel}"/>
				</div>
				<div class="v-col-1">E-Mail</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorMail" value="${indata.visitorMail}" class="w100"/>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1">회사주소(방문사유/접견자)</div>
				<div class="v-col-11">
					<input type="text" id="txtVisitorAddress"  value="${indata.visitorAddress}"  class="w100"/>
				</div>

			</div>
			<div class="v-row">
				<div class="v-col-1">차량번호</div>
				<div class="v-col-5">
					<div class="fl-line">
						<div id="cboCarNumber1"></div>
						<div class="mr-3"></div>
						<input type="text" id="txtCarNumber2" style="width:30px" value="${indata.carNumber2}"/>
						<div class="mr-3"></div>
						<input type="text" id="txtCarNumber3" style="width:30px" value="${indata.carNumber3}"/>
						<div class="mr-3"></div>
						<input type="text" id="txtCarNumber4" style="width:70px" value="${indata.carNumber4}"/>
					</div>
				</div>
				<div class="v-col-1">차량모델</div>
				<div class="v-col-5">
					<div class="fl-line">
						<div id="cboCarType1"></div>
						<div class="mr-3"></div>
						<input type="text" id="txtCarType2" value="${indata.carType2}"/>
					</div>
				</div>
			</div>
			<c:choose>
   			<c:when test="${not empty ino}">
				<div class="v-row">
					<div class="v-col-1">최근방문일</div>
					<div class="v-col-5">
						<div class="fl-line">
							<div id="dtpVisitDate" ></div>
							<div class="mr-3"></div>
							<button id="btnToday" class="btn-inner todayButton" relDatePick="dtpVisitDate" >오늘</button>
						</div>
					</div>
					<div class="v-col-1">동의서</div>
					<div class="v-col-5">
						<c:choose>
						<c:when test="${empty cont || empty indata.regDate}">
							<a href="javascript:sign_popup()" >[X]</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:sign_popup()" >[${indata.signYn}]</a>
						</c:otherwise>
						</c:choose>

					</div>
				</div>
			</c:when>
			<c:otherwise>
				<div class="v-row">
					<div class="v-col-1">최근방문일</div>
					<div class="v-col-11">
						<div class="fl-line">
							<div id="dtpVisitDate" ></div>
							<div class="mr-3"></div>
							<button id="btnToday" class="btn-inner todayButton" relDatePick="dtpVisitDate" >오늘</button>
						</div>
					</div>
				</div>
			</c:otherwise>
			</c:choose>

			<div class="v-row">
				<div class="v-col-1">진행 동의서</div>
				<div class="v-col-11">
					<c:choose>
					<c:when test="${empty cont}">
						없음
					</c:when>
					<c:otherwise>
						<div class="fl-line">
							<div>[${cont.contCode}]</div>
							<div class="mr-3"></div>
							<div>${cont.contTitle}</div>
						</div>
					</c:otherwise>
					</c:choose>
				</div>

			</div>

		</div>
		<c:if test="${not empty ino }">
			<div class="stit-wrap"><h3>수기 방문 이력</h3></div>
			<div id="grdVisitorLog"></div>
			<div class="stit-wrap"><h3>시스템 방문 이력</h3></div>
			<div id="grdVisitorSysLog"></div>
			<div class="stit-wrap"><h3>방문 신청 정보</h3></div>
			<div id="grdDocuSub"></div>
			<div class="stit-wrap"><h3>출입 불가 이력</h3></div>
			<div id="grdVisitorBlock"></div>
		</c:if>

		<!-- 기본정보영역 table end -->


<!-- 본문영역 end -->
	</div>
</body>
</html>