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

   	var dVisit1Edit;
   	var listVisit1EditBlock;

    $(function(){

    	var javaList = '${indata}'; //jstl로 받아서 변수 지정
    	var data = fn_javaList2Json(javaList);
    	if(data.length > 0) dVisit1Edit = data[0];

    	setCombo("indata7", "visit1_opt2", "", "", "", "", "S");	//접견자

    	<c:if test="${not empty indata.reqType}">
			$('#indata7').val('<c:out value="${indata.reqType}"/>');
		</c:if>

//     	$('#indata7').val('<c:out value="${indata.reqType}"/>');
    	$('#indata11').val('<c:out value="${indata.reqName}"/>');

    	$('#indata7').on('change', function (event)
  		{
    		$('#indata11').val("");
  		});

    	$('#indata13').val('<c:out value="${indata.reqDeptname}"/>');
    	$('#indata16').val('<c:out value="${indata.reqComptel}"/>');
    	$('#indata17').val('<c:out value="${indata.reqMobile}"/>');

    	$("#indata66").jqxDateTimeInput({ formatString: 'yyyy-MM-dd' , width:100 });
    	$("#indata67").jqxDateTimeInput({ formatString: 'yyyy-MM-dd' , width:100});

    	$("#indata66").val('<c:out value="${indata.valueDate1}"/>');
    	$("#indata67").val('<c:out value="${indata.valueDate2}"/>');

    	setCombo("indata32", "s1016", "cateCombo", "cateName","cateName", 80, "S");
    	setCombo("indata33", "s1016", "cateCombo", "cateName","cateName", 80, "S");
    	
    	$("#indata32").jqxComboBox({ dropDownHeight:200, autoDropDownHeight: false });
    	$("#indata33").jqxComboBox({ dropDownHeight:200, autoDropDownHeight: false });

    	<c:if test="${not empty indata.valueSt1}">
			$('#indata32').val('<c:out value="${indata.valueSt1}"/>');
		</c:if>
		<c:if test="${not empty indata.valueSt2}">
			$('#indata33').val('<c:out value="${indata.valueSt2}"/>');
		</c:if>
//     	$("#indata32").val('<c:out value="${indata.valueSt1}"/>');
//     	$("#indata33").val('<c:out value="${indata.valueSt2}"/>');

    	$("#indata62").jqxRadioButtonGroup({items: [{label: '있음', value: '1'}, {label: '없음', value: '2'}], layout: 'horizontal'});
    	var useCar = '1';
    	if('<c:out value="${indata.valueOpt1}"/>' != '1') useCar = '0';
    	$('#indata62').jqxRadioButtonGroup({value: [useCar]});

    	setCombo("indata34", "s1011", "cateCombo", "cateName","cateName", "", "S");
    	setCombo("indata35", "s1012", "cateCombo", "cateName","cateName", "", "S");

    	<c:if test="${not empty indata.valueSt3}">
			$('#indata34').val('<c:out value="${indata.valueSt3}"/>');
		</c:if>
		<c:if test="${not empty indata.valueSt4}">
			$('#indata35').val('<c:out value="${indata.valueSt4}"/>');
		</c:if>
//     	$('#indata34').val('<c:out value="${indata.valueSt3}"/>');
//     	$('#indata35').val('<c:out value="${indata.valueSt4}"/>');
    	$('#indata52').val('<c:out value="${indata.valueLt1}"/>');

    	$("#indata63").jqxRadioButtonGroup({items: [{label: '있음', value: '1'}, {label: '없음', value: '2'}], layout: 'horizontal'});

    	$('#indata63').jqxRadioButtonGroup({change: (item) => {

    		if(item.value == "1"){
    			$('#BringItem').show();

    		} else {
    			$('#BringItem').hide();
    		}

    	}});

    	var useItem = '1';
    	if('<c:out value="${indata.valueOpt2}"/>' != '1') useItem = '2';
    	$('#indata63').jqxRadioButtonGroup({value: [useItem]});



    	setCombo("indata36", "s1013", "cateCombo", "cateName","cateName", "", "S");
    	setCombo("indata37", "s1014", "cateCombo", "cateName","cateName", "", "S");

    	<c:if test="${not empty indata.valueSt5}">
			$('#indata36').val('<c:out value="${indata.valueSt5}"/>');
		</c:if>
		<c:if test="${not empty indata.valueSt6}">
			$('#indata37').val('<c:out value="${indata.valueSt6}"/>');
		</c:if>
//     	$('#indata36').val('<c:out value="${indata.valueSt5}"/>');
//     	$('#indata37').val('<c:out value="${indata.valueSt6}"/>');

    	setGridVisitor();
    	setGridItem();

    	setCombo("cboCarRegion", "s1017", "cateCombo", "cateName","cateName", "", "S");
    	$('#cboCarRegion').jqxComboBox({ dropDownHeight:300, autoDropDownHeight: false });
    	
    	setCombo("cboCarType", "s1015", "cateCombo", "cateName","cateName", "", "S");
    	


    	$('#popVisitor').jqxWindow({autoOpen: false,
    		width: 800,
            height: 200,
            resizable: false, isModal: true, modalOpacity: 0.1,
            cancelButton: $('#cancelVisit'),
            initContent: function () {
                $('#okVisit').jqxButton({ width: '65px' });
                $('#cancelVisit').jqxButton({ width: '65px' });
                //$('#ok').focus();
            }
   		});
    	$('#popItem').jqxWindow({autoOpen: false,
    		width: 600,
            height: 200,
            resizable: false, isModal: true, modalOpacity: 0.1,
            cancelButton: $('#cancelItem'),
            initContent: function () {
                $('#okItem').jqxButton({ width: '65px' });
                $('#cancelItem').jqxButton({ width: '65px' });
                //$('#ok').focus();
            }
   		});
    	
    	
    	setCombo("cboValueOpt3", "checkSendMsg", "", "", "", "", "N");
    	$('#cboValueOpt3').val('N');
    	<c:if test="${not empty indata.valueOpt3}">
			$('#cboValueOpt3').val('<c:out value="${indata.valueOpt3}"/>');
		</c:if>
    	
    });



    </script>

    <script>


	function save_visit1Edit(cu){

 		fnGetIndata();
     	if(!validation_visit1Edit()) return;



    	$.ajax({
            type: "POST",
            url: "/visit1Edit_Save",
            dataType : "text",
            contentType: 'application/json',
            data: JSON.stringify(dVisit1Edit),
            success: (data) => {
            	moveWindowWithPost('visit1View', {DocCode: data});

            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });


    }

	function fnCallbackMember(data) {
		//$('#indata8').val('');
		//$('#indata9').val(data.loginid);
		//$('#indata10').val(data.epid);
		dVisit1Edit.reqDate = '';
		dVisit1Edit.reqId = data.loginid;
		dVisit1Edit.reqEpid = data.epid;

		$('#indata11').val(data.username);
		//$('#indata12').val(data.compname);
		dVisit1Edit.reqCompname = data.compname;

		$('#indata13').val(data.deptname);
		//$('#indata14').val(data.titlename);
		//$('#indata15').val('');
		dVisit1Edit.reqGrdname = data.titlename;
		dVisit1Edit.reqDutyname = "";

		$('#indata16').val(data.comptel);
		$('#indata17').val(data.mobile);
		//$('#indata18').val(data.email);
		//$('#indata19').val('');

		dVisit1Edit.reqMail = data.email;
		dVisit1Edit.reqHome = "";
 	}

	function fnGetIndata(){
		dVisit1Edit.ino = ${indata.ino}; //fn_javaList2Json 때문에 문자로 들어가서 다시 넣어줌.

		dVisit1Edit.reqType =  $('#indata7').val();//접견자 타입(임직원,협력사,내방객)
		dVisit1Edit.reqName = $('#indata11').val();//접견자
		dVisit1Edit.reqDeptname = $('#indata13').val();//부서명
		dVisit1Edit.reqComptel =  $('#indata16').val().replace(/(^\s*)|(\s*$)/gi, ""); //전화번호
    	dVisit1Edit.reqMobile = $('#indata17').val().replace(/(^\s*)|(\s*$)/gi, ""); //핸드폰
    	dVisit1Edit.valueDate1 = $('#indata66').val();//방문기간
    	dVisit1Edit.valueSt1 = $('#indata32').val();
    	dVisit1Edit.valueDate2 = $('#indata67').val();//방문기간
    	dVisit1Edit.valueSt2 = $('#indata33').val();

    	dVisit1Edit.valueOpt1 = $('#indata62').jqxRadioButtonGroup('value')[0];//차량여부
    	dVisit1Edit.valueSt3 = $('#indata34').val();//방문유형
    	dVisit1Edit.valueSt4 = $('#indata35').val();//방문목적

    	dVisit1Edit.valueSt5 = $('#indata36').val();//방문장소
    	dVisit1Edit.valueLt1 = $('#indata52').val();//방문세부목적
    	dVisit1Edit.valueOpt2 = $('#indata63').jqxRadioButtonGroup('value')[0];//반입물품
    	dVisit1Edit.valueSt6 = $('#indata37').val();//접견장소
    	
    	dVisit1Edit.valueOpt3 = $('#cboValueOpt3').val();



	}


	function validation_visit1Edit(){


    	if(isEmpty(dVisit1Edit.reqName)) {
    		swalRequired('접견자');
    		$('#indata11').focus();
    		return false;
    	}


    	if(isEmpty(dVisit1Edit.valueSt3)) {
    		swalRequired('방문유형');
    		$('#indata34').focus();
    		return false;
    	}


    	if(isEmpty(dVisit1Edit.valueSt4)) {
    		swalRequired('방문목적');
    		$('#indata35').focus();
    		return false;
    	}


    	if(isEmpty(dVisit1Edit.valueSt5)) {
    		swalRequired('방문장소');
    		$('#indata36').focus();
    		return false;
    	}


    	if(isEmpty(dVisit1Edit.valueDate1)) {
    		swalRequired('방문기간');
    		$('#indata66').focus();
    		return false;
    	}


    	if(isEmpty(dVisit1Edit.valueDate2)) {
    		swalRequired('방문기간');
    		$('#indata67').focus();
    		return false;
    	}

    	var stDt = $('#indata66').jqxDateTimeInput('value') ;
    	var edDt = $('#indata67').jqxDateTimeInput('value');
    	
    	
    	if(isEmpty($('#indata32').val())==false ){
    		var stDate = $('#indata66').jqxDateTimeInput('getText');
    		var stTime = $('#indata32').val();
    		var stDtString =  stDate + ' ' + stTime;
    		var stDt = new Date(stDtString);
    	} 
    	
    	if(isEmpty($('#indata33').val())==false ){
    		var edDate = $('#indata67').jqxDateTimeInput('getText');
    		var edTime = $('#indata33').val();
    		var edDtString =  edDate + ' ' + edTime;
    		var edDt = new Date(edDtString);
    	} 

    	var diffTime = (edDt.getTime() - stDt.getTime()) / (1000*60*60*24)+1;
    	if(diffTime < 1){
    		swalAlert('방문기간이 틀렸습니다.','info');
			return false;
    	} else {
    		if(dVisit1Edit.valueSt5 == 'SVC자재(이천)'){
    			if(diffTime > 31){
    				swalAlert('31일 이상 방문신청은 불가합니다.','info');
					return false;
    			}
    		} else {
    			if(diffTime > 7){
    				swalAlert('7일 이상 방문신청은 불가합니다.','info');
					return false;
    			}
    		}
    	}

    	if(isEmpty($('#cboValueOpt3').val())) {
    		swalRequired('SMS 발송여부');
    		$('#cboValueOpt3').focus();
    		return false;
    	}

    	if(isEmpty(dVisit1Edit.valueSt6)) {
    		swalRequired('접견장소');
    		$('#indata37').focus();
    		return false;
    	}



    	var rows = $('#grdVisitor').jqxGrid('getrows');
    	if(rows == null || rows.length == 0 ){
    		swalRequired('내방객정보');
			return false;
    	}

    	for (i = 0; i < rows.length; i++) {
    		var visitor = rows[i].valueSt1; //이상원
    		var tel = rows[i].valueSt4; // 010-8929-9172
    		if( !isEmpty(listVisit1EditBlock) && listVisit1EditBlock.length >0 ){
    			for (j = 0; j < listVisit1EditBlock.length; j++) {
    				if(listVisit1EditBlock[j].blockName == visitor &&  listVisit1EditBlock[j].blockTel == tel) {
    					swalAlert('내방객정보에 출입불가자가 포함되어있습니다.','info');
    					return false;
    				}
    			}
    		}

		}


    	if(isEmpty(dVisit1Edit.valueLt1)) {
    		swalRequired('방문세부목적');
    		$('#indata52').focus();
    		return false;
    	}


    	var rowsItem = $('#grdItem').jqxGrid('getrows');
    	if (dVisit1Edit.valueOpt2=="1") {
    		if(rowsItem == null || rowsItem.length == 0 ){
    			swalRequired('반입물품목록');
    			return false;
        	}
    	}


    	return true;
    }
	</script>

    <script>
    function setGridVisitor(){
    	var sourceVisitor =
        {
            datatype: "json",
            datafields: [
            	{ name: 'chk', type: 'bool' },
            	{ name: 'ino', type: 'string' },
                { name: 'docCode', type: 'string' },
                { name: 'valueSt1', type: 'string' },
                { name: 'valueSt2', type: 'string' },
                { name: 'valueSt3', type: 'string' },
                { name: 'valueSt4', type: 'string' },
                { name: 'valueSt5', type: 'string' },
                { name: 'valueSt6', type: 'string' },
                { name: 'valueSt7', type: 'string' },
                { name: 'valueSt8', type: 'string' },
                { name: 'carInfo', type: 'string' },
                { name: 'valueSt9', type: 'string' },
                { name: 'valueSt10', type: 'string' },

            ],
            type: "POST",

            data:
            	{
        	   		doc_code : '<c:out value="${indata.docCode}"/>',
            	},
            id: 'id',
            url: "/visit1View_visitor"
        };

    	$("#grdVisitor").on("bindingcomplete", function (event) {
    		var localObjVisitor = {};
	   	    localObjVisitor.emptydatastring = "등록된 내방객정보가 없습니다.";

	   	   	$("#grdVisitor").jqxGrid('localizestrings', localObjVisitor);

	   	  	getVisitorBlock();

    	});
        var daVisitor = new $.jqx.dataAdapter(sourceVisitor);

        var linkrenderer = function (row, column, value)
        {
        	if (value.indexOf('#') != -1)
        	{
        	value = value.substring(0, value.indexOf('#'));
        	}

        	//var ino  = daVisitor.records[row].ino;

        	var html = '<div class="grid-cell-link"><a href="javascript:fnAddVisitor('+row+');">'+value+'</a></div>';
        	return html;
        }
   	    $("#grdVisitor").jqxGrid(
      	{
			columnsresize: true,
			width : '100%',
			source: daVisitor,
			autoheight: true,
			editable: true,
			//editmode: 'click',

			columns: [
				 { text: '', columntype: 'checkbox', datafield: 'chk' },
				 { text: '성명'	, datafield: 'valueSt1', align:'center', width: 100 , editable:false, cellsrenderer: linkrenderer},
				 { text: '회사명'	, datafield: 'valueSt2', align:'center',width: 150 , editable:false},
				 { text: '직책'	, datafield: 'valueSt3', align:'center',width: 150 , editable:false},
				 { text: '연락처'	, datafield: 'valueSt4', align:'center',width: 150 , editable:false},
				 { text: '차량번호'	, datafield: 'carInfo', align:'center',width: 150 , editable:false},
				 { text: '차량종류'	, datafield: 'valueSt9', align:'center',width: 100  , editable:false},
				 { text: '차량모델'	, datafield: 'valueSt10',align:'center' , editable:false},
			]

		});

   	 		$("#grdVisitorFormat").jqxGrid(
   	      	{
   	      	columnsresize: true,
            width : '100%',

   				columns: [
   					 { text: '내방객 성명'	, datafield: 'valueSt1', align:'center', width: 100 },
   					 { text: '회사명'	, datafield: 'valueSt2', align:'center',width: 150 },
   					 { text: '직책'	, datafield: 'valueSt3', align:'center',width: 150 },
   					 { text: '연락처'	, datafield: 'valueSt4', align:'center',width: 150 },
   					 { text: '차량지역'	, datafield: 'valueSt5', align:'center',width: 80 },
   					{ text: '차량번호1'	, datafield: 'valueSt6', align:'center',width: 50 },
   					{ text: '차량번호2'	, datafield: 'valueSt7', align:'center',width: 40 },
   					{ text: '차량번호3'	, datafield: 'valueSt8', align:'center',width: 70 },
   					 { text: '차량종류'	, datafield: 'valueSt9', align:'center',width: 100 },
   					 { text: '차량모델'	, datafield: 'valueSt10',align:'center' , editable:false},
   				]

   			});

   	 	$("#grdVisitorFormat").hide();

    }

    function fnAddVisitor(row){

    	if(isEmpty(row)){
    		$('#hidIno').val("");
    		$('#txtVisitorName').val("");
    		$('#txtVisitorCompany').val("");
    		$('#txtVisitorPosition').val("");
    		$('#txtVisitorTel').val("");
    		$('#cboCarRegion').jqxComboBox('selectIndex', 0 );
    		$('#txtCarNum1').val("");
    		$('#txtCarNum2').val("");
    		$('#txtCarNum3').val("");
    		$('#cboCarType').jqxComboBox('selectIndex', 0 );
    		$('#txtCarmodel').val("");
    	} else {
    		var datarow = $("#grdVisitor").jqxGrid('getrowdata', row);

    		$('#hidIno').val(datarow.ino);
    		$('#txtVisitorName').val(datarow.valueSt1);
    		$('#txtVisitorCompany').val(datarow.valueSt2);
    		$('#txtVisitorPosition').val(datarow.valueSt3);
    		$('#txtVisitorTel').val(datarow.valueSt4);
    		if(isEmpty(datarow.valueSt5)) $('#cboCarRegion').jqxComboBox('selectIndex', 0 );
    		else $('#cboCarRegion').val(datarow.valueSt5);
    		$('#txtCarNum1').val(datarow.valueSt6);
    		$('#txtCarNum2').val(datarow.valueSt7);
    		$('#txtCarNum3').val(datarow.valueSt8);
    		if(isEmpty(datarow.valueSt9)) $('#cboCarType').jqxComboBox('selectIndex', 0 );
    		else $('#cboCarType').val(datarow.valueSt9);
    		$('#txtCarmodel').val(datarow.valueSt10);

    	}


    	 $('#popVisitor').jqxWindow('open');
    }

    function fnDelVisitor(){
    	var rows = $("#grdVisitor").jqxGrid('getrows');

    	var inoArr = [];
    	var rowidArr = [];
    	rows.forEach(function (row){
    		if(row.chk == true) {
    			inoArr.push(row.ino);
    			rowidArr.push(row.uid);
    		}
    	});

    	var inoData = inoArr.join(",");

    	if(isEmpty(inoData)) {
    		swalAlert('선택된 내방객 정보가 없습니다.','info');
    		return;
    	}

    	$.ajax({
            type: "POST",
            url: "/visit1Edit_deleteVisitor",
            dataType : "text",
            data:
        	{
            	inoData : inoData,
        	},
            success: (data) => {
            	rowidArr.forEach(function (rowid){
            		$('#grdVisitor').jqxGrid('deleterow', rowid);
            	});
            	getVisitorBlock();
            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });
    }

    function fnCallbackMemberVisitor(data) {
    	$('#hidIno').val("");
    	$('#hidVisitorCode').val(data.loginid);
		$('#txtVisitorName').val(data.username);
		$('#txtVisitorCompany').val(data.compname);
		$('#txtVisitorPosition').val(data.titlename);
		$('#txtVisitorTel').val(data.mobile);
		if(isEmpty(data.carNumber1))$('#cboCarRegion').jqxComboBox('selectIndex', 0 );
		else $('#cboCarRegion').val(data.carNumber1);
		$('#txtCarNum1').val(data.carNumber2);
		$('#txtCarNum2').val(data.carNumber3);
		$('#txtCarNum3').val(data.carNumber4);
		if(isEmpty(data.carType1))$('#cboCarType').jqxComboBox('selectIndex', 0 );
		else $('#cboCarType').val(data.carType1);
		$('#txtCarmodel').val(data.carType2);
 	}

    </script>

    <script>
    function setGridItem(){
    	var sourceItem =
        {
            datatype: "json",
            datafields: [
            	{ name: 'chk', type: 'bool' },
            	{ name: 'ino', type: 'string' },
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
        	   		doc_code : '<c:out value="${indata.docCode}"/>',
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
        var linkrenderer = function (row, column, value)
        {
        	if (value.indexOf('#') != -1)
        	{
        	value = value.substring(0, value.indexOf('#'));
        	}

        	//var ino  = daVisitor.records[row].ino;

        	var html = '<div class="grid-cell-link"><a href="javascript:fnAddItem('+row+');">'+value+'</a></div>';
        	return html;
        }
   	    $("#grdItem").jqxGrid(
      	{
			columnsresize: true,
			width : '100%',
			source: daItem,
			autoheight: true,
			editable: true,
			columns: [
				 { text: '', columntype: 'checkbox', datafield: 'chk' },
				 { text: '품명'	, datafield: 'valueSt1', align:'center',width: 120, editable: false, cellsrenderer: linkrenderer },
				 { text: '모델명(규격)', datafield: 'valueSt2', align:'center',width: 250, editable: false },
				 { text: '제조번호(S/N)', datafield: 'valueSt3', align:'center', width: 300, editable: false},
				 { text: '수량'	, datafield: 'valueSt4', align:'center',width: 100, editable: false },
				 { text: '단위'	, datafield: 'valueSt5', align:'center',width: 100, editable: false },
				 { text: '비고'	, datafield: 'valueSt6',align:'center', editable: false }
			]
		});


   		$("#grdItemFormat").jqxGrid(
   	      	{
   	      	columnsresize: true,
            width : '100%',

   				columns: [
   					 { text: '품명'			, datafield: 'valueSt1', align:'center', width: 120 },
   					 { text: '모델명(규격)'		, datafield: 'valueSt2', align:'center',width: 250 },
   					 { text: '제조번호(S/N)'	, datafield: 'valueSt3', align:'center',width: 300 },
   					 { text: '수량'	, datafield: 'valueSt4', align:'center',width: 100 },
   					 { text: '단위'	, datafield: 'valueSt5', align:'center',width: 100 },
   					 { text: '비고'	, datafield: 'valueSt6', align:'center',width: 100 },
   				]

   			});

   	 	$("#grdItemFormat").hide();


    }

   	function fnAddItem(row){
   		//var value = $('#grdItem').jqxGrid('addrow', null, {});
    	if(isEmpty(row)){
    		$('#hidInoItem').val("");
    		$('#txtItemName').val("");
    		$('#txtItemModel').val("");
    		$('#txtItemSN').val("");
    		$('#txtItemCnt').val("");
    		$('#txtItemUnit').val("");
    		$('#txtItemComment').val("");
    	} else {
    		var datarow = $("#grdItem").jqxGrid('getrowdata', row);

    		$('#hidInoItem').val(datarow.ino);
    		$('#txtItemName').val(datarow.valueSt1);
    		$('#txtItemModel').val(datarow.valueSt2);
    		$('#txtItemSN').val(datarow.valueSt3);
    		$('#txtItemCnt').val(datarow.valueSt4);
    		$('#txtItemUnit').val(datarow.valueSt5);
    		$('#txtItemComment').val(datarow.valueSt6);

    	}

   		$('#popItem').jqxWindow('open');
   	}

   	function saveItem_click(){
   		var execName = "";
    	if (isEmpty($('#hidInoItem').val())) {
    		execName = "등록";
		} else {
			execName = "수정";
		}


    	swal({
            title: '반입물품정보 저장',
            text: "반입물품정보를 " + execName + "하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: execName,
            cancelButtonText: '취소'
    	 }).then((result) => {
             if (result.value) {
            	 saveVisit1Edit_item();
             }
         });
   	}
   	
   	function saveVisit1Edit_item(){

		if(!validation_saveItem_click()) return;

		var datarow = {
				'chk' : false,
				'ino' : $('#hidInoItem').val(),
				'docCode' : '<c:out value="${indata.docCode}"/>',
				'valueSt1' : $('#txtItemName').val(),
				'valueSt2' : $('#txtItemModel').val(),
				'valueSt3' : $('#txtItemSN').val(),
				'valueSt4' : $('#txtItemCnt').val(),
				'valueSt5' : $('#txtItemUnit').val(),
				'valueSt6' : $('#txtItemComment').val(),

			};

		$.ajax({
            type: "POST",
            url: "/saveVisit1Edit_item",
            dataType : "text",
            data: datarow,
            success: (data) => {

            	if(isEmpty($('#hidIno').val())){
        	    	var rows = new Array();

        	    	datarow.ino = data;
        		    rows.push(datarow);
        	    	$("#grdItem").jqxGrid('addrow', null, rows);

            	} else {
            		var selectedrowindex = $('#grdItem').jqxGrid('selectedrowindex');
            		$("#grdItem").jqxGrid('updaterow', selectedrowindex, datarow);
            	}

            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });

		$('#popItem').jqxWindow('close');

   	}

   	function validation_saveItem_click(){

    	var itemName = $('#txtItemName').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(itemName)) {
    		swalRequired('반입물품 품명');
    		$('#txtItemName').focus();
    		return false;
    	}

    	var itemModel = $('#txtItemModel').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(itemModel)) {
    		swalRequired('반입물품 모델명(규격)');
    		$('#txtItemModel').focus();
    		return false;
    	}

    	var itemCnt = $('#txtItemCnt').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(itemCnt)) {
    		swalRequired('반입물품 수량');
    		$('#txtItemCnt').focus();
    		return false;
    	} else {
    		var regexp =/^\d{1,10}$/;
			if(itemCnt.match(regexp) == null) {
				swalAlert('반입물품 수량은 숫자만 입력가능합니다.','');
				return false;
			}
    	}

    	var itemUnit = $('#txtItemUnit').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(itemUnit)) {
    		swalRequired('반입물품 단위');
    		$('#txtItemUnit').focus();
    		return false;
    	}


    	return true;

   	}

   	function fnDelItem(){

    	var rows = $("#grdItem").jqxGrid('getrows');

    	var inoArr = [];
    	var rowidArr = [];
    	rows.forEach(function (row){
    		if(row.chk == true) {
    			inoArr.push(row.ino);
    			rowidArr.push(row.uid);
    		}
    	});

    	var inoData = inoArr.join(",");

    	if(isEmpty(inoData)) {
    		swalAlert('선택된 반입물품 정보가 없습니다.','info');
    		return;
    	}

    	$.ajax({
            type: "POST",
            url: "/visit1Edit_deleteVisitor",
            dataType : "text",
            data:
        	{
            	inoData : inoData,
        	},
            success: (data) => {
            	rowidArr.forEach(function (rowid){
            		$('#grdItem').jqxGrid('deleterow', rowid);
            	});
            },
            error : (request, status, error) => {
            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
        });
    }
    </script>


    <script>


    function saveVisit_click(){
    	
		var execName = "";
    	if (isEmpty($('#hidIno').val())) {
    		execName = "등록";
		} else {
			execName = "수정";
		}

    	if(!validation_saveVisit_click()) return;

    	swal({
            title: '내방객 정보',
            text: "내방객정보를 " + execName + "하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: execName,
            cancelButtonText: '취소'
    	 }).then((result) => {
             if (result.value) {
            	 var datarow = {
         				'chk' : false,
         				'ino' : $('#hidIno').val(),
         				'valueLt1' : $('#hidVisitorCode').val(),
         				'docCode' : '<c:out value="${indata.docCode}"/>',
         				'valueSt1' : $('#txtVisitorName').val(),
         				'valueSt2' : $('#txtVisitorCompany').val(),
         				'valueSt3' : $('#txtVisitorPosition').val(),
         				'valueSt4' : $('#txtVisitorTel').val(),
         				'valueSt5' : $('#cboCarRegion').val(),
         				'valueSt6' : $('#txtCarNum1').val(),
         				'valueSt7' : $('#txtCarNum2').val(),
         				'valueSt8' : $('#txtCarNum3').val(),
         				'carInfo' : $('#cboCarRegion').val() + $('#txtCarNum1').val() + $('#txtCarNum2').val() + $('#txtCarNum3').val(),
         				'valueSt9' : $('#cboCarType').val(),
         				'valueSt10' : $('#txtCarmodel').val()

         			};

	         	$.ajax({
	                 type: "POST",
	                 url: "/saveVisit1Edit_visitor",
	                 dataType : "text",
	                 data: datarow,
	                 success: (data) => {
	
	                 	if(isEmpty($('#hidIno').val())){
	             	    	var rows = new Array();
	
	             	    	datarow.ino = data;
	             		    rows.push(datarow);
	             	    	$("#grdVisitor").jqxGrid('addrow', null, rows);
	
	                 	} else {
	                 		var selectedrowindex = $('#grdVisitor').jqxGrid('selectedrowindex');
	                 		$("#grdVisitor").jqxGrid('updaterow', selectedrowindex, datarow);
	                 	}
	                 	getVisitorBlock();
	                 },
	                 error : (request, status, error) => {
	                 	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
	             	}
	             });
	
	
	         	$('#popVisitor').jqxWindow('close');
             }
         });
		

    	
    }

    function getVisitorBlock(){

    	var rows = $("#grdVisitor").jqxGrid('getrows');
    	$.ajax({
            type: "POST",
            url: "/visit1Edit_getVisitorBlock",
            dataType : "json",
            data:  { jsondata : JSON.stringify(rows)},
            success: (data) => {
            	listVisit1EditBlock = data;
            	if(data.length > 0){
            		var blockTag = '';
            		blockTag += ' <div class="mgb10"> </div> ' ;
                    blockTag += ' <div class="stit-wrap"><h3 class="red">출입 불가 정보</h3></div> ';
            		data.forEach(function (blockVisitor){

                        blockTag += ' <div class="view-wrap"> ';
                        blockTag += ' <div class="v-row"> ';
                        blockTag += ' <div class="v-col-1">성명  </div> ';
                        blockTag += ' <div class="v-col-5">' + blockVisitor.blockName + '</div> ';
                        blockTag += ' <div class="v-col-1"> 연락처  </div> ';
                        blockTag += ' <div class="v-col-5">' + blockVisitor.blockTel + '</div> ';
                        blockTag += ' </div> ';
                        blockTag += ' </div> ';

            		});

            		$("#visitorBlock").html(blockTag);
            	}
            	else $("#visitorBlock").html('');

            },
            error : (request, status, error) => {

            	alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        	}
    	});
    }


    function validation_saveVisit_click(){

    	var visitorName = $('#txtVisitorName').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(visitorName)) {
    		swalRequired('내방객 성명');
    		$('#txtVisitorName').focus();
    		return false;
    	}

    	var visitorCompany = $('#txtVisitorCompany').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(visitorCompany)) {
    		swalRequired('내방객 회사명');
    		$('#txtVisitorCompany').focus();
    		return false;
    	}

    	var visitorTel = $('#txtVisitorTel').val().replace(/(^\s*)|(\s*$)/gi, "");
    	if(isEmpty(visitorTel)) {
    		swalRequired('내방객 연락처');
    		$('#txtVisitorTel').focus();
    		return false;
    	} else {
    		if (isValidateTel(visitorTel)==false) {
    			swalAlert('내방객 연락처형식이 맞지 않습니다.\nex) 012-345-6789','info');
				return;
			}
    	}

    	var visitorCarRegion = $('#cboCarRegion').val();
    	var visitorCarNum1 = $('#txtCarNum1').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarNum2 = $('#txtCarNum2').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarNum3 = $('#txtCarNum3').val().replace(/(^\s*)|(\s*$)/gi, "");
    	var visitorCarModel = $('#cboCarType').val();
    	var visitorCarModelText = $('#txtCarmodel').val().replace(/(^\s*)|(\s*$)/gi, "");

    	var carData = visitorCarRegion + visitorCarNum1 + visitorCarNum2 + visitorCarNum3 + visitorCarModel + visitorCarModelText;
    	//if(isEmpty(visitorCarRegion) || isEmpty(visitorCarNum1) || isEmpty(visitorCarNum2) || isEmpty(visitorCarNum3) || isEmpty(visitorCarModel) || isEmpty(visitorCarModelText) ){
    	if( !isEmpty(carData) ){

    		if(isEmpty(visitorCarRegion)  ) {
    			swalRequired('차량정보 차량지역');
        		$('#cboCarRegion').focus();
        		return false;
        	}

        	if (isValidateCar(visitorCarRegion,visitorCarNum1,visitorCarNum2,visitorCarNum3)==false) {
        		swalAlert('차량번호 형식이 맞지 않습니다.\nex) 경기 12 가 3456','info');
    			return;
    		}

        	if(isEmpty(visitorCarModel) ) {
        		swalRequired('차량모델 차종선택');
        		//$('#cboCarType').focus();
        		return false;
        	}

//         	if(isEmpty(visitorCarModelText)) {
//         		alert('차량모델명은 필수입니다.');
//         		$('#txtCarmodel').focus();
//         		return false;
//         	}

        	
        	
       	

    	}

    	return true;

    }
    </script>

    <script>
    function delete_visit1Edit(){
    	
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
		            dataType : "json",
		            data:
		        	{
		            	doc_code : '<c:out value="${indata.docCode}"/>',
		            	ino : '<c:out value="${indata.ino}"/>'
		        	},
		            success: (data) => {
		            	moveWindowWithPost('visit1');
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

    function fnFormatDownloadVisitor(){
    	$("#grdVisitorFormat").jqxGrid('exportdata', 'xlsx', '내방객 업로드 포맷');
    }

	function fnFormatUploadVisitor(fis){

		const f = $("#file")[0];

		const formData = new FormData();
	    formData.append("file", f.files[0]);
	    formData.append("ino", $('#hidIno').val());
	    formData.append("docCode", '<c:out value="${indata.docCode}"/>');

	    $.ajax({
	        type:"POST",
	        url: "/visit1ExcelUploadVisitor",
	        processData: false,
	        contentType: false,
	        data: formData,
	        success: function(rtn){
	        	debugger;
	        	$("#file").val("");
	        	if(rtn == "sucess") setGridVisitor();
	        	else alert(rtn);
	        },
	        err: function(err){
	          console.log("err:", err)
	        }
	      });
	}

    </script>

    <script>
    function fnFormatDownloadItem(){
    	$("#grdItemFormat").jqxGrid('exportdata', 'xlsx', '반입물품 업로드 포맷');
    }

	function fnFormatUploadItem(fis){
		debugger;
		const f = $("#fileItem")[0];

		const formData = new FormData();
	    formData.append("file", f.files[0]);
	    formData.append("ino", $('#hidIno').val());
	    formData.append("docCode", '<c:out value="${indata.docCode}"/>');

	    $.ajax({
	        type:"POST",
	        url: "/visit1ExcelUploadItem",
	        processData: false,
	        contentType: false,
	        data: formData,
	        success: function(rtn){
	        	debugger;
	        	$("#fileItem").val("");
	        	if(rtn == "sucess") setGridItem();
	        	else alert(rtn);
	        },
	        err: function(err){
	          console.log("err:", err)
	        }
	      });
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
				<c:if test="${not empty ino && indata.docType eq '0'}">
					<button class="btn" id="btnDelete" value="click" onclick="delete_visit1Edit()">삭제</button>
				</c:if>
				<c:choose>
					<c:when test="${indata.docType eq '0'}">
						<c:if test="${empty ino}">
							<button
								class="btn bl"
								id="btnSave"
								value="click"
								onclick="save_visit1Edit('C')">저장</button>
						</c:if>
						<c:if test="${not empty ino}">
							<button class="btn" id="btnSave" value="click" onclick="save_visit1Edit('U')">저장</button>
						</c:if>
					</c:when>
				</c:choose>
				<button
					class="btn"
					id="btnList"
					value="click"
					onclick="moveWindowWithPost('visit1')">리스트</button>
			</div>
		</div>
		<input type="hidden" name="rnx" value='${indata.docType eq "0" ? "1" : "0"}'>
		<input type="hidden" name="dcode" value='${indata.docCode}'>


		<div class="stit-wrap mgt0">
			<h3>작성자 정보</h3>
		</div>
		<jsp:include page="include/include_app_writer.jsp" flush="false">
			<jsp:param name="id" value="${indata.writeId}" />
				<jsp:param name="name" value="${indata.writeName}" />
				<jsp:param name="dept" value="${indata.writeDeptname}" />
				<jsp:param name="telephone" value="${indata.writeComptel}" />
				<jsp:param name="mobilephone" value="${indata.writeMobile}" />
		</jsp:include>



    <!-- 기본정보영역 start -->




		<!-- 타이틀영역 start -->

		<!-- 타이틀영역 end -->
		<!-- 기본정보영역 table start -->




    	<div class="stit-wrap">
			<h3>기본정보</h3>
		</div>
			<!-- 문서정보 기본정보 테이블 -->
			<div class="view-wrap">
				<div class="v-row">
					<div class="v-col-1">문서번호</div>
					<div class="v-col-5">
						${indata.docCode}
					</div>
					<div class="v-col-1">결재상태</div>
					<div class="v-col-5">
						<span class="approval-lable">${docTypeName}
						</span>
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>접견자</div>
					<div class="v-col-5">
						<div class="fl-line">
							<div id="indata7"></div>
							<div class="mr-3"></div>
							<input type="text" id="indata11" style="width:150px" readonly/>
							<div class="mr-3"></div>
							<button type="button" class="btn-inner ic-search" onclick="javascript:fnEmpSearchPopupBefore({'width':'1000', 'height':'600', 'objName':'indata7'}, fnCallbackMember)"></button>
						</div>
					</div>
					<div class="v-col-1">부서명</div>
					<div class="v-col-5">
						<input type="text" id="indata13" readonly/>
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1">전화번호</div>
					<div class="v-col-5">
						<input type="text" id="indata16" />
					</div>
					<div class="v-col-1">핸드폰</div>
					<div class="v-col-5">
						<input type="text" id="indata17" />
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>방문기간</div>
					<div class="v-col-11">
						<div class="fl-line">

                                <div>
                                    <div id='indata66'></div>
                                </div>
                                <div class="mr-3"></div>
                                <div>
                                    <button id="btnToday1" class="btn-inner todayButton" relDatePick="indata66" >오늘</button>
                                </div>
                                <div class="mr-3"></div>
                                <div>
                                    <div id='indata32'></div>
                                </div>
                                <div class="mr-3"></div>
                                <div class="mlr-3">~</div>
                                <div>
                                    <div id='indata67'></div>
                                </div>
                                <div class="mr-3"></div>
                                <div>
                                    <button id="btnToday2" class="btn-inner todayButton" relDatePick="indata67">오늘</button>
                                </div>
                                <div class="mr-3"></div>
                                <div>
                                    <div id='indata33'></div>
                                </div>
                            </div>
					</div>

				</div>

				<div class="v-row">
					<div class="v-col-1">차량여부</div>
					<div class="v-col-5">
						<div id="indata62"></div>
					</div>
					<div class="v-col-1"><span class="star"></span>방문유형</div>
					<div class="v-col-5">
						<div id="indata34"></div>
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>방문목적</div>
					<div class="v-col-11 fl-col">
						<div class="fl-line">
							<div id="indata35"></div>
							<div class="mr-3"></div>
							<span class="red">(세부 방문목적 상세히 기입)</span>
						</div>
						<div class="mgb3"></div>
						<input type="text" id="indata52" class="w100"/>

					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>반입물품</div>
					<div class="v-col-5">
						<div id="indata63"></div>
					</div>
					<div class="v-col-1"><span class="star"></span>SMS 발송여부</div>
					<div class="v-col-5">
						<div id="cboValueOpt3"></div>
					</div>
				</div>
				
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>방문장소</div>
					<div class="v-col-5">
						<div id="indata36"></div>
					</div>
					<div class="v-col-1"><span class="star"></span>접견장소</div>
					<div class="v-col-5">
						<div id="indata37"></div>
					</div>
				</div>
				<c:if test="${indata.valueOpt4 eq '1' && not empty indata.valueSt20}">
					<div class="v-row">
						<div class="v-col-1">외부방문정보</div>
						<div class="v-col-5">
						<c:choose>
					    	<c:when test="${not empty exVisitIno}">
					    		<a href="javascript:detail_view2('${exVisitIno}');"><c:out value="${exVisitCode}"/></a></td>
					    	</c:when>
					    	<c:otherwise>
					    		<span><c:out value="${exVisitCode}"/></span>
					    	</c:otherwise>
					    </c:choose>

						</div>
						<div class="v-col-1"><span class="star"></span>신청자</div>
						<div class="v-col-5">
							<span><c:out value="${exVisitor}"/></span>
						</div>
					</div>
				</c:if>

			</div>
		   <!-- 양식 시작 -->
			<div class="mgb5"></div>
			<div class="view-wrap wide" id="form_file_management"></div>
			<!-- 양식 끝 -->
    		<div id="grdVisitorFormat"></div>
			<div id="visitorList">
				<div class="stit-wrap mgt8">
					<h3>내방객 정보</h3>
					<div class="btn-wrap-act">
						<button
							class="btn"
							id="btnDownloadVisitor"
							value="click"
							onclick="fnFormatDownloadVisitor()">포맷다운로드</button>

							<div class="upload-btn-wrapper">
				                	<input type="file" name="file" id="file" accept=".xlsx, .xls" onchange="fnFormatUploadVisitor(this)"/>
				                <button class="btn ">포맷업로드</button>
				            </div>
				            <div class="mr-3"></div>
						<button class="btn bl" id="btnAddVisitor" value="click" onclick="fnAddVisitor()">추가</button>
						<button class="btn bl" id="btnDelVisitor" value="click" onclick="fnDelVisitor()">삭제</button>
					</div>
				</div>

				<div id="grdVisitor"></div>
				<div id="visitorBlock"></div>
			</div>

			<div id="grdItemFormat"></div>
			<div id="BringItem">
				<div class="stit-wrap mgt8">
					<h3>반입물품</h3>
					<div class="btn-wrap-act">
						<button class="btn"
							id="btnDownloadItem"
							value="click"
							onclick="fnFormatDownloadItem()">포맷다운로드</button>
						<div class="upload-btn-wrapper">
			                	<input type="file" name="fileItem" id="fileItem" accept=".xlsx, .xls" onchange="fnFormatUploadItem(this)"/>
				                <button class="btn ">포맷업로드</button>
			            </div>
			            <div class="mr-3"></div>
						<button class="btn bl" id="btnAddItem" value="click" onclick="fnAddItem()">추가</button>
						<button class="btn bl" id="btnDelItem" value="click" onclick="fnDelItem()">삭제</button>
					</div>
				</div>
				<div id="grdItem"></div>
			</div>









		<!-- 기본정보영역 table end -->




<div id="popVisitor" >
 <div class="tit-pop">
 	내방객정보 상세
    <span class="red">(돋보기를 이용 이름으로 조회하여 선택 하시고, 신규방문객일 경우에만 수동입력)</span>
 </div>
	<div>
	    <div>
	    <input type="hidden" id="hidIno" value=''>
	    <input type="hidden" id="hidVisitorCode" value=''>
	        <div class="view-wrap">
				<div class="v-row">
					<div class="v-col-1"><span class="star"></span>성명</div>
					<div class="v-col-5">


					<div class="fl-line">
						<input type="text" id="txtVisitorName" style="width:80px"/>
						<div class="mr-3"></div>
						<button
							type="button"
							class="btn-inner ic-search"
							onclick="javascript:fnVisitorSearchPopup({'width':'1000', 'height':'600'}, fnCallbackMemberVisitor)"></button>
							<div class="mr-3"></div>
						<span>(신규일경우만 입력)</span>

					</div>

					</div>
					<div class="v-col-1"><span class="star"></span>회사명</div>
					<div class="v-col-5">
						<input type="text" id="txtVisitorCompany" />
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1">직책</div>
					<div class="v-col-5">
						<input type="text" id="txtVisitorPosition" />
					</div>
					<div class="v-col-1"><span class="star"></span>연락처</div>
					<div class="v-col-5">
						<input type="text" id="txtVisitorTel" />
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-1">차량번호</div>
					<div class="v-col-5">
						<div class="fl-line">
							<div id="cboCarRegion"></div><div class="mr-3"></div>
							<input type="text" id="txtCarNum1" style="width:35px" /><div class="mr-3"></div>
							<input type="text" id="txtCarNum2" style="width:25px" /><div class="mr-3"></div>
							<input type="text" id="txtCarNum3" style="width:50px" /><div class="mr-3"></div>
							<button type="button"
							class="btn-inner ic-search" onclick="javascript:car_search();"></button>
						</div>
					</div>
					<div class="v-col-1">차량모델</div>
					<div class="v-col-5" >
						<div class="fl-line">
							<div id="cboCarType"></div>
							<div class="mr-3"></div>
							<input type="text" id="txtCarmodel" class="w140px"/>
						</div>
					</div>
				</div>
			</div>
	    </div>

		<div class="btn-wrap-act">
			<button
				type="button"
				id="okVisit"
				class="btn"
				onclick="javascript:saveVisit_click();">저장</button>
			<button type="button" id="cancelVisit" class="btn">취소</button>
		</div>

	</div>
</div>

<div id="popItem" >
 <div class="tit-pop">
    반입물품 상세
 </div>
	<div>
	    <div>
	    <input type="hidden" id="hidInoItem" value=''>
	        <div class="view-wrap pop">
				<div class="v-row">
					<div class="v-col-2"><span class="star"></span>품명</div>
					<div class="v-col-4">
						<input type="text" id="txtItemName" class="w100" />
					</div>
					<div class="v-col-2"><span class="star"></span>모델명(규격)</div>
					<div class="v-col-4">
						<input type="text" id="txtItemModel" class="w100"/>
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-2">제조번호(S/N)</div>
					<div class="v-col-4">
						<input type="text" id="txtItemSN" class="w100"/>
					</div>
					<div class="v-col-2"><span class="star"></span>수량</div>
					<div class="v-col-4">
						<input type="text" id="txtItemCnt" class="w100"/>
					</div>
				</div>
				<div class="v-row">
					<div class="v-col-2"><span class="star"></span>단위</div>
					<div class="v-col-4">
						<input type="text" id="txtItemUnit" class="w100"/>
					</div>
					<div class="v-col-2">비고</div>
					<div class="v-col-4" >
						<input type="text" id="txtItemComment"class="w100" />
					</div>
				</div>
			</div>
	    </div>
		<div class="btn-wrap-act">
			<button type="button" id="okItem" class="btn" onclick="javascript:saveItem_click();">저장</button>
			<button type="button" id="cancelItem" class="btn">취소</button>
		</div>
	</div>
</div>



<!-- 본문영역 end -->
	</div>
</body>
</html>