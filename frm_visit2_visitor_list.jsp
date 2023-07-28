<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%-- 	<jsp:include page="base.jsp" flush="false"/> --%>
<script>
    $(function(){
    	debugger;
    	<c:forEach var="i" items="${listSub}" varStatus="status">
    	{
	    	var rdo = '#rdoValueOpt1_' + '<c:out value="${status.index}"/>';
	    	if( $(rdo).size() > 0 ) {
		    	var valueOpt1 = '1';
		    	if('<c:out value="${i.valueOpt1}"/>' != '1') valueOpt1 = '2';
		    	$(rdo).jqxRadioButtonGroup({items: [{label: '반납', value: '1'}, {label: '미반납', value: '2'}], layout: 'horizontal', value: valueOpt1});
	    	}
	//     	$(rdo).jqxRadioButtonGroup({value: valueOpt1});
			
			var cboIdcard = "cboIdcard_" + '<c:out value="${status.index}"/>';
			if( $("#" + cboIdcard).size() > 0 ) setCombo(cboIdcard, "idcard", "", "", "", "", "S");
    	}
    	</c:forEach>
    	
//     	var cntListSub = <c:out value="${fn:length(listSub)}"/>;
//     	for (i=0;i<cntListSub ;i++ ) {
//     		var rdo = "#rdoValueOpt1_" + i;
//     		var valueOpt1 = '1';
// //     		if(dListSub[i].valueOpt1 != "1") valueOpt1 = '2';
//     		$(rdo).jqxRadioButtonGroup({items: [{label: '반납', value: '1'}, {label: '미반납', value: '2'}], layout: 'horizontal', value:valueOpt1});
    		
//     	}
//     	$("#rdoValueOpt1").jqxRadioButtonGroup({items: [{label: '반납', value: '1'}, {label: '미반납', value: '2'}], layout: 'horizontal'});
//     	var valueOpt1 = '1';
//     	if('<c:out value="${indata.valueOpt1}"/>' != '1') valueOpt1 = '2';
//     	$('#rdoValueOpt1').jqxRadioButtonGroup({value: valueOpt1});
    	
    	if('<c:out value="${fn:length(listSub)}"/>'=='0'){
    		$("#frm_visit2_visitor_list").hide();
    	} else {
    		setGridVisitorLog();
    	}
    	
    });
    
    function sign_popup(idx) {
		debugger;
		var options = {};
		var contCode = '<c:out value="${contData.contCode}"/>';
		var oldCode = '<c:out value="${contData.oldCode}"/>';
		var grpCode = 'c2002';
		
		var userid = $('#hidValueTxt1_' + idx).val();

		options.url = "/viewConsentPopup";
		options.params = { "CONT_CODE": contCode, "OLD_CODE":oldCode, "GROUP_CODE": grpCode, "USER_ID": userid };
		options.width = "800";
		options.height = "750";
		options.title = "winConsent";
		fnWinPopup(options, fnCallbackSign);
	}
	
	function fnCallbackSign(){
		//$("#btnSearch").trigger("click");
		$('.n-button').removeClass('n-button').addClass('y-button').html('Y')
	}
	
    function setGridVisitorLog(){
    	
    	var sourceVisitor =
        {
            datatype: "json",
            datafields: [
                { name: 'Idx', type: 'string' },
                { name: 'valueSt1', type: 'string' },
                { name: 'valueSt2', type: 'string' },
                { name: 'valueSt3', type: 'string' },
                { name: 'valueSt4', type: 'string' },
                { name: 'carInfo', type: 'string' },
                { name: 'visitDt', type: 'string' },
                { name: 'valueLt8', type: 'string' },
                { name: 'regName', type: 'string' },
                
            ],
            type: "POST",

            data: 
            	{ 
        	   		doc_code : '<c:out value="${docCode}"/>', 
            	},  
            id: 'id',
            url: "/frm_visit2_visitor_list_visitorSysLog"
        };
        
    	$("#grdVisitorLog").on("bindingcomplete", function (event) {
    		var localObjVisitor = {};
	   	     localObjVisitor.emptydatastring = "시스템 방문이력 정보가 없습니다.";
	   	     
	   	   	 $("#grdVisitorLog").jqxGrid('localizestrings', localObjVisitor);
   	   	 
    	});
        var daVisitor = new $.jqx.dataAdapter(sourceVisitor);
        
   	    $("#grdVisitorLog").jqxGrid(
      	{
			columnsresize: true,
			width : '100%',
			source: daVisitor,  
			autoheight: true,
			
			columns: [
				 { text: '순번'	, datafield: 'Idx', align:'center', width: 50 },
				 { text: '내방객명'	, datafield: 'valueSt1', align:'center',width: 100 },
				 { text: '회사명'	, datafield: 'valueSt2', align:'center',width: 150 },
				 { text: '직책명'	, datafield: 'valueSt3', align:'center',width: 100 },
				 { text: '연락처'	, datafield: 'valueSt4', align:'center',width: 200 },
				 { text: '차량정보'	, datafield: 'carInfo', align:'center',width: 100 },
				 { text: '최근방문일'	, datafield: 'visitDt', align:'center',width: 150 },
				 { text: '표찰'	, datafield: 'valueLt8',  align:'center' },
				 { text: '접견자'	, datafield: 'regName', align:'center' },
			]
      		
		});
   	    
	   	 
	   	 
    }
    
    
    function fnPreView() {
    	var contents = $("#contBody").val();
    	var title = $("#contTitle").text();
    	fnOpenContentsTitlePopup("[내방객] 개인정보 수집 및 이용동의서", title, contents, 750, 600);
    	
    }
    
    
    function visit_process1(inx) {
    	debugger;
    	var docCode = '<c:out value="${docCode}"/>';
    	
    	var cnt = '<c:out value="${fn:length(listSub)}"/>';
    	var inoArr = new Array();
    	var labelArr = new Array();
    	var idcardArr = new Array();
		
		if (inx=="999") { //현재방문 버튼 클릭
			for (i=0;i<parseInt(cnt) ;i++ ) {
	    		$('#chkVisit_' + i).eq(0).attr("checked", "checked"); 
	    	}
			
			for (i=0;i<parseInt(cnt) ;i++ ) {
				var btn = $('#btnVisitIn_' + i);
				if(btn.size() == 0){
					swalAlert('이미 방문 처리된 내용이 있습니다.', 'warning');
		    		return;
				} 
			}
			
			$("input:checkbox[name='chkVisit']").each(function(idx, element){ 
				
				var tmp_ino = $('#chkVisit_' + idx + ':checked').val();
				var tmp_label = $('#visit_label_' + idx).val();
				if (tmp_label=="") {
					//alert('선택된 내방객의 표찰번호가 없습니다.');
					labelArr.splice(0, labelArr.length);
					return false;
				}
				
				inoArr.push(tmp_ino);
				labelArr.push(tmp_label);	
				
				var tmp_idcard = $('#cboIdcard_' + idx).val();
				if(tmp_idcard == ""){
					idcardArr.splice(0, idcardArr.length);
					return false;
				}
				
				idcardArr.push(tmp_idcard);	
			});
			
		}else {
			var tmp_ino = $('#chkVisit_' + inx).val();
			inoArr.push(tmp_ino);
			var tmp_label = $('#visit_label_' + inx).val();
			if (tmp_label != "") labelArr.push(tmp_label);	
			
			var tmp_idcard = $('#cboIdcard_' + inx).val();
			if (tmp_idcard != "") idcardArr.push(tmp_idcard);	
			
		}
		

		
		if(labelArr.length==0){
			swalAlert('선택된 내방객의 표찰번호가 없습니다.', 'warning');
    		return;
		} else if(idcardArr.length==0){
			swalAlert('선택된 내방객의 신분증 확인 여부가 선택되지 않았습니다.', 'warning');
    		return;
    	} else {
    		swal({
                title: '방문 확인',
                text: "선택된 내방객의 방문을 확인합니다.",
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
        	 }).then((result) => {
                 if (result.value) {
                	 var inoData = inoArr.join(",");
             		var labelData = labelArr.join(",");
                 	var currUrl = window.location.host;
                 	var idcardData = idcardArr.join(",");
                 	
                 	$.ajax({
                         type: "POST",
                         url: "/update_frm_visit2_visitor_list",
                         dataType : "json",
                         data: 
                     	{ 
                         	inoData : inoData, 
                         	labelData : labelData,
                         	idcardData : idcardData,
                 	   		group_code : 'g1011',
                 	   		currUrl : currUrl,
                 	   		odr_type : 'In',
                     	},
                         success: (data) => {
                         	
                         	$.post("/frm_visit2_visitor_list"
                                  	, {
                                  		docCode: docCode,
                                  		rnx: "1"
                                  	  }
                                  	,function(data){
                                  	  $("#frm_visit2_visitor_list").html(data);//       
                                 	 }
                                 );
                         }
                     });
                 }
        	 });
    		
    	}
		
		
    	
    }
    	
    
    function visit_process2(inx) {
    	
		var docCode = '<c:out value="${docCode}"/>';
    	
    	var cnt = '<c:out value="${fn:length(listSub)}"/>';
    	var inoArr = new Array();
    	var labelArr = new Array();
		
		if (inx=="999") { //현재출문 버튼 클릭
			for (i=0;i<parseInt(cnt) ;i++ ) {
	    		$('#chkVisit_' + i).eq(0).attr("checked", "checked"); 
	    	}
			
			for (i=0;i<parseInt(cnt) ;i++ ) {
				var btn = $('#btnVisitOut_' + i);
				if(btn.size() == 0){
					swalAlert('이미 출문 처리된 내용이 있습니다.', 'warning');
		    		return;
				} 
			}
			
			for (i=0;i<parseInt(cnt) ;i++ ) {
				var btn = $('#btnVisitIn_' + i);
				if(btn.size() > 0){
					swalAlert('입문 처리부터 선행되어야합니다..', 'warning');
		    		return;
				} 
			}
			
			$("input:checkbox[name='chkVisit']").each(function(idx, element){ 
				
				var tmp_ino = $('#chkVisit_' + idx + ':checked').val();
				var tmp_label = $('#rdoValueOpt1_' + idx).val();
				if (tmp_label=="") {
					//alert('선택된 내방객의 표찰번호가 없습니다.');
					labelArr.splice(0, labelArr.length);
					return false;
				}
				inoArr.push(tmp_ino);
				labelArr.push(tmp_label);			
			});
			
			
		} else {
			var btn = $('#btnVisitOut_' + inx);
			if(btn.size() == 0){
				swalAlert('이미 출문 처리된 내용이 있습니다.', 'warning');
	    		return;
			} 
			
			var btnIn = $('#btnVisitIn_' + inx);
			if(btnIn.size() > 0){
				swalAlert('입문 처리부터 선행되어야합니다..', 'warning');
	    		return;
			} 
			
			var tmp_ino = $('#chkVisit_' + inx).val();
			inoArr.push(tmp_ino);
			var tmp_label = $('#rdoValueOpt1_' + inx).val();
			if (tmp_label != "") labelArr.push(tmp_label);	
			
		}
		

    		if(labelArr.length==0){
    			swalAlert('선택된 내방객의 표찰반납여부가 없습니다.','warning');
        		return;
        	} else {
        		swal({
                    title: '출문 확인',
                    text: "선택된 내방객의 출문을 확인합니다.",
                    icon: 'info',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소'
            	 }).then((result) => {
                     if (result.value) {
                    	var inoData = inoArr.join(",");
                 		var labelData = labelArr.join(",");
                     	var currUrl = window.location.host;
                     	
                     	$.ajax({
                             type: "POST",
                             url: "/update_frm_visit2_visitor_list",
                             dataType : "json",
                             data: 
                         	{ 
                             	inoData : inoData, 
                             	labelData : labelData,
                     	   		group_code : 'g1011',
                     	   		currUrl : currUrl,
                     	   		odr_type : 'Out',
                         	},
                             success: (data) => {
                             	
                             	$.post("/frm_visit2_visitor_list"
                                      	, {
                                      		docCode: docCode,
                                      		rnx: "1"
                                      	  }
                                      	,function(data){
                                      	  $("#frm_visit2_visitor_list").html(data);//       
                                     	 }
                                     );
                             },
                             error : (request, status, error) => {
                             	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                         	}
                         });
                     }
            	 });
        		
        		
        	}
    		
    		
    	
    }
    
    
    </script>
