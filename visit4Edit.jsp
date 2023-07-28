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

   	var dVisit4Edit;

    $(function(){
    	var javaList = '${indata}'; //jstl로 받아서 변수 지정
    	var data = fn_javaList2Json(javaList);
    	if(data.length > 0) dVisit4Edit = data[0];

    	setCombo("cboStatus", "visit4_opt2", "", "", "", "", "S");
    	<c:if test="${not empty indata.status}">
			$('#cboStatus').val('<c:out value="${indata.status}"/>');
		</c:if>

		$("#dtpVisitDate").jqxDateTimeInput({ formatString: 'yyyy-MM-dd hh:mm:ss' , width:155 ,disabled: true});
    	$("#dtpVisitDate").val('<c:out value="${indata.blockDate}"/>');

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
		</c:if>

    });

function save_visit4Edit(cu){

 		fnGetIndata();
     	if(!validation_visit4Edit()) return;



    	$.ajax({
            type: "POST",
            url: "/visit4Edit_Save",
            dataType : "text",
            data:
        	{
            	ino : dVisit4Edit.ino,
            	status : dVisit4Edit.status,
            	blockCode : dVisit4Edit.blockCode,
            	blockName : dVisit4Edit.blockName,
            	blockCompname : dVisit4Edit.blockCompname,
            	blockGrdname : dVisit4Edit.blockGrdname,
            	blockTel : dVisit4Edit.blockTel,
            	carNumber1 : dVisit4Edit.carNumber1,
            	carNumber2 : dVisit4Edit.carNumber2,
            	carNumber3 : dVisit4Edit.carNumber3,
            	carNumber4 : dVisit4Edit.carNumber4,
            	carType1 : dVisit4Edit.carType1,
            	carType2 : dVisit4Edit.carType2,
            	blockDate : dVisit4Edit.blockDate,
            	blockDeptname : dVisit4Edit.blockDeptname,
            	blockMail : dVisit4Edit.blockMail,
            	blockAddress : dVisit4Edit.blockAddress,
        	},
            success: (data) => {
            	moveWindowWithPost('visit4');
            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });


    }

	function fnGetIndata(){
		dVisit4Edit.ino = '${indata.ino}'; //fn_javaList2Json 때문에 문자로 들어가서 다시 넣어줌.

		dVisit4Edit.status =  $('#cboStatus').val();
		dVisit4Edit.blockName =  $('#txtVisitorName').val();
		dVisit4Edit.blockCompname = $('#txtVisitorCompname').val();
		dVisit4Edit.blockDeptname =  $('#txtVisitorDeptname').val();
		dVisit4Edit.blockGrdname =  $('#txtVisitorGrdname').val();
		dVisit4Edit.blockTel =  $('#txtVisitorTel').val().replace(/(^\s*)|(\s*$)/gi, "");
		dVisit4Edit.blockMail =  $('#txtVisitorMail').val();
		dVisit4Edit.blockAddress =  $('#txtVisitorAddress').val();
		dVisit4Edit.carNumber1 =  $('#cboCarNumber1').val();
		dVisit4Edit.carNumber2 =  $('#txtCarNumber2').val();
		dVisit4Edit.carNumber3 =  $('#txtCarNumber3').val();
		dVisit4Edit.carNumber4 =  $('#txtCarNumber4').val();
		dVisit4Edit.carType1 =  $('#cboCarType1').val();
		dVisit4Edit.carType2 =  $('#txtCarType2').val();
		dVisit4Edit.blockDate =  $('#dtpVisitDate').val();

	}


	function validation_visit4Edit(){

		if(isEmpty(dVisit4Edit.status)) {
    		alert('상태는 필수입니다.');
    		$('#cboStatus').focus();
    		return false;
    	}

    	if(isEmpty(dVisit4Edit.blockName)) {
    		alert('출입불가자명은 필수입니다.');
    		$('#txtVisitorName').focus();
    		return false;
    	}


    	if(isEmpty(dVisit4Edit.blockTel)) {
    		alert('내방객 연락처는 필수입니다.');
    		$('#txtVisitorTel').focus();
    		return false;
    	}
    	if(!isValidateTel(dVisit4Edit.blockTel)) {
    		alert('출입불가자 연락처형식이 맞지 않습니다.\nex) 012-345-6789');
    		return false;
    	}

    	if(isEmpty(dVisit4Edit.blockMail)==false) {
    		if(!isValidateEmail(dVisit4Edit.blockMail)) {
    			alert('출입불가자 이메일형식이 맞지 않습니다.\nex) abc@def.com');
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


    function delete_visit4Edit(){
    	
		swal({
            title: '출입불가자 정보 삭제',
            text: "출입불가자 정보를 삭제하시겠습니까?",
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
                     url: "/deleteVisit4View",
                     dataType : "text",
                     data:
                 	{
                     	blockCode : '<c:out value="${indata.blockCode}"/>',
                 	},
                     success: (data) => {
                     	moveWindowWithPost('visit4');
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
	                { name: 'visitorAddress', type: 'string' },

	            ],
	            type: "POST",

	            data:
	            	{
	            	blockName : '<c:out value="${indata.blockName}"/>',
	            	blockTel : '<c:out value="${indata.blockTel}"/>',
	            	},
	            id: 'id',
	            url: "/visit4View_visitorLog"
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

</head>
<body>
<!-- 본문영역 start -->
  <div class="main-wrap">
		<div class="tit-wrap">
			<h1>출입불가자 정보 관리</h1>
			<div class="btn-wrap-act">
				<c:if test="${not empty ino }">
					<button class="btn" id="btnDelete" value="click" onclick="delete_visit4Edit()">삭제</button>
					<button class="btn" id="btnSave" value="click" onclick="save_visit4Edit('U')">저장</button>
				</c:if>

				<c:if test="${empty ino}">
					<button
						class="btn bl"
						id="btnSave"
						value="click"
						onclick="save_visit4Edit('C')">저장</button>
				</c:if>


				<button
					class="btn"
					id="btnList"
					value="click"
					onclick="moveWindowWithPost('visit4')">리스트</button>
			</div>
		</div>

		<div class="stit-wrap mgt0">
			<h3>기본정보</h3>
		</div>
		<!-- 문서정보 기본정보 테이블 -->
		<div class="view-wrap">
			<div class="v-row">
				<div class="v-col-1">출입불가번호</div>
				<div class="v-col-5">
					${indata.blockCode}
				</div>
				<div class="v-col-1"><span class="star"></span>상태</div>
				<div class="v-col-5">
					<div id="cboStatus"></div>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1"><span class="star"></span>출입불가자명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorName" value="${indata.blockName}" />
				</div>
				<div class="v-col-1">회사명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorCompname" value="${indata.blockCompname}"/>
				</div>
			</div>

			<div class="v-row">
				<div class="v-col-1">부서명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorDeptname" value="${indata.blockDeptname}"/>
				</div>
				<div class="v-col-1">직책명</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorGrdname" value="${indata.blockGrdname}"/>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1"><span class="star"></span>연락처</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorTel" value="${indata.blockTel}"/>
				</div>
				<div class="v-col-1">E-Mail</div>
				<div class="v-col-5">
					<input type="text" id="txtVisitorMail" value="${indata.blockMail}" class="w100"/>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-1">회사주소(방문사유/접견자)</div>
				<div class="v-col-11">
					<input type="text" id="txtVisitorAddress"  value="${indata.blockAddress}"  class="w100"/>
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
			<div class="v-row">
				<div class="v-col-1">최근조회일</div>
				<div class="v-col-11">
					<div class="fl-line">
						<div id="dtpVisitDate" ></div>
						<div class="mr-3"></div>
						<button id="btnToday" class="btn-inner todayButton" relDatePick="dtpVisitDate" >오늘</button>
						<div class="mr-3"></div>
						<span>방문예약신청시 조회된 최근 날짜</span>
					</div>
				</div>
			</div>
			<div class="v-row">
				<div class="v-col-12 fl-center">
					<span  class="red">(방문예약신청시 방문객명과 연락처가 일치하면 차단 됩니다.)</span>
				</div>

			</div>
		</div>

		<c:if test="${not empty ino }">
			<div class="stit-wrap"><h3>수기 방문 이력</h3></div>
			<div id="grdVisitorLog"></div>
		</c:if>

   </div>
</body>
</html>