<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="base.jsp" flush="false"/>
	<script>
    $(function(){
    	
    	if('<c:out value="${fn:length(listSub)}"/>'=='0'){
    		$("#frm_visit2_goods_list").hide();
    	} 
    });
    
    function visit_process(inx) {
    	debugger;
    	var docCode = '<c:out value="${docCode}"/>';
    	var valueOpt2 = '<c:out value="${valueOpt2}"/>';
    	
    	var cnt = '<c:out value="${fn:length(listSub)}"/>';
    	
    	if (inx=="0") {
	    	for (i=0;i<=parseInt(cnt) ;i++ ) {
	    		$('#chkGoods_' + i).eq(0).attr("checked", "checked"); 
	    	}
    	}
    	
    	
    	if($("input:checkbox[name='chkGoods']:checked").length == 0){
    		swalAlert('선택된 반입물품정보가 없습니다.','warning');
    		return;
    	} else {
    		
    		swal({
                title: '반입 확인',
                text: "선택된 반입물품의 반입을 확인합니다.",
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
        	 }).then((result) => {
                 if (result.value) {
                	var joinStr = $("input:checkbox[name='chkGoods']:checked").map(function(){ return "'" + this.value + "'" }).get().join(",");
             	    
                 	var currUrl = window.location.host;
                 	
                 	$.ajax({
                         type: "POST",
                         url: "/update_frm_visit2_goods_list",
                         dataType : "json",
                         data: 
                     	{ 
                         	joinStr : joinStr, 
                 	   		group_code : 'g1011',
                 	   		currUrl : currUrl,
                 	   		doc_sub_type : 2,
                     	},
                         success: (data) => {
                         	
                         	$.post("/frm_visit2_goods_list"
                                  	, {
                                  		docCode: docCode,
                                  		valueOpt2: valueOpt2,
                                  		rnx: "0"
                                  	  }
                                  	,function(data){
                                  	  $("#frm_visit2_goods_list").html(data);//       
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
    
    
    function chk_all(){
    	var cnt = '<c:out value="${fn:length(listSub)}"/>';
		var chk = $("#chkGoodsAll:first").is(":checked")
		for (i=0;i<=parseInt(cnt) ;i++ ) {
			if (chk) {
				$('#chkGoods_' + i).eq(0).attr("checked", "checked"); 
			} else {
				$('#chkGoods_' + i).eq(0).removeAttr("checked"); 
			}
		}
    }
    
    
    
    </script>

</head>
<body>
<div class="">
	<div class="stit-wrap stit-pd">
		<h3>반입물품</h3>
		<div class="btn-wrap-act">
			<c:if test="${rnx eq '1'}">
				<a href="javascript:visit_process('0')"><button class="btn">오늘반입</button></a>
			</c:if>
		</div>
	</div>

		<div class="view-wrap">
			<div class="h-row">
				<div class="h-col-1">
				<c:if test="${rnx eq '1'}">
					<input id="chkGoodsAll" type="checkbox" onclick="javascript:chk_all();"/>
					<div class="mr-3"></div>   
				</c:if>
				품명	
				</div>
				<div class="h-col-3">모델명(규격)</div>
				<div class="h-col-4">제조번호(S/N)</div>
				<div class="h-col-1">수량</div>
				<div class="h-col-1">단위</div>
				<div class="h-col-2">비고</div>
			</div>
			<div class="h-row">
				<div class="h-col-4">실반입일</div>
				<div class="h-col-6">반입정보</div>
				<div class="h-col-2">반입여부</div>
			</div>
		</div>
		<c:forEach var="i" items="${listSub}" varStatus="status">
			
	      	<div class="v-row">
		      	<!-- 성명 -->
				<div class="h-col-1">
					<c:if test="${rnx eq '1'}">
						<input id="chkGoods_${status.index}" name="chkGoods" type="checkbox" value="${i.ino}"/>
						<div class="mr-3"></div>  
						<font color=darkred><b><c:out value="${i.valueSt1}"></c:out>	</b></font>
					</c:if>
					<c:if test="${rnx eq '0'}">
						<span>  <c:out value="${i.valueSt1}"></c:out>	</span>
					</c:if>
					
				</div>
				<div class="h-col-3"> <c:out value="${i.valueSt2}"></c:out> </div>
				<div class="h-col-4"> <c:out value="${i.valueSt3}"></c:out> </div>
				<div class="h-col-1"> <c:out value="${i.valueSt4}"></c:out> </div>
				<div class="h-col-1"> <c:out value="${i.valueSt5}"></c:out> </div>
				<div class="h-col-2"> <c:out value="${i.valueSt6}"></c:out> </div>
			</div>
			
			<div class="v-row">
				<!-- 실반입일 -->
				<div class="h-col-4">
					<c:choose>
				    	<c:when test="${rnx eq '1'  && empty i.valueDate4 }">
				    		<button class="btn-inner" onclick='visit_process(${i.ino})' id='btnGoods_${status.index}'>반입체크</button>
				    	</c:when>
				    	<c:otherwise>
				    		<c:out value="${i.valueDate4}"></c:out>
				    	</c:otherwise>
				    </c:choose>
				</div>
				<div class="h-col-6">
					<c:out value="${i.valueLt10}"></c:out>
				</div>
				<!-- 반입여부 -->
				<div class="h-col-2">
					<c:choose>
				    	<c:when test="${empty i.valueDate4 }">
				    		<font color=darkred>미반입</font>
				    	</c:when>
				    	<c:otherwise>
				    		<font color=darkred>반입확인</font>
				    	</c:otherwise>
				    </c:choose>
				</div>
			</div>
		</c:forEach>
</div>
</body>
</html>