</head>
<body>
	<!-- 타이틀영역 start -->

	<!-- 타이틀영역 end -->

	<!-- 내방객정보영역 start -->



	<div id="divCont" class="mgt10">
		<div class="stit-wrap">
			<h3>진행 동의서</h3>
			<span class="pdl25"><c:out value="${contData.contTitle}" /></span> <span
				class="pdr5"></span> <a href="javascript:fnPreView()">
				<button class="btn-inner">미리보기</button>
			</a>
		</div>
		<input type="hidden" id="contBody"
			value='<c:out value="${contData.contBody}"/>' />
	</div>

	<div class="stit-wrap">
		<h3>내방객정보</h3>
		<div class="btn-wrap-act">
			<c:if test="${rnx eq '1' && possibleInout eq 'T' }">
				<a href="javascript:visit_process1('999')"><button class="btn">현재방문</button></a>
				<div class="mr-3"></div>
				<a href="javascript:visit_process2('999')"><button class="btn">현재출문</button></a>
			</c:if>
		</div>
	</div>

	<div class="view-wrap">
		<div class="h-row">
			<div class="h-col-1">성명</div>
			<div class="h-col-2">회사명</div>
			<div class="h-col-1">직책</div>
			<div class="h-col-2">연락처</div>
			<div class="h-col-2">차량번호</div>
			<div class="h-col-1">차량종류</div>
			<div class="h-col-2">차량모델</div>
			<div class="h-col-1">동의</div>
		</div>
		<div class="h-row">
			<div class="h-col-3">실방문시간</div>
			<div class="h-col-6">방문정보</div>
			<div class="h-col-2">신분증 확인 여부</div>
			<div class="h-col-1">표찰번호</div>
		</div>
		<div class="h-row">
			<div class="h-col-3">실출문시간</div>
			<div class="h-col-6">출문정보</div>
			<div class="h-col-3">표찰반납여부</div>
		</div>
		<c:forEach var="i" items="${listSub}" varStatus="status">
			<input type="hidden" id="hidValueTxt1_${status.index}"
				value='<c:out value="${i.valueTxt1}"/>' />
			<div class="v-row">
				<!-- 성명 -->
				<div class="h-col-1">
					<c:if test="${rnx eq '1'}">
						<input type="checkbox" id="chkVisit_${status.index}"
							name="chkVisit" value="${i.ino}" />
						<div class="mr-3"></div>
						<font color=darkred><b><c:out value="${i.valueSt1}"></c:out>
						</b></font>
					</c:if>
					<c:if test="${rnx eq '0'}">
						<span> <c:out value="${i.valueSt1}"></c:out>
						</span>
					</c:if>

				</div>
				<div class="h-col-2">
					<c:out value="${i.valueSt2}"></c:out>
				</div>
				<!-- 회사명 -->
				<div class="h-col-1">
					<c:out value="${i.valueSt3}"></c:out>
				</div>
				<!-- 직책 -->
				<!-- 연락처 -->
				<div class="h-col-2">
					<c:out value="${i.valueSt4}"></c:out>
				</div>
				<!-- 차량번호 -->
				<div class="h-col-2">
					<c:out
						value="${i.valueSt5} ${i.valueSt6} ${i.valueSt7} ${i.valueSt8}"></c:out>
				</div>
				<div class="h-col-1">
					<c:out value="${i.valueSt9}"></c:out>
				</div>
				<!-- 차량종류 -->
				<div class="h-col-2">
					<c:out value="${i.valueSt10}"></c:out>
				</div>
				<!-- 차량모델 -->
				<!-- 동의 -->
				<%-- 				<c:if test="${listContSignCnt[status.index] eq '0'}"> --%>
				<!-- 					<div class="h-col-1">N</div> -->
				<%-- 				</c:if> --%>
				<%-- 				<c:if test="${listContSignCnt[status.index] eq '1'}"> --%>
				<!-- 					<div class="h-col-1">Y</div> -->
				<%-- 				</c:if> --%>
				<c:if test="${listContSignCnt[status.index] eq '0'}">
					<div class="h-col-1 align-flex-center">
						<button class="n-button" onclick='sign_popup(${status.index})'>N</button>
					</div>
				</c:if>
				<c:if test="${listContSignCnt[status.index] eq '1'}">
					<div class="h-col-1 align-flex-center">
						<button class="y-button" onclick='sign_popup(${status.index})'>Y</button>
					</div>
				</c:if>



			</div>

			<div class="v-row">
				<!-- 실방문시간 -->
				<div class="h-col-3">
					<div class="fl-line">
						<c:if test="${listchkIn[status.index] eq '0'}">
							<span>방문체크</span>
							<div class="mr-3"></div>
							<button class="btn-inner"
								onclick='visit_process1(${status.index})' id='btnVisitIn_${status.index}'>오늘</button>
						</c:if>
						<c:if test="${listchkIn[status.index] eq '1'}">
							<div class="mr-3"></div>
							<c:out value="${i.valueDate3}"></c:out>
						</c:if>
					</div>

				</div>
				<!-- 방문정보 -->
				<!-- listchkIn 값이 1이면 버튼이 안생기는 거임.  -->
				<div class="h-col-6">
					<c:if test="${listchkIn[status.index] eq '0'}">
						<c:out value="${i.valueDate3}"></c:out>
					</c:if>
					<c:if test="${listchkIn[status.index] eq '1' && not empty i.valueLt9}">
						<c:out value="${i.valueLt9}"></c:out>
					</c:if>
				</div>
				<!-- 신분증 확인 여부 -->
				<div class="h-col-2">
				<input type="hidden" value='<c:out value="${listchkIn[status.index]}"/>' />
					<c:if test="${listchkIn[status.index] eq '0'}">
						<div id="cboIdcard_${status.index}"></div>
					</c:if>
					<c:if test="${listchkIn[status.index] eq '1' && not empty i.valueTxt2}">
						<c:out value="${i.valueTxt2}"></c:out>
					</c:if>
				</div>
				<!-- 표찰번호 -->
				<div class="h-col-1">
					<c:if test="${listchkIn[status.index] eq '0'}">
						<input type="text" id="visit_label_${status.index}"
							name="visit_label_${status.index}" maxlength="20"
							value="${i.valueLt8}" class="w100" />
					</c:if>
					<c:if test="${listchkIn[status.index] eq '1' && not empty i.valueLt8}">
						<c:out value="${i.valueLt8}"></c:out>
					</c:if>
				</div>
			</div>

			<div class="v-row">
				<!-- 실출문시간 -->
				<div class="h-col-3">
					<div class="fl-line">
						<c:if test="${listchkOut[status.index] eq '0'}">
							<span>출문체크</span>
							<div class="mr-3"></div>
							<button class="btn-inner"
								onclick='visit_process2(${status.index})' id='btnVisitOut_${status.index}'>오늘</button>
						</c:if>
						<c:if test="${listchkOut[status.index] eq '1'}">
							<div class="mr-3"></div>
							<c:out value="${i.valueDate4}"></c:out>
						</c:if>
					</div>

				</div>
				<!-- 출문정보 -->
				<div class="h-col-6">
					<c:if test="${listchkOut[status.index] eq '0'}">
						<c:out value="${i.valueDate4}"></c:out>
					</c:if>
					<c:if test="${listchkOut[status.index] eq '1' && not empty i.valueLt10}">
						<c:out value="${i.valueLt10}"></c:out>
					</c:if>
				</div>
				<!-- 표찰반납여부 -->
				<div class="h-col-3">
					<c:if test="${listchkOut[status.index] eq '0'}">
						<div id="rdoValueOpt1_${status.index}"></div>
					</c:if>
					<c:if test="${listchkOut[status.index] eq '1' && not empty i.valueOpt1}">
						<c:if test="${i.valueOpt1 eq '1'}">반납</c:if>
						<c:if test="${i.valueOpt1 eq '2'}">미반납</c:if>
					</c:if>
				</div>
			</div>

		</c:forEach>
		<c:forEach var="i" items="${listBlock}" varStatus="status">
			<div class="h-col-12">
				<div id="divBlock">
					<h3>출입 불가 정보</h3>
					<span>성명 : </span> <span><c:out value="${i.blockName}"></c:out></span>
					<span> , 연락처 : </span> <span><c:out value="${i.blockTel}"></c:out></span>
					<c:if test="${not empty i.blockAddress}">
						<span> , 등록자/사유 : </span>
						<span><c:out value="${i.blockAddress}"></c:out></span>
					</c:if>
				</div>
			</div>
		</c:forEach>

	</div>

	<div class="mgb15"></div>

	<div id="grdVisitorLog"></div>




	<!-- 내방객정보영역 end -->

</body>
</html>