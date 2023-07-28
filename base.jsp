<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<script>
		$(function () {
			$(".todayButton").on('click', function (e) {

				var dtPickerID = e.target.getAttribute("relDatePick");
				$("#" + dtPickerID).jqxDateTimeInput('setDate', new Date());
			});

			if($(".ic_area").length > 0) {
				$(".ic_area").empty();
				menuPopoverSearch('${sessionMenuId }', 'Y');
			}else if($(".ic_area2").length > 0) {
				$(".ic_area2").empty();
				menuPopoverSearch('${sessionMenuId }', 'N');
			}

			if($("#form_file_management").length > 0) {
				$("#form_file_management").empty();
				gfn_menu_file_init('${sessionMenuId }');
			}

		    $('span.approval-label').each(function(index,obj){
		        if( $(this).text() == "미상신" || $(this).text() == "미등록" ) {
		        	$(this).addClass('label1');
		        }else if($(this).text() == "결재중") {
		        	$(this).addClass('label2');
		        }else if( $(this).text() == "완결" || $(this).text() == "등록" || $(this).text() == "등록완료" ) {
		        	$(this).addClass('label3');
		        }else if($(this).text() == "반려") {
		        	$(this).addClass('label4');
		        }else if($(this).text() == "상신취소") {
		        	$(this).addClass('label5');
		        }else if($(this).text() == "전결") {
		        	$(this).addClass('label6');
		        }else if($(this).text() == "후완결") {
		        	$(this).addClass('label7');
		        }
		    });


		    var sessionClass = "${sessionClass}";
		    if( isEmpty(sessionClass) ) {
			    $("body").attr("class", "DEFAULT");
		    }else {
		    	$("body").attr("class", sessionClass);
		    }
		});

		function gfn_menu_file_init(menuId) {
			var param = {
					attachCode: menuId,
					attachSubCode: '3',
			};
			gfn_select_file_info(param);
		}

		function gfn_select_file_info(param){
			var paramData = {
					attachCode: param.attachCode,
					attachSubCode: param.attachSubCode,
		    };

			$.ajax({
				url : "/selectUploadFileList",
				data : paramData,
				type : 'POST',
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				dataType : 'json',
				cache : false,
				success : function(result) {
					var dataList = result.data;
					if( !isEmpty(dataList) && dataList.length > 0 ) {
						gfn_menu_attach_make(result.data);
					}else {
						console.log("저장된 양식이 없습니다.");
					}
				}
			});
		}

		function gfn_menu_attach_make(dataList){
			var html = '<div class="v-row">';
			html += '<div class="h-col-1 title-col">양식</div>';
			html += '<div class="h-col-11 multi-line">';
			for (var i = 0; i <dataList.length; i++) {
				html += '<div class="v-row multi-line">';
				html += '<div class="h-col-12">';
				html += '<a href="javascript:void(0);" onclick="fnDownloadFormat(\''+dataList[i].fileName+'\',\'/templateFileDownload\');">'+dataList[i].fileName+'</a>';
				html += '</div>';
				html += '</div>';
			}
			html += '</div>';
			html += '</div>';
			$("#form_file_management").html(html);
		}


		function setTriggerSearch(...params) {
			for (var i in params) {
				var control = $("#" + params[i]);
				control.on("keyup", function () {
					if (window.event.keyCode == 13) {
						$("#btnSearch").trigger("click");
					}
				});
			}
		}

		function isEmpty(value) {

			if (value === null) return true;
			if (typeof value === 'string' && value === '') return true;
			if (typeof value === 'undefined') return true;
			if (value === 'null') return true;

			return false;

		}

		function strEmpDefault(value, defVal) {
			if( isEmpty(value) ) return defVal;
			else return value;
		}

		function req_clear(k) {
			if (k == null || k == "") {
				k = "1";
			}
			if (k == "1") {
				$("#indata8").val("");
				$("#indata9").val("");
				$("#indata10").val("");
				$("#indata11").val("");
				$("#indata12").val("");
				$("#indata13").val("");
				$("#indata14").val("");
				$("#indata15").val("");
				$("#indata16").val("");
				$("#indata17").val("");
				$("#indata18").val("");
				$("#indata19").val("");
			} else if (k == "2") {
				$("#indata53").val("");
				$("#indata54").val("");
				$("#indata55").val("");
				$("#indata56").val("");
				$("#indata57").val("");
				$("#indata58").val("");
			}
		}

		function setCombo(comboName, groupCode, url, code, codeName, width, placeHolder, maxHeight) {

			var control = $("#" + comboName);

			if (isEmpty(url)) url = "/commonCombo";
			if (isEmpty(code)) code = "code";
			if (isEmpty(codeName)) codeName = "codeName";
			if (isEmpty(width)) width = 150;
			if (isEmpty(placeHolder)) placeHolder = "A";
			// prepare the data
			var source =
			{
				datatype: "json",
				datafields: [
					{ name: code },
					{ name: codeName }
				],
				data:
				{
					groupCode: groupCode
				},
				type: "POST",
				url: url,
				async: false
			};

			var dataAdapter = new $.jqx.dataAdapter(source);

			if( comboName === "valueOpt1" ) {
				//console.log(dataAdapter);
			}

			if (isEmpty(maxHeight)) {
				control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });
			}else {
				control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, dropDownHeight: maxHeight });
			}

			if (placeHolder == 'A') { // 전체
				control.jqxComboBox('insertAt', { label: '전체', value: '' }, 0);
			} else if (placeHolder == 'S') {
				control.jqxComboBox('insertAt', { label: '선택', value: '' }, 0);
			}

			$("#" + comboName + " input").attr('readonly', true);
		}

		function setCombo4Include(comboName, groupCode, cateInclude,code,codeName, width, placeHolder, maxHeight) {

			var control = $("#" + comboName);

			var url = "/cateTreeCombo";
			if (isEmpty(code))  code = "cateCode";
			if (isEmpty(codeName)) codeName = "cateName";
			if (isEmpty(width)) width = 150;
			if (isEmpty(placeHolder)) placeHolder = "A";
			// prepare the data
			var source =
			{
				datatype: "json",
				datafields: [
					{ name: code },
					{ name: codeName }
				],
				data:
				{
					groupCode: groupCode,
					cateInclude : cateInclude
				},
				type: "POST",
				url: url,
				async: false
			};

			var dataAdapter = new $.jqx.dataAdapter(source);

			if( comboName === "valueOpt1" ) {
				//console.log(dataAdapter);
			}

			if (isEmpty(maxHeight)) {
				control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });
			}else {
				control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, dropDownHeight: maxHeight });
			}

			if (placeHolder == 'A') { // 전체
				control.jqxComboBox('insertAt', { label: '전체', value: '' }, 0);
			} else if (placeHolder == 'S') {
				control.jqxComboBox('insertAt', { label: '선택', value: '' }, 0);
			}

			$("#" + comboName + " input").attr('readonly', true);
		}

		function setTreeCombo(comboName, groupCode, url, code, codeName, cateLevel, parentId, width, placeHolder) {

			var control = $("#" + comboName);

			if (isEmpty(url)) url = "commonCombo";
			if (isEmpty(code)) code = "code";
			if (isEmpty(codeName)) codeName = "codeName";
			if (isEmpty(cateLevel)) cateLevel = "1";
			if (isEmpty(width)) width = 150;

			// prepare the data
			var source =
			{
				datatype: "json",
				datafields: [
					{ name: code },
					{ name: codeName }
				],
				data:
				{
					groupCode: groupCode,
					cateInclude: parentId,
					cateLevel: cateLevel
				},
				type: "POST",
				url: url,
				async: false
			};

			var dataAdapter = new $.jqx.dataAdapter(source);

			control.jqxComboBox({
				source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true
			});

			if (placeHolder == 'A') { // 전체
				control.jqxComboBox('insertAt', { label: '전체', value: '' }, 0);
				control.jqxComboBox({selectedIndex:0});
			} else if (placeHolder == 'S') {
				control.jqxComboBox('insertAt', { label: '선택', value: '' }, 0);
				control.jqxComboBox({selectedIndex:0});
			}

// 			if (placeHolder == 'N') { //placeHolder 제거
// 				control.jqxComboBox({
// 					source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true
// 				});
// 			} else if (placeHolder == 'A') { // 전체
// 				control.jqxComboBox({ placeHolder: "전체", source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });
// 			} else {
// 				control.jqxComboBox({ placeHolder: "선택", source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });
// 			}
		}

		function setReportCombo(comboName, groupCode, url, code, codeName, year, width, placeHolder) {
			var control = $("#" + comboName);

			if (isEmpty(width)) width = 150;

			// prepare the data
			var source =
			{
				datatype: "json",
				datafields: [
					{ name: code },
					{ name: codeName }
				],
				data:
				{
					groupCode: groupCode,
					searchOpt0: year
				},
				type: "POST",
				url: url,
				async: false
			};

			var dataAdapter = new $.jqx.dataAdapter(source);

			control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });

			if (placeHolder == 'S') { // 전체
				control.jqxComboBox('insertAt', { label: '선택', value: '' }, 0);
			} else {
				control.jqxComboBox('insertAt', { label: '전체', value: '' }, 0);
			}
		}

		function setApprCombo(comboName, groupCode, url, menuCode, code, codeName, width, placeHolder, submitType) {

			var control = $("#" + comboName);

			if (isEmpty(url)) url = "commonCombo";
			if (isEmpty(code)) code = "code";
			if (isEmpty(codeName)) codeName = "codeName";
			if (isEmpty(width)) width = 150;
			if (isEmpty(placeHolder)) placeHolder = "A";
			// prepare the data
			var source =
			{
				datatype: "json",
				datafields: [
					{ name: code },
					{ name: codeName }
				],
				data:
				{
					groupCode: groupCode,
					menuCode: menuCode,
					submitType: submitType
				},
				type: "POST",
				url: url,
				async: false
			};

			var dataAdapter = new $.jqx.dataAdapter(source);

			control.jqxComboBox({ selectedIndex: 0, source: dataAdapter, displayMember: codeName, valueMember: code, width: width, autoDropDownHeight: true });

			if (placeHolder == 'A') { // 전체
				control.jqxComboBox('insertAt', { label: '전체', value: '' }, 0);
			} else if (placeHolder == 'S') {
				control.jqxComboBox('insertAt', { label: '선택', value: '' }, 0);
			}

			$("#" + comboName + " input").attr('readonly', true);
		}

		function moveWindowWithPost(url, data) {
			var form = document.createElement("form");
			form.target = "_self";
			form.method = "POST";
			form.action = url;
			form.style.display = "none";

			for (var key in data) {
				var input = document.createElement("input");
				input.type = "hidden";
				input.name = key;
				input.value = data[key];
				form.appendChild(input);
			}

			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
		}


		function fn_javaList2Json(obj) {

			var resultJson = [];

			var str = obj.split('[{').join('').split('}]').join(''); //양끝 문자열 제거
			var rows = str.split('},{'); //str는 배열

			for (var i = 0; rows.length > i; i++) { // rows 배열만큼 for돌림

				var cols = rows[i].split(', ');
				var rowData = {};

				for (var j = 0; cols.length > j; j++) {

					var colData = cols[j];
					colData = colData.trim();


					var key = colData.substring(0, colData.indexOf("="));
					var val = colData.substring(colData.indexOf("=") + 1);

					rowData[key] = val;
				}

				resultJson.push(rowData);
			}

			return resultJson;
		}

		function fnScreenPrint(initBody) {
			//var initBody = document.body.innerHTML;

			window.onbeforeprint = function () {
				document.body.innerHTML = $('.contents').html();
			}
			window.onafterprint = function () {
				document.body.innerHTML = initBody;
			}
			window.print();

		}

		function fnInit() {
			$('#fPopup').jqxWindow({
				autoOpen: false,
				width: 300,
				height: 100,
			});
		}

		function fnOpenPopup(title, comment, width, height) {

			$('#fPopup').jqxWindow({
				autoOpen: false,
				width: width,
				height: height
			});

			$("#fPopup #fPopupHeader").text(title);
			$("#fPopup #fPopupContent").text(comment);

			$("#fPopup").jqxWindow('open');
		}

		function fnOpenContentsPopup(title, contents, width, height) {
			$('#fPopup').jqxWindow({
				autoOpen: false,
				width: width,
				height: height,
				resizable: false, isModal: true, modalOpacity: 0.1
			});

			$("#fPopup #fPopupHeader").text(title);
			$("#fPopup #fPopupContent")[0].innerHTML = contents;
			$("#fPopup").jqxWindow('open');
			$('#cancelfPopup').click(function () {
                    $('#fPopup').jqxWindow('close');
                });
		}

		function fnOpenContentsTitlePopup(header, title, contents, width, height) {
			$('#fPopupTitle').jqxWindow({
				autoOpen: false,
				width: width,
				height: height
			});

			$("#fPopupTitle #fPopupHeader").text(header);
			$("#fPopupTitle #fPopupTitle").text(title);
			$("#fPopupTitle #fPopupContent")[0].innerHTML = contents;
			$("#fPopupTitle").jqxWindow('open');
		}

		function isValidateEmail(email) {
			if (email.length <= 0) {
				return false;
			}
			var splitted = email.match("^(.+)@(.+)$");
			if (splitted == null) return false;
			if (splitted[1] != null) {
				var regexp_user = /^\"?[\w-_\.]*\"?$/;
				if (splitted[1].match(regexp_user) == null) return false;
			}
			if (splitted[2] != null) {
				var regexp_domain = /^[\w-\.]*\.[A-Za-z]{2,4}$/;
				if (splitted[2].match(regexp_domain) == null) {
					var regexp_ip = /^\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\]$/;
					if (splitted[2].match(regexp_ip) == null) return false;
				}
				return true;
			}
			return false;
		}
		function isValidateTel(tel) {
			if (tel.length <= 0 || tel == "+") {
				return false;
			}
			var regexp;
			if (tel.substr(0, 1) == "+") {
				tel = tel.substr(1);
				regexp = /^\d{1,4}-\d{1,4}-\d{3,4}-\d{4}$/;
			} else {
				regexp = /^\d{2,4}-\d{3,4}-\d{4}$/;
			}
			if (tel.match(regexp) == null) return false;
			return true;
		}
		function isValidateUrl(strUrl) {
			var RegexUrl = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
			return RegexUrl.test(strUrl);
		}
		function isValidateCar(car1, car2, car3, car4) {
			if (car1.length <= 0 || car2.length <= 0 || car3.length <= 0 || car4.length <= 0) {
				return false;
			}
			var regexp1 = /^[가-힣]{2}$/;
			if (car1.match(regexp1) == null) return false;
			var regexp2 = /^\d{1,3}$/;				//2자리에서 1~2자리로 변경
			if (car2.match(regexp2) == null) return false;
			var regexp3 = /^[가-힣]{1}$/;
			if (car3.match(regexp3) == null) return false;
			var regexp4 = /^\d{4}$/;
			if (car4.match(regexp4) == null) return false;
			return true;
		}

		function isValidateDate(strDate) {
			if (strDate.length != 10) {
				return false;
			}
			var regexp;
			regexp = /^\d{4,4}-\d{2,2}-\d{2,2}$/;
			if (strDate.match(regexp) == null) return false;
			return true;
		}

		function isValidateTime(strTime) {
			if (strTime.length != 5) {
				return false;
			}
			var regexp;
			regexp = /^\d{2,2}:\d{2,2}$/;
			if (strTime.match(regexp) == null) return false;
			return true;
		}

		function isValidateIP(strIP) {
			if (strIP.length <= 0) {
				return false;
			}
			var regexp;
			regexp = /^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}$/;
			if (strIP.match(regexp) == null) return false;
			return true;
		}

		//jquery modal
		function popup(opt) {
			$.ajax({
				type: opt.type,
				url: opt.url,
				data: opt.data,
				dataType: 'html',
				success: function (html) {
					if (!opt.size) opt.size = "modal-md";
					$("<div class='modal_popup " + opt.size + "' role='dialog'>" + html + "</div>")
						.appendTo('body')
						.modal({
							escapeClose: false,
							clickClose: false,
							closeExisting: false
						})
						.on($.modal.CLOSE, function (event, modal) {
							if (opt.close) opt.close(modal.result);
							modal.elm.remove();
						});

				},
				error: function (res) {
					if (opt.error) opt.error(res.responseText);
					else {
						alert("error");
					}
					throw "popup_error";
				}
			});
		}
		//datevalue:Date type, addtype:y,M,d,h,m,s addvalue:Number
		function get_date_from_dateadd(datevalue, addtype, addvalue) {
			if (datevalue == null || datevalue == "") {
				return null;
			} else if (addtype == null || addtype == "") {
				return null;
			} else if (addvalue == null || addvalue == "") {
				return null;
			}

			addvalue = "" + addvalue;
			if (isNaN(addvalue) == true) {
				return;
			}

			addYear = 0;
			addMonth = 0;
			addDate = 0
			addHours = 0;
			addMinutes = 0;
			addSeconds = 0;

			if (addtype == "y") {
				addYear = parseInt(addvalue, 10);
			} else if (addtype == "M") {
				addMonth = parseInt(addvalue, 10);
			} else if (addtype == "d") {
				addDate = parseInt(addvalue, 10);
			} else if (addtype == "h") {
				addHours = parseInt(addvalue, 10);
			} else if (addtype == "m") {
				addMinutes = parseInt(addvalue, 10);
			} else if (addtype == "s") {
				addSeconds = parseInt(addvalue, 10);
			}

			var rstvalue = new Date();
			rstvalue.setFullYear(datevalue.getFullYear() + addYear);
			rstvalue.setMonth(datevalue.getMonth() + addMonth);
			rstvalue.setDate(datevalue.getDate() + addDate);

			rstvalue.setHours(datevalue.getHours() + addHours);
			rstvalue.setMinutes(datevalue.getMinutes() + addMinutes);
			rstvalue.setSeconds(datevalue.getSeconds() + addSeconds);

			return rstvalue;
		}
		//from:yyyy-MM-dd, to:Date
		function get_date_from_datestring(datevalue) {
			if (datevalue == null || datevalue == "") {
				return null;
			} else if (isValidateDate(datevalue) == false) {
				return null;
			}

			var rstvalue = new Date();
			rstvalue.setFullYear(parseInt(datevalue.substring(0, 4), 10));
			rstvalue.setMonth(parseInt(datevalue.substring(5, 7), 10) - 1);
			rstvalue.setDate(parseInt(datevalue.substring(8, 10), 10));

			return rstvalue;
		}
		//from:Date, to:yyyy-MM-dd
		function set_datestring(datevalue) {
			if (datevalue == null || datevalue == "") {
				return "";
			}

			var tmp = '';
			tmp = datevalue.getFullYear() + "-";
			tmps = "" + (datevalue.getMonth() + 1);
			if (tmps.length == 1) {
				tmps = "0" + tmps;
			}
			tmp = tmp + tmps + "-";
			tmps = "" + (datevalue.getDate());
			if (tmps.length == 1) {
				tmps = "0" + tmps;
			}
			tmp = tmp + tmps;
			return tmp;
		}

		//from:hh:mm, to:Date
		function get_date_from_timestring(datevalue) {
			if (datevalue==null || datevalue=="") {
				return null;
			} else if (isValidateTime(datevalue)==false) {
				return null;
			}

			var rstvalue = new Date();

			rstvalue.setHours(parseInt(datevalue.substring(0,2),10));
			rstvalue.setMinutes(parseInt(datevalue.substring(3,5),10));
			return rstvalue;
		}

		//from:Date, to:hh:mm
		function set_timestring(datevalue) {
			if (datevalue==null || datevalue=="") {
				return "";
			}

			var tmp = '';
			tmps ="" + datevalue.getHours();
			if (tmps.length==1) {
				tmps = "0" + tmps;
			}
			tmp = tmp + tmps + ":";
			tmps = "" + datevalue.getMinutes();
			if (tmps.length==1) {
				tmps = "0" + tmps;
			}
			tmp = tmp + tmps;
			return tmp;
		}

		var fnEmpSearchPopupBefore = function (option, callbackFunc) {
			if( isEmpty(option.objName) ) {
				fnEmpSearchPopup(option, callbackFunc);
			}else {
				var searchType = $('#'+option.objName).val();
				//console.log("searchType::", searchType);
				if( "1" == searchType || "3" == searchType ) {//1:임직원, 3:협력사
					option.searchType = searchType;
					fnEmpSearchPopup(option, callbackFunc);
				}else if ("2" == searchType) {//내방객
					fnVisitorSearchPopup(option, callbackFunc);
				}else {
					fnEmpSearchPopup(option, callbackFunc);
				}
			}
		}

		var fnEmpSearchPopup = function (option, callbackFunc) {
			var url = "/empSearchPage";
			if (isEmpty(option.paramkey)) option.paramkey = "";
			if (isEmpty(option.paramval)) option.paramval = "";
			if (isEmpty(option.autoset)) option.autoset = "false";
			if (isEmpty(option.searchType)) option.searchType = "A";
			var params = "?" + "searchKey=" + option.paramkey + "&searchVal=" + option.paramval + "&autoSet=" + option.autoset + "&searchType=" + option.searchType;
			var win_popup;
			var width = option.width;
			var height = option.height;
			if (isEmpty(width)) width = 1000;
			if (isEmpty(height)) height = 600;
			var winl = (screen.width - width) / 2;
			var wint = (screen.height - height) / 2;

			var settings = 'height=' + height + ',';
			settings += 'width=' + width + ',';
			settings += 'top=' + wint + ',';
			settings += 'left=' + winl + ',';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			win_popup = window.open(url + params, "win_popup", settings);
			window.callbackPopup = callbackFunc;
		}

		var fnVisitorSearchPopup = function (option, callbackFunc) {
			var url = "/visitorSearchPage";
			var params = "";//"?" + "searchKey=" + option.paramkey + "&searchVal=" + option.paramval + "&autoSet=" + option.autoset + "&searchType=" + option.searchType;
			var win_popup;
			var width = option.width;
			var height = option.height;
			if (isEmpty(width)) width = 1000;
			if (isEmpty(height)) height = 600;
			var winl = (screen.width - width) / 2;
			var wint = (screen.height - height) / 2;

			var settings = 'height=' + height + ',';
			settings += 'width=' + width + ',';
			settings += 'top=' + wint + ',';
			settings += 'left=' + winl + ',';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			win_popup = window.open(url + params, "win_popup", settings);
			window.callbackPopup = callbackFunc;
		}

		/* mobile 용 사용자 검색 팝업 시작 */
		var mobileEmpSearchPopupBefore = function (option, callbackFunc) {
			if( isEmpty(option.objName) ) {
				mobileEmpSearchPopup(option, callbackFunc);
			}else {
				var searchType = $('#'+option.objName).val();
				if( "1" == searchType || "3" == searchType ) {//1:임직원, 3:협력사
					option.searchType = searchType;
					mobileEmpSearchPopup(option, callbackFunc);
				}else if ("2" == searchType) {//내방객
					mobileVisitorSearchPopup(option, callbackFunc);
				}else {
					mobileEmpSearchPopup(option, callbackFunc);
				}
			}
		}

		var mobileEmpSearchPopup = function (option, callbackFunc) {
			var url = "/mobile/popup/mobileEmpSearch";
			if (isEmpty(option.paramkey)) option.paramkey = "userName";
			if (isEmpty(option.paramval)) option.paramval = "";
			if (isEmpty(option.autoset)) option.autoset = false;
			if (isEmpty(option.searchType)) option.searchType = "A";
			var params = "?" + "searchKey=" + option.paramkey + "&searchVal=" + option.paramval + "&autoSet=" + option.autoset + "&searchType=" + option.searchType;
			var win_popup;

			var settings = 'height=' + screen.height + ',';
			settings += 'width=' + screen.width + ',';
			settings += 'top=0px,';
			settings += 'left=0px,';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			win_popup = window.open(url + params, "win_popup", settings);
			window.callbackPopup = callbackFunc;
		}

		var mobileVisitorSearchPopup = function (option, callbackFunc) {
			var url = "/mobile/popup/mobileVisitorSearch";
			var params = "";//"?" + "searchKey=" + option.paramkey + "&searchVal=" + option.paramval + "&autoSet=" + option.autoset + "&searchType=" + option.searchType;
			var win_popup;

			var settings = 'height=' + screen.height + ',';
			settings += 'width=' + screen.width + ',';
			settings += 'top=0px,';
			settings += 'left=0px,';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			win_popup = window.open(url + params, "win_popup", settings);
			window.callbackPopup = callbackFunc;
		}
		/* mobile 용 사용자 검색 팝업 끝 */




		var fnApprovalPopup = function (data, callbackFunc) {
			var url = "/approvalPage";
			var params = "";
			var width = 1130;
			var height = 900;
			var winl = (screen.width - width) / 2;
			var wint = (screen.height - height) / 2;

			var settings = 'height=' + height + ',';
			settings += 'width=' + width + ',';
			settings += 'top=' + wint + ',';
			settings += 'left=' + winl + ',';
			//settings += 'scrollbars=no,';
			settings += 'overflow-x=auto,';
			settings += 'location=no,';
			settings += 'resizable=no';

			var form = document.createElement("form");
			form.method = "POST";
			form.action = url;
			form.style.display = "none";

			if(isEmpty(data.docCode) ){
				swalAlert('문서번호가 없습니다.','info');
				return;
			}

			if(isEmpty(data.menuCode) ){
				swalAlert('메뉴코드가 없습니다.','info');
				return;
			}

			for (var key in data) {
				var input = document.createElement("input");
				input.type = "hidden";
				input.name = key;
				input.value = data[key];
				form.appendChild(input);
			}

			window.open("", "pop", settings);
			form.target = "pop"
			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
			window.callbackPopup = callbackFunc;
		}

		var fnApprovalMobile = function (data, callbackFunc) {
			var url = "/approvalMobile";
			var params = "";

			var settings = 'height=' + screen.height + ',';
			settings += 'width=' + screen.width + ',';
			settings += 'top=0px,';
			settings += 'left=0px,';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			var form = document.createElement("form");
			form.method = "POST";
			form.action = url;
			form.style.display = "none";

			if(isEmpty(data.docCode) ){
				swalAlert('문서번호가 없습니다.','info');
				return;
			}

			if(isEmpty(data.menuCode) ){
				swalAlert('메뉴코드가 없습니다.','info');
				return;
			}

			for (var key in data) {
				var input = document.createElement("input");
				input.type = "hidden";
				input.name = key;
				input.value = data[key];
				form.appendChild(input);
			}

			window.open("", "pop", settings);
			form.target = "pop"
			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
			window.callbackPopup = callbackFunc;
		}

		function fileListModalPopup(attachCode, attachSubCode) {

			$.ajax({
				url: "/popupDownloadList",
				data: {
					attachCode: attachCode,
					attachSubCode: attachSubCode
				},
				type: 'POST',
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				//processData : false,
				//contentType : false,
				dataType: 'json',
				cache: false,
				success: function (result) {
					if (result.data.length > 0) {

						var modalDiv = document.createElement("div");
						modalDiv.id = "modalFileList";

						var headerDiv = document.createElement("div");
						//headerDiv.className = "";

						var headerDivTxt = document.createTextNode('첨부파일 조회 및 다운로드');

						var bodyDiv = document.createElement("div");
						bodyDiv.id = "modalFileListBody";

						var wrapDiv = document.createElement("div");
						wrapDiv.id = "wrapFileList"
						wrapDiv.className = "f-list";

						headerDiv.appendChild(headerDivTxt);

						modalDiv.appendChild(headerDiv);

						bodyDiv.appendChild(wrapDiv);

						modalDiv.appendChild(bodyDiv);

						document.body.appendChild(modalDiv);

						var element = document.getElementById('wrapFileList');


						for (var i = 0; i < result.data.length; i++) {
							//console.log('element', i, result.data[i]);
							//console.log(result.data[i]);
							element.innerHTML += "<div>"
								+ "<a href='#' onclick='uploadFileDownload(this); return false;'>" + result.data[i].fileName + "</a>"
								+ "<span>" + "(" + result.data[i].fileLength + ")" + "</span>"
								+ "<input name='fileName' type='hidden' value='" + result.data[i].fileName + "'>"
								+ "<input name='filePath' type='hidden' value='" + result.data[i].filePath + "'>"
								+ "<input name='attachSeq' type='hidden' value='" + result.data[i].attachSeq + "'>"
								+ "</div>";
						};

						element = document.getElementById('modalFileListBody');

						element.innerHTML += "<div class='btn-wrap-act'>"
							+ "<button type='button' id='closeFileModal' onclick='closeFileModal(); return false;' class='btn'>닫기</button>"
							+ "</div>";

						$('#modalFileList').jqxWindow({
							autoOpen: true,
							width: 500,
							height: 400,
							resizable: false, isModal: true, modalOpacity: 0.1,
							closeButtonSize: 0,
							cancelButton: $('#closeFileModal'),

						});

					} else {
						alert("첨부파일이 없습니다.");
						return;
					}

				}
			});
		}

		function uploadFileDownload(obj){

	    	  var filename = $(obj).parent().children('input[name=fileName]')[0].value;
	    	  var filePath = $(obj).parent().children('input[name=filePath]')[0].value;

	    	  var xhr = new XMLHttpRequest();
				xhr.open('POST', "/fileDownload");
				xhr.responseType = 'arraybuffer';
				xhr.onload = function () {
					if (this.status === 200) {

						var disposition = xhr.getResponseHeader('Content-Disposition');
						if (disposition && disposition.indexOf('attachment') !== -1) {
							var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
							var matches = filenameRegex.exec(disposition);
							if (matches != null && matches[1]) {
								filename = matches[1].replace(/['"]/g, '');
							}
						}
						var type = xhr.getResponseHeader('Content-Type');
						var blob = typeof File === 'function'
							? new File([this.response], filename, { type: type })
							: new Blob([this.response], { type: type });
						if (typeof window.navigator.msSaveBlob !== 'undefined') {
							// IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created.
							// These URLs will no longer resolve as the data backing the URL has been freed."
							window.navigator.msSaveBlob(blob, filename);
						} else {
							var URL = window.URL || window.webkitURL;
							var downloadUrl = URL.createObjectURL(blob);
							if (filename) {
								// use HTML5 a[download] attribute to specify filename
								var a = document.createElement("a");
								// safari doesn't support this yet
								if (typeof a.download === 'undefined') {
									window.location = downloadUrl;
								} else {
									a.href = downloadUrl;
									a.download = filename;
									document.body.appendChild(a);
									a.click();
								}
							} else {
								window.location = downloadUrl;
							}
							setTimeout(function () { URL.revokeObjectURL(downloadUrl); }, 100); // cleanup
						}
					}
				};
				xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
				//xhr.setRequestHeader('Content-type', 'application/json');
				xhr.send("fileName=" + filename+"&filePath=" + filePath);
	      }

		function closeFileModal() {

			const element = document.getElementById("modalFileList");
			element.remove();

		}

		function popOpenMember(id) {
			if (isEmpty(id)) return;

			$.ajax({
				url: "/viewMember",
				data: {
					userId: id
				},
				type: 'POST',
				dataType: 'json',
				cache: false,
				success: function (result) {
					//         	console.log(result);
					let title = "회원검색 - " + id;
					let contents = "";
					if (result == null) {
						alert('올바른 회원이 아닙니다.');
					} else {
						contents = '<div class="pop-body-wrap"><div class="stit-wrap"><h3>기본정보</h3></div><div class="view-wrap pop">';
						contents += '<div class="v-row"><div class="v-col-2">ID</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epLoginid, '') + '</div>';
						contents += '<div class="v-col-2">구분</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.gjMemtypeName, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2"><span class="star"></span>부서명</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.gjDeptname, '') + '</div>';
						contents += '<div class="v-col-2">부서코드</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.gjDeptcode, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">전체 부서명</div>';
						contents += '<div class="v-col-10">' + strEmpDefault(result.gjFdeptname, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">회원명</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epUsername, '') + '</div>';
						contents += '<div class="v-col-2">닉네임</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epNickname, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">회사명</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epCompname, '') + '</div>';
						contents += '<div class="v-col-2">부서명</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epDeptname, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">직급명</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epGrdname, '') + '</div>';
						contents += '<div class="v-col-2">부서코드</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epDeptid, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">회사전화</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epComptel, '') + '</div>';
						contents += '<div class="v-col-2">핸드폰</div>';
						contents += '<div class="v-col-4">' + strEmpDefault(result.epMobile, '') + '</div>';
						contents += '</div>';
						contents += '<div class="v-row"><div class="v-col-2">E-Mail</div>';
						contents += '<div class="v-col-10">' + strEmpDefault(result.epMail, '') + '</div>';
						contents += '</div></div>';
						contents += '<div class="stit-wrap"><h3>추가정보</h3></div><div class="view-wrap pop">';
						contents += '<div class="v-row"><div class="v-col-2">Memo</div>';
						contents += '<div class="v-col-10 member-popup-memo">' + strEmpDefault(result.gjMemo, '') + '</div>';
						contents += '</div>';
						contents += '</div>';
						contents += '<div class="btn-wrap-act">';
						contents += '<button type="button" id="cancelfPopup" class="btn">취소</button>';
						contents += '</div>';
						contents += '</div>';

						fnOpenContentsPopup(title, contents, 800, 460);
					}
				},
				error: {}
			});
		}

		function fnWinPopup(option, callbackFunc) {
			var url = option.url;
			var params = option.params;
			var win_popup;
			var width = option.width;
			var height = option.height;
			if (isEmpty(width)) width = 1000;
			if (isEmpty(height)) height = 600;
			var winl = (screen.width - width) / 2;
			var wint = (screen.height - height) / 2;

			var settings = 'height=' + height + ',';
			settings += 'width=' + width + ',';
			settings += 'top=' + wint + ',';
			settings += 'left=' + winl + ',';
			settings += 'scrollbars=no,';
			settings += 'location=no,';
			settings += 'resizable=no';

			var form = document.createElement("form");
			form.method = "POST";
			form.action = url;
			form.style.display = "none";

			for (var key in params) {
				var input = document.createElement("input");
				input.type = "hidden";
				input.name = key;
				input.value = params[key];
				form.appendChild(input);
			}

			window.open("", option.title, settings);
			form.target = option.title;

			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);

			if (!isEmpty(callbackFunc)) {
				window.callbackPopup = callbackFunc;
			}
		}

		function popOpenRequire(pageCode) {
			if (isEmpty(pageCode)) return;

			$.ajax({
				url: "/viewRequire",
				data: {
					pageCode: pageCode
				},
				type: 'POST',
				dataType: 'json',
				cache: false,
				success: function (result) {
					//         	console.log(result.data.contents);
					var data = result.data;
					if (data != null) {
						var _html = "";
						_html += "<table width='100%'><tr><td>" + replaceBrTag(data.contents) + "</td></tr></table>";

						fnOpenContentsPopup("주의사항", _html, 600, 450);
					}
				},
				error: {}
			});
		}

		function replaceBrTag(str) {
			if (str == undefined || str == null) {
				return "";
			}

			str = str.replace(/\r\n/ig, '<br>');
			//     str = str.replace(/\\n/ig, '<br>');
			//     str = str.replace(/\n/ig, '<br>');
			return str;
		}

		function swalAlert(msg, type) {
			swal({
				html: msg,
				icon: type,
				type: type,
				confirmButtonText: "확인",
			});
		}

		function swalRequired(txt) {
			swal({
                title: 'Warning',
                text: txt+"은(는) 필수입니다.",
                icon: 'info',
                confirmButtonText: '확인'
			});
		}

		function fnDownloadFormat(filename, url) {
			if( isEmpty(url) ) {
				url = "/excelDownload";
			}
			var xhr = new XMLHttpRequest();
			xhr.open('POST', url, true);
			xhr.responseType = 'arraybuffer';
			xhr.onload = function () {
				if (this.status === 200) {

					var disposition = xhr.getResponseHeader('Content-Disposition');
					if (disposition && disposition.indexOf('attachment') !== -1) {
						var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
						var matches = filenameRegex.exec(disposition);
						if (matches != null && matches[1]) {
							filename = matches[1].replace(/['"]/g, '');
						}
					}
					var type = xhr.getResponseHeader('Content-Type');
					var blob = typeof File === 'function'
						? new File([this.response], filename, { type: type })
						: new Blob([this.response], { type: type });
					if (typeof window.navigator.msSaveBlob !== 'undefined') {
						// IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created.
						// These URLs will no longer resolve as the data backing the URL has been freed."
						window.navigator.msSaveBlob(blob, filename);
					} else {
						var URL = window.URL || window.webkitURL;
						var downloadUrl = URL.createObjectURL(blob);
						if (filename) {
							// use HTML5 a[download] attribute to specify filename
							var a = document.createElement("a");
							// safari doesn't support this yet
							if (typeof a.download === 'undefined') {
								window.location = downloadUrl;
							} else {
								a.href = downloadUrl;
								a.download = filename;
								document.body.appendChild(a);
								a.click();
							}
						} else {
							window.location = downloadUrl;
						}
						setTimeout(function () { URL.revokeObjectURL(downloadUrl); }, 100); // cleanup
					}
				}
			};
			xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			//xhr.setRequestHeader('Content-type', 'application/json');
			xhr.send("filename=" + filename);

		}

		function menuPopoverCreate(pageCode) {
			if (isEmpty(pageCode)) return;

			$.ajax({
				url: "/viewRequire",
				data: {
					pageCode: pageCode
				},
				type: 'POST',
				dataType: 'json',
				cache: false,
				success: function (result) {
					var data = result.data;
					if (data != null) {
						var _html = "";
						_html += "<table width='100%'><tr><td>" + replaceBrTag(data.contents) + "</td></tr></table>";

						$('#menu_popover_content').html(_html);

						$('#menu_ico').css('display', 'block');


					}else {
						$('#menu_ico').css('display', 'none');
						$('#menu_popover').css('display', 'none');
					}
				},
				error: {}
			});
		}

		function menuPopoverSearch(pageCode, type) {
			if (isEmpty(pageCode)) return;

			$.ajax({
				url: "/viewRequire",
				data: {
					pageCode: pageCode
				},
				type: 'POST',
				dataType: 'json',
				cache: false,
				success: function (result) {
					var data = result.data;
					if (data != null) {
						var _html = "";
						_html += "<table width='100%'><tr><td>" + replaceBrTag(data.contents) + "</td></tr></table>";

						$('#menu_popover_content').html(_html);
						makePopover(type);
					}else {
					}
				},
				error: {}
			});
		}

		function makePopover(type) {
			if( "Y" == type ) {
				$(".ic_area").empty();
				$(".ic_area").append('<a id="menu_ico"><label class="ico"></label></a>');
			} else {
				$(".ic_area2").empty();
				$(".ic_area2").append('<a id="menu_ico"><label class="ico"></label></a>');
			}

			$("#menu_popover").jqxPopover({
				width: 600,
				height: 450,
				offset: { left: 230, top: 0 },
				theme: 'arctic',
				initContent: function(){
				},
				arrowOffsetValue: -230,
				title: "주의사항",
				showCloseButton: true,
				selector: $("#menu_ico")
			});
			if( "Y" == type ) $('#menu_ico').trigger('click');
		}

		/*
		TB_DOCU 테이블에서 doc_code 로 정보를 조회하여 상신 내용을 생성한다.
		*/
		function callApproval5DIVDocument(param) {
			if(isEmpty(param.subCode))param.subCode = "";
			$.ajax({
				type: "POST",
				url: "/approval5DIVDocument",
				dataType : "json",
				data: {
					docCode: param.docCode,
					inhtml: param.inhtml,
					signTitle: param.signTitle,
					menuId: param.menuId,
					subCode: param.subCode
				},
				success: (resData) => {
					var data = {docCode: resData.docCode, menuCode: resData.menuId, subCode:param.subCode }
					fnApprovalPopup(data, param.callback);
				},
				error : (request, status, error) => {
					alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}

		/*
		작성자 정보를 화면에서 보내 상신 내용을 생성한다.
		*/
		function callApproval5DIVDocumentEtc(param) {
			$.ajax({
				type: "POST",
				url: "/approval5DIVDocumentEtc",
				dataType : "json",
				data: {
					docCode: param.docCode,
					inhtml: param.inhtml,
					signTitle: param.signTitle,
					menuId: param.menuId,
					writeName: param.writeName,
					writeDeptname: param.writeDeptname,
					writeComptel: param.writeComptel,
					writeMobile: param.writeMobile,
				},
				success: (resData) => {
					var data = {docCode: resData.docCode, menuCode: resData.menuId, subCode:'' }
					fnApprovalPopup(data, param.callback);
				},
				error : (request, status, error) => {
					alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}

		/* 화면 내용으로 메일 발송시 receipVOList="1|aaa@aaa.aa^1|bbb@bbb.bb^" */
		function callEmptySendMail(param) {
			if(isEmpty(param.callback)) param.callback = function() {};

			$.ajax({
				type: "POST",
				url: "/callEmptySendMail",
				dataType : "json",
				data: {
					subject: param.subject,
					receipVOList: param.receipVOList,
					contents: param.contents,
				},
				success: (data) => {
					if( data.result == 'S' ) {
						param.callback();
					}else {
						swalAlert('메일 발송에 실패하였습니다.','error');
					}
				},
				error : (request, status, error) => {
					alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}

		function mobileSetCombo(itemVal, comboName, groupCode, url, code, codeName, placeHolder) {
			var control = $("#" + comboName);

			if (isEmpty(url)) url = "/commonCombo";
			if (isEmpty(placeHolder)) placeHolder = "";

			var param = {
					url: url,
					groupCode: groupCode,
			};

			$.ajax({
				type: "POST",
				url: param.url,
				dataType : "json",
				data: param,
				success: (data) => {
					if (placeHolder == 'A') { // 전체
						control.append('<option value="">전체</option>');
					} else if (placeHolder == 'S') {
						control.append('<option value="">선택</option>');
					}
					if (data.length > 0) {
						for (var i = 0; i < data.length; i++) {
							var selected = "";
							if( "cateName" == code ) {
								if(data[i].cateName == itemVal) selected = "selected";
								control.append('<option value="'+data[i].cateName+'" '+selected+'>'+data[i].cateName+'</option>');
							}else if ( "cateCode" == code ) {
								if(data[i].cateCode == itemVal) selected = "selected";
								control.append('<option value="'+data[i].cateCode+'" '+selected+'>'+data[i].cateName+'</option>');
							}else if ( "codeName" == code ) {
								if(data[i].codeName == itemVal) selected = "selected";
								control.append('<option value="'+data[i].codeName+'" '+selected+'>'+data[i].codeName+'</option>');
							}else {
								if(data[i].code == itemVal) selected = "selected";
								control.append('<option value="'+data[i].code+'" '+selected+'>'+data[i].codeName+'</option>');
							}
						}
					}
				},
				error : (request, status, error) => {
					alert("status : " + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}


	</script>