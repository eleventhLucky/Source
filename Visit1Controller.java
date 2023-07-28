package kr.co.selc.linc.web.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ResourceLoader;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.selc.linc.cmm.CommonUtils;
import kr.co.selc.linc.dto.CommonDTO;
import kr.co.selc.linc.dto.MemberDTO;
import kr.co.selc.linc.dto.RequireDTO;
import kr.co.selc.linc.dto.TB_ContDTO;
import kr.co.selc.linc.dto.TB_ContSignDTO;
import kr.co.selc.linc.dto.TB_DocuDTO;
import kr.co.selc.linc.dto.TB_DocuSubDTO;
import kr.co.selc.linc.dto.TB_DocuTmpDTO;
import kr.co.selc.linc.dto.TB_SignAdmDTO;
import kr.co.selc.linc.dto.TB_VisitorBlockDTO;
import kr.co.selc.linc.dto.TB_VisitorDTO;
import kr.co.selc.linc.dto.TB_VisitorSysLogDTO;
import kr.co.selc.linc.service.CommonService;
import kr.co.selc.linc.service.LuckyService;
import kr.co.selc.linc.service.RequireService;
import kr.co.selc.linc.service.SignService;
import kr.co.selc.linc.service.TableService;
import kr.co.selc.linc.service.Visit1Service;

@RestController
public class Visit1Controller extends BaseController  {
	@Value("${file.root.path}")
    public  String FILE_ROOT_PATH;

	@Autowired
	LuckyService svcLucky;


	@Autowired
	Visit1Service svcVisit1;

	@Autowired
	CommonService svcComm;

	@Autowired
	SignService svcSign;

	@Autowired
	TableService svcTable;

	@Autowired
	private RequireService requireService;


	String gcode = "g1011";

	@RequestMapping(value = "/visit1")
	public ModelAndView visit1() throws Exception {

		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode
			<!--#include file="./include/include_app_search.asp"-->

		 */

		ModelAndView mv = new ModelAndView();

		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
		String submit_type = listSign.get(0).getSignStatus();
		//String submit_contents = listSign.get(0).getContents().replace("\n", "<br>");
		//String submit_signcode = listSign.get(0).getSignCode();


		//jsp(html)로 갈때는 setViewName // class로 갈때는 setView
		mv.setViewName("visit1");
		mv.addObject("submit_type", submit_type);
		mv.addObject("visit1_opt8", submit_type.equals("1") ? "visit1_opt8_1" : "visit1_opt8_2");
		mv.addObject("submitDateText", submit_type.equals("1") ? "상신일" : "등록일");


		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/getCombo_visit1_opt3", method = { RequestMethod.POST })
	public Object getCombo_visit1_opt3(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
		String submit_type = listSign.get(0).getSignStatus();

		JSONArray jsonArray = new JSONArray();



		if(submit_type.equals("1")) {
			String[] code = {"10","11","13","12"};
			String[] codeName = {"9","1","3","2"};
			for(int i=0 ; i<4 ; i++)
			{
				JSONObject json = new JSONObject();
				json.put("code", code[i]);
				json.put("codeName", CommonUtils.get_appname(codeName[i]));
				jsonArray.add(json);
			}
		} else {
			List<CommonDTO> list = svcComm.selectComboCode((String)map.get("visit1_opt3"));
			for (CommonDTO item : list) {
				JSONObject json = new JSONObject();
				json.put("code", item.getCode());
				json.put("codeName", item.getCodeName());
				jsonArray.add(json);
			}
		}

		return jsonArray;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/getCombo_visit1_opt5", method = { RequestMethod.POST })
	public Object getCombo_visit1_opt5(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
		String submit_type = listSign.get(0).getSignStatus();

		JSONArray jsonArray = new JSONArray();

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("CODE_GROUP", "visit1_opt5");
		param.put("ATTRIBUTE1", "1");

		List<CommonDTO> list = svcComm.selectTbCommon(param);

		for (CommonDTO item : list) {
			JSONObject json = new JSONObject();
			json.put("code", item.getCode());
			json.put("codeName", item.getCodeName());
			jsonArray.add(json);
		}

		return jsonArray;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1Search", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit1Search(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		//아래 헤더 가져오는 내용 바뀌어야 함.
		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
		String submit_type = listSign.get(0).getSignStatus();

//		String UserID = "";
//		if(getAuthCode().equals("1")) UserID = CommonUtils.get_currUserID();
//		else if(getAuthCode().equals("0")) UserID = "DENINE";

		String pageNum = (String)map.get("pagenum");
		String pageSize = (String)map.get("pagesize");
		String excelYN = (String)map.get("excel");

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("GCODE"	, gcode);
//		param.put("USER_ID"	, UserID);

		svcVisit1.deleteDocumentList(param);

		if(!excelYN.equals("Y")) {
			param.put("PAGENUM", 	pageNum);
			param.put("PAGESIZE", 	pageSize);
		}

		param.put("SEARCHK0", 	(String)map.get("searchOpt0"));
		param.put("SEARCHK1", 	(String)map.get("searchOpt1"));
		param.put("SEARCHK2", 	(String)map.get("searchOpt2"));
		param.put("SEARCHK3", 	(String)map.get("searchOpt3"));
		param.put("SEARCHK11", 	(String)map.get("searchOpt11"));
		param.put("SEARCHK12", 	(String)map.get("searchOpt12"));
		param.put("SEARCHK13", 	(String)map.get("searchOpt13"));
		param.put("SEARCHK14", 	(String)map.get("searchOpt14"));
		param.put("SEARCHK5", 	(String)map.get("searchOpt5"));
		param.put("SEARCHK6", 	(String)map.get("searchOpt6"));
		param.put("SEARCHK7", 	(String)map.get("searchOpt7"));
		param.put("SEARCHK8", 	(String)map.get("searchOpt8"));
		param.put("SEARCHK9", 	(String)map.get("searchOpt9"));
		param.put("SEARCHK10", 	(String)map.get("searchOpt10"));

		List<TB_DocuDTO> list = svcVisit1.selectDocumentList(param);

		//JSONParser jsonParser = new JSONParser();
		JSONArray jsonArray = new JSONArray();
		int idx = Integer.parseInt(pageNum) * Integer.parseInt(pageSize);
		for (TB_DocuDTO item : list) {
			idx++;
			JSONObject json = new JSONObject();
			json.put("Ino", item.getIno());
			json.put("Idx", idx); // 순번
			json.put("DocCode", item.getDocCode()); //문서번호
			json.put("WriteName", item.getWriteName()); 	// 작성자
			json.put("ReqName", item.getReqName()); 		// 접견자
			json.put("AppDate", item.getAppDate() == null ? "": item.getAppDate().substring(0, 10));			// 상신일
			json.put("ReqDate", item.getReqDate() == null ? "": item.getRegDate().substring(0, 10));			// 신청일
			json.put("ValueSt3", item.getValueSt3());		// 방문유형
			json.put("ValueSt5", item.getValueSt5());		// 방문유형
			json.put("ValueSt6", item.getValueSt6());		// 접견장소

			String docTypeName = "";
			switch (item.getDocType()) {
				case "0": {
					switch (submit_type) {
						case "1": { docTypeName = "미상신"; break;}
						case "2": { docTypeName = "미등록"; break;}
						default:
							docTypeName = "결재불가";
						}
				}
				case "1": { docTypeName = CommonUtils.get_appname(item.getSsoStatus()); break;}
				case "2": { docTypeName = "등록"; break;}
				default:
					docTypeName = "Error";
			}
			json.put("DocType", item.getDocType());
			json.put("DocTypeName", docTypeName);	// 결재상태
			json.put("ValueDate", item.getValueDate1() + "~" + item.getValueDate2());	// 내방예약기간

			json.put("ValueSub1", item.getValueSub1());		// 내방객
			json.put("ValueSub2", item.getValueSub2());	// 업체명
			json.put("ValueSub3", item.getValueSub3());		// 내방차량
			json.put("ValueSub4", item.getValueSub4());	// 반입물품
			json.put("totalCount", item.getTotalCount());	// 반입물품

			jsonArray.add(json);

		}



		return jsonArray;
    }


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1View_visitor", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit1View_visitor(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("GCODE"	, gcode);
		param.put("DOC_CODE", 	(String)map.get("doc_code"));
		param.put("DOC_SUB_TYPE", "1");

		List<TB_DocuSubDTO> list = svcVisit1.selectDocumentSubList(param);
		for (TB_DocuSubDTO item : list) {
			JSONObject json = new JSONObject();

			json.put("ino", item.getIno());
			json.put("docCode", item.getDocCode()); //문서번호
			json.put("valueSt1", item.getValueSt1()); // 성명
			json.put("valueSt2", item.getValueSt2()); // 회사명
			json.put("valueSt3", item.getValueSt3()); // 직책
			json.put("valueSt4", item.getValueSt4()); // 연락처
			json.put("valueSt5", item.getValueSt5()); // 연락처
			json.put("valueSt6", item.getValueSt6()); // 연락처
			json.put("valueSt7", item.getValueSt7()); // 연락처
			json.put("valueSt8", item.getValueSt8()); // 연락처
			String valueSt5 = StringUtils.isBlank(item.getValueSt5()) ? "" : item.getValueSt5();
			String valueSt6 = StringUtils.isBlank(item.getValueSt6()) ? "" : item.getValueSt6();
			String valueSt7 = StringUtils.isBlank(item.getValueSt7()) ? "" : item.getValueSt7();
			String valueSt8 = StringUtils.isBlank(item.getValueSt8()) ? "" : item.getValueSt8();
			String carInfo =  valueSt5 + " " + valueSt6 + " " + valueSt7 + " " + valueSt8;
			json.put("carInfo", carInfo); // 차량번호
			json.put("valueSt9", item.getValueSt9()); //차량종류
			json.put("valueSt10", item.getValueSt10()); //차량모델
			jsonArray.add(json);
		}

		return jsonArray;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1View_item", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit1View_item(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("GCODE"	, gcode);
		param.put("DOC_CODE", 	(String)map.get("doc_code"));
		param.put("DOC_SUB_TYPE", "2");

		List<TB_DocuSubDTO> list = svcVisit1.selectDocumentSubList(param);
		for (TB_DocuSubDTO item : list) {
			JSONObject json = new JSONObject();

			json.put("ino", item.getIno());
			json.put("valueSt1", item.getValueSt1()); // 품명
			json.put("valueSt2", item.getValueSt2()); // 모델명(규격)
			json.put("valueSt3", item.getValueSt3()); // 제조번호(S/N)
			json.put("valueSt4", item.getValueSt4()); // 수량
			json.put("valueSt5", item.getValueSt5()); // 단위
			json.put("valueSt6", item.getValueSt6()); // 비고

			jsonArray.add(json);
		}

		return jsonArray;
    }

	@RequestMapping(value = "/visit1View", method = { RequestMethod.POST })
	public ModelAndView visit1View(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();// CommonUtils.getMenuID();

		ModelAndView mv = new ModelAndView();

		mv.addObject("sso_type", "12"); //include_app_group 에서 가져옴.

		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode
			<!--#include file="./include/include_app_asp.asp"-->
			<!--#include file="./include/include_app_parking.asp"-->

		 */
		String docTitle = "[LInC+] ";


		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리

		String submit_type = listSign.get(0).getSignStatus();
		String submit_contents = listSign.get(0).getContents().replace("\n", "<br>");
		//String submit_signcode = listSign.get(0).getSignCode();

		String submitTypeName = submit_type.equals("1") ? "미상신" : ( submit_type.equals("2") ? "미등록" : "결재불가");

		mv.addObject("submit_type", submit_type);
		mv.addObject("submit_contents", submit_contents);
		mv.addObject("submitTypeName", submitTypeName);	// 결재상태

		MemberDTO user = getSessionUser();//getSessionUser();
		//if( user.getEpUserid() == null ) user = CommonUtils.get_testUser();	//test 데이타 가져옴. 실제 로그인이 되면 필요없어짐.

		mv.addObject("mem_data", user);

		Map<String, Object>param = new HashMap<String, Object>();

		param.put("GCODE"	, gcode);
		param.put("SEARCHK0", 	"1");
		param.put("SEARCHK1", 	(String)map.get("DocCode"));
		List<TB_DocuDTO> list = svcVisit1.selectDocumentList(param);
		TB_DocuDTO indata = list.get(0);



		if(indata.getDocType().equals("0")) {
			switch (submit_type) {
				case "1": { mv.addObject("reportTitle", docTitle + "방문예약을 승인요청합니다."); break; }
				case "2": { mv.addObject("reportTitle", docTitle + "방문예약을 등록합니다."); break; }
				default: mv.addObject("reportTitle", docTitle + "결재가 불가능합니다.");

			}
		} else {
			mv.addObject("reportTitle", indata.getSsoTitle());
		}

		String docTypeName = "";
		switch (indata.getDocType()) {
			case "0": {
				switch (submit_type) {
					case "1": { docTypeName = "미상신"; break;}
					case "2": { docTypeName = "미등록"; break;}
					default:
						docTypeName = "결재불가";
					}
			}
			case "1": { docTypeName = CommonUtils.get_appname(indata.getSsoStatus()); break;}
			case "2": { docTypeName = "등록"; break;}
			default:
				docTypeName = "Error";
		}
		mv.addObject("docTypeName", docTypeName);	// 결재상태
		String reqTypeName = "";
		mv.addObject("indata", indata);


		return mv;
	}

	@RequestMapping(value = "/visit1Edit", method = { RequestMethod.POST })
	public ModelAndView visit1Edit(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode
			<!--#include file="./include/include_app_search.asp"-->

		 */
		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
		String submit_type = listSign.get(0).getSignStatus();

		TB_DocuDTO indata ;
		ModelAndView mv = new ModelAndView();

		mv.addObject("sso_type", "12"); //include_app_group 에서 가져옴. , g1011 은 12

		MemberDTO user = getSessionUser();//getSessionUser();

		String ino = (String)map.get("ino");
		String docCode = (String)map.get("docCode");

		if(StringUtils.isBlank(ino) && StringUtils.isBlank(docCode)) {
			indata = new TB_DocuDTO();
			indata.setWriteId(user.getEpLoginid());
			indata.setWriteName(user.getEpUsername());
			indata.setWriteDeptname(user.getEpDeptname());
			indata.setWriteComptel(user.getEpComptel());
			indata.setWriteMobile(user.getEpMobile());

			String tmpDocCode = "t" + svcComm.selectCurrDateTimeSpan().replaceAll("[^0-9]", "");
			indata.setDocCode(tmpDocCode);
			indata.setDocOldCode("");
			indata.setGroupCode(gcode);
			indata.setDocType("0");
			indata.setSsoCode("");
			indata.setValueOpt1("1");
			indata.setValueOpt2("2");
			indata.setReqType(user.getGjMemtype()); //mem_data(8)
			indata.setReqId(user.getEpLoginid()); //mem_data(0)
			indata.setReqEpid(user.getEpUserid());//mem_data(7)
			indata.setReqName(user.getEpUsername()); //mem_data(1)
			indata.setReqCompname(user.getEpCompname());//mem_data(9)
			if(StringUtils.isBlank(user.getGjDeptname()) || user.getGjDeptname().equals("0") )
				indata.setReqDeptname(user.getEpDeptname());
			else
				indata.setReqDeptname(user.getGjDeptname());
			indata.setReqGrdname(user.getEpGrdname());
			indata.setReqComptel(user.getEpComptel());
			indata.setReqMobile(user.getEpMobile());
			indata.setReqMail(user.getEpMail());

			indata.setWriteType(user.getGjMemtype()); //
			//indata.setWriteDate(""); // toDate
			indata.setWriteId(user.getEpLoginid()); // mem_data(0)
			indata.setWriteName(user.getEpUsername()); //  mem_data(1)
			//indata.setWriteDeptname(user.getEpDeptname()); // mem_data(2)
			indata.setWriteDeptname(indata.getReqDeptname());
			indata.setWriteGrdname("");
			indata.setWriteComptel(user.getEpComptel());// mem_data(3)
			indata.setWriteMobile(user.getEpMobile());// mem_data(4)

		} else {

			Map<String, Object>param = new HashMap<String, Object>();
			param.put("GCODE"		, gcode);
			if(StringUtils.isNotBlank(ino)) param.put("INO"			, ino);
			if(StringUtils.isNotBlank(docCode)) param.put("DOC_CODE"	, docCode);

			List<TB_DocuDTO> list = svcTable.selectTBDocu(param);
			indata = list.get(0);
			if(StringUtils.isBlank(ino)) ino = String.valueOf(indata.getIno());
		}

		if(StringUtils.isBlank(indata.getDocType()) || indata.getDocType().equals("0") )
			indata.setSsoStatus("9"); //indata.setSsoStatus(submit_type); by 방성혁 : 새로 생기는 문서는 getDocType이 0 일 때 무조건 미상신.

		mv.addObject("ino", ino);
		mv.addObject("indata", indata);

		//----------------------------------------	docTypeName 	----------------------------------------
		String docTypeName = "";
		switch (indata.getDocType()) {
			case "0": {
				switch (submit_type) {
					case "1": { docTypeName = "미상신"; break;}
					case "2": { docTypeName = "미등록"; break;}
					default:
						docTypeName = "결재불가";
					}
				break;
			}
			case "1": { docTypeName = CommonUtils.get_appname(indata.getSsoStatus()); break;}
			case "2": { docTypeName = "등록"; break;}
			default:
				docTypeName = "Error";
		}
		mv.addObject("docTypeName", docTypeName);	// 결재상태

		//----------------------------------------	외부방문정보 	----------------------------------------

		TB_DocuDTO exVisitData ;
		if(indata.getValueOpt4() == null ) indata.setValueOpt4("");
		if(indata.getValueSt20() == null ) indata.setValueSt20("");

		if(indata.getValueOpt4().equals("1") && StringUtils.isNotBlank(indata.getValueSt20()) ){

			String exVisitCode = indata.getValueSt20();
			String exVisitIno = "";
			String exVisitor = "";

			String vgcode = "g1012";
			String vdcode =  indata.getValueSt20();

			Map<String, Object>paramExVisit = new HashMap<String, Object>();
			paramExVisit.put("GCODE"		, vgcode);
			paramExVisit.put("VALUE_OPT4"	, "1");
			paramExVisit.put("VALUE_ST20"	, docCode);

			List<TB_DocuDTO> listExVisit = svcTable.selectTBDocu(paramExVisit);
			if(listExVisit == null || listExVisit.size() == 0) {
				exVisitCode = "<font color=darkred>" + indata.getValueSt20() + "</font>";
			} else {
				exVisitData = listExVisit.get(0);
				if(exVisitData.getDocCode().equals(vdcode)) { //tmpd=vdcode
					exVisitIno = String.valueOf(exVisitData.getIno());
					exVisitor = exVisitData.getValueSt11();

					if(exVisitData.getDocType().equals("0"))
						exVisitCode = "<font color=darkgreen>" + indata.getValueSt20() + "</font>";
					else
						exVisitCode = "<font color=darkblue>" + indata.getValueSt20() + "</font>";

				} else {
					exVisitCode = "<font color=darkred>" + indata.getValueSt20() + "</font>";
				}

			}

			mv.addObject("exVisitIno"	, exVisitIno);  //tmpv1
			mv.addObject("exVisitCode"	, exVisitCode);  //tmpv0
			mv.addObject("exVisitor"	, exVisitor);	// tmpv3
		}



		return mv;
	}


	@SuppressWarnings("unchecked")
	@PostMapping("visit1Edit_Save")
    @ResponseBody
    public String visit1Edit_Save(@RequestBody TB_DocuDTO data ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		Map<String, Object>param = new HashMap<String, Object>();

		param.put("GROUP_CODE", 	"g1011");
		param.put("TMP_TYPE", 	"1");

		MemberDTO user = getSessionUser();//getSessionUser();

		int locationRealCode = 10;
		String location = data.getValueSt5();
		String locationReal = "";

		List<TB_DocuTmpDTO> list = svcTable.selectTBDocuTmp(param);//eleventh cate에서
		if(list.size() > 0) {

			if(location.equals(list.get(0).getValueSt1()) ){
				locationReal = list.get(0).getValueSt1();
				locationRealCode = 11;
			} else if(location.equals(list.get(0).getValueSt2()) ){
				locationReal = list.get(0).getValueSt2();
				locationRealCode = 12;
			} else if(location.equals(list.get(0).getValueSt3()) ){
				locationReal = list.get(0).getValueSt3();
				locationRealCode = 13;
			} else if(location.equals(list.get(0).getValueSt4()) ){
				locationReal = list.get(0).getValueSt4();
				locationRealCode = 14;
			}
		}


		data.setGroupCode("g1011");
		data.setValueSt7(locationReal);
		data.setValueSt8(String.valueOf(locationRealCode));

		//data.setReqDate(""); //indata8 , toDate
		data.setWriteType(user.getGjMemtype()); 
		//data.setWriteDate(""); //indata21, toDate
		data.setWriteId(user.getEpLoginid()); //indata22, mem_data(0)
		data.setWriteName(user.getEpUsername()); //indata23,  mem_data(1)
		data.setWriteDeptname(user.getEpDeptname()); //indata24, mem_data(2)
		data.setWriteGrdname("");//indata25
		data.setWriteComptel(user.getEpComptel());//idnata26, mem_data(3)
		data.setWriteMobile(user.getEpMobile());//indata27, mem_data(4)




		if(data.getIno() > 0) { //update

			svcVisit1.updateVisit1Edit(data);


		} else { //insert
			data.setDocType("0");
			//data.setRegDate(""); //indata28, toData
			data.setRegId(user.getEpLoginid());//indata29, mem_data(0)
			data.setRegName(user.getEpUsername());//indata30, mem_data(1)

			data.setDocCode(svcVisit1.insertVisit1Edit(data));

		}

		return data.getDocCode();
    }


	@RequestMapping(value = "/frm_visit2_visitor_list")
	public ModelAndView frm_visit2_visitor_list(@RequestParam Map<String, Object> map) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();

		String docCode = (String)map.get("docCode");
		String rnx = (String)map.get("rnx");
		String valueDate2 = (String)map.get("valueDate2");

		ModelAndView mv = new ModelAndView();

		mv.addObject("docCode", docCode);
		mv.addObject("rnx", rnx);

		String currDate = svcComm.selectCurrDate();

		if(StringUtils.isNotBlank(valueDate2)) {
			if(currDate.compareTo(valueDate2) == 1) {
				mv.addObject("possibleInout", "F");
			} else {
				mv.addObject("possibleInout", "T");
			}
		} else {
			mv.addObject("possibleInout", "T"); //frm_visit2_visitor_list 에서 방문처리 하면 못 들어옴.
		}

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("GROUP_CODE", 	"c2002");
		param.put("STATUS", 	"1");

		List<TB_ContDTO> listCont = svcTable.selectTbCont(param);
		mv.addObject("contData", listCont.get(0));

		param.clear();
		param.put("DOC_CODE", docCode);
		param.put("GROUP_CODE", 	"g1011");
		param.put("DOC_SUB_TYPE", 	"1");

		List<TB_DocuSubDTO> listSub = svcTable.selectTBDocuSub(param);
		mv.addObject("listSub", listSub);

		//visitBlock 이 listSub 만큼 만들어짐.
		List<TB_VisitorBlockDTO> listBlock = new ArrayList<TB_VisitorBlockDTO>();
		List<String> listContSignCnt = new ArrayList<String>();
		List<String> listchkIn = new ArrayList<String>();
		List<String> listchkOut = new ArrayList<String>();

		for (TB_DocuSubDTO indata :listSub) {

			// visitorCode 가져오기 - start
			param.clear();
			param.put("VISITOR_NAME", 	indata.getValueSt1());
			if(StringUtils.isNotBlank(indata.getValueSt4())) param.put("VISITOR_TEL", 	indata.getValueSt4());

			List<TB_VisitorDTO> listVisitor = svcTable.selectTbVisitor(param);
			//임시로 VisitorCode를 valueTxt1 에 담아감.
			if(listVisitor.size() > 0) indata.setValueTxt1(listVisitor.get(0).getVisitorCode());
			// visitorCode 가져오기 - end

			String blockName = indata.getValueSt1();
			String blockTel = indata.getValueSt4();
			String chkIn = "0";
			String chkOut = "0";

			//asis : gen_htel
			if(rnx.equals("1") && StringUtils.isNotBlank(blockTel)) {
				String[] tel = blockTel.split("-");
				if(tel.length >= 3) {
					tel[1] = "****";
					indata.setValueSt4(String.join("-", tel));
				}
			}

			if(StringUtils.isNotBlank(blockName)) {
				param.clear();
				param.put("BLOCK_NAME", 	blockName);
				if(StringUtils.isNotBlank(blockTel)) param.put("BLOCK_TEL", 	blockTel);

				List<TB_VisitorBlockDTO> list = svcTable.selectTbVisitorBlock(param);
				if(list.size() > 0) listBlock.add(list.get(0));
			}


			String userid = indata.getValueLt1();
			if(StringUtils.isNotBlank(userid)) {
				param.clear();
				param.put("OLD_CODE", 	listCont.get(0).getOldCode());
				param.put("USER_TYPE", 	"2");
				param.put("USER_ID", 	userid);
				param.put("STATUS", 	"1");

				List<TB_ContSignDTO> list = svcTable.selectTbContSign(param);
				if(list != null && list.size() > 0) listContSignCnt.add("1");
				else listContSignCnt.add("0");
			}


			if(menuCode.equals("010101")) chkIn = "1";// 보안 쪽에서 들어오면 버튼 안생기게. //단순 조회가 방문 체크 안되게 함.
			else {
				if(StringUtils.isNotBlank(indata.getValueDate3()) || !rnx.equals("1")) chkIn = "1"; //기 방문일자가 있으면 1로 처리
				else {
					if(!indata.getValueDate1().substring(0, 10).equals(indata.getValueDate2().substring(0, 10))) chkIn = "0"; //신청기간이 장기간일경우 0 으로 처리
					if(chkIn.equals("0") && svcComm.selectCurrDate().compareTo(indata.getValueDate2().substring(0, 10)) == 1) chkIn = "1";// 장기간이면서 방문종료일이 작을 때 : 1
					if(StringUtils.isNotBlank(indata.getValueDate3()) && chkIn.equals("0") && svcComm.selectCurrDate().compareTo(indata.getValueDate3().substring(0, 10)) == -1) chkIn = "1";// 기방문일자가 오늘날짜보다 클 때 : 1
				}
			}
			listchkIn.add(chkIn);

			if(menuCode.equals("010101")) chkOut = "1";// 보안 쪽에서 들어오면 버튼 안생기게. //단순 조회가 방문 체크 안되게 함.
			else {
				if(StringUtils.isNotBlank(indata.getValueDate4()) || !rnx.equals("1")) chkOut = "1"; //기 출문일자가 있으면 1로 처리
				else {
					if(!indata.getValueDate1().substring(0, 10).equals(indata.getValueDate2().substring(0, 10))) chkOut = "0"; //신청기간이 장기간일경우 0 으로 처리
					if(chkIn.equals("0") && svcComm.selectCurrDate().compareTo(indata.getValueDate2().substring(0, 10)) == 1) chkOut = "1";// 장기간이면서 방문종료일이 작을 때 : 1
					if(StringUtils.isNotBlank(indata.getValueDate4()) && chkIn.equals("0") && svcComm.selectCurrDate().compareTo(indata.getValueDate3().substring(0, 10)) == -1) chkOut = "1";// 기방문일자가 오늘날짜보다 클 때 : 1
				}
			}
			listchkOut.add(chkOut);
		}

		mv.addObject("listBlock", listBlock);
		mv.addObject("listContSignCnt", listContSignCnt);
		mv.addObject("listchkIn", listchkIn);
		mv.addObject("listchkOut", listchkOut);

		mv.setViewName("frm_visit2_visitor_list");

		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1Edit_getVisitorBlock", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit1Edit_getVisitorBlock(@RequestParam Map<String, Object> map) throws Exception {
		JSONArray jsonArray = new JSONArray();

		String jsonStr = map.get("jsondata").toString();

		JSONParser jsonParser = new JSONParser();
		Object obj = jsonParser.parse(jsonStr);
		JSONObject jsonObject = new JSONObject();

		JSONArray jsonObjArr = (JSONArray)obj;
		for (Object item : jsonObjArr) {
			JSONObject jsonLineItem = (JSONObject) item;
			Map<String, Object>param = new HashMap<String, Object>();

			param.put("BLOCK_NAME", 	jsonLineItem.get("valueSt1").toString());
			param.put("BLOCK_TEL", 	jsonLineItem.get("valueSt4").toString());
			List<TB_VisitorBlockDTO> list = svcTable.selectTbVisitorBlock(param);
			if(list.size() > 0) {
		        JSONObject json = new JSONObject();
		        json.put("blockName", list.get(0).getBlockName());
		        json.put("blockTel", list.get(0).getBlockTel());
		        jsonArray.add(json);
			}
		}

		return jsonArray;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/frm_visit2_visitor_list_visitorSysLog", method = { RequestMethod.POST })
    @ResponseBody
    public Object frm_visit2_visitor_list_visitorSysLog(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("DOC_CODE", 	(String)map.get("doc_code"));

		int idx = 0;
		List<TB_VisitorSysLogDTO> list = svcVisit1.selectVisitorSysLog(param);
		for (TB_VisitorSysLogDTO item : list) {
			idx++;

			JSONObject json = new JSONObject();
			json.put("Idx", idx); // 순번
			json.put("valueSt1", item.getValueSt1()); // 내방객명
			json.put("valueSt2", item.getValueSt2()); // 회사명
			json.put("valueSt3", item.getValueSt3()); // 직책명
			json.put("valueSt4", item.getValueSt4()); // 연락처
			String carInfo =  item.getValueSt5() + " " + item.getValueSt6() + " " + item.getValueSt7() + " " + item.getValueSt8();
			json.put("carInfo", carInfo); // 차량번호
			String visitDt = item.getValueDate4()  + " " + item.getValueDate3();
			json.put("visitDt", visitDt); // 최근방문일
			json.put("valueLt8", item.getValueLt8()); // 표찰
			json.put("regName", item.getRegName()); // 접견자
			jsonArray.add(json);
		}

		return jsonArray;
    }

	@RequestMapping(value = "/frm_visit2_goods_list")
	public ModelAndView frm_visit2_goods_list(@RequestParam Map<String, Object> map) throws Exception {

		String docCode = (String)map.get("docCode");
		String rnx = (String)map.get("rnx");
		String valueOpt2 = (String)map.get("valueOpt2");

		ModelAndView mv = new ModelAndView();

		mv.addObject("docCode", docCode);
		mv.addObject("rnx", rnx);

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("DOC_CODE", docCode);
		param.put("GROUP_CODE", 	"g1011");
		param.put("DOC_SUB_TYPE", 	"2");

		List<TB_DocuSubDTO> listSub = svcTable.selectTBDocuSub(param);
		mv.addObject("listSub", listSub);

		mv.addObject("docCode", docCode);
		mv.addObject("rnx", rnx);
		mv.addObject("valueOpt2", valueOpt2);

		mv.setViewName("frm_visit2_goods_list");

		return mv;
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/update_frm_visit2_goods_list", method = { RequestMethod.POST })
    @ResponseBody
    public Object update_frm_visit2_goods_list(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		String currUrl = (String)map.get("currUrl");
		String joinStr = (String)map.get("joinStr");


		MemberDTO user = getSessionUser();//getSessionUser();

		String cntmps =  user.getEpUsername() + "/" + user.getEpGrdname() + "/" + user.getGjDeptname() + "/" + user.getEpCompname()  + "/" + currUrl;
 						//mem_data(1) & "/" & mem_data(10) & "/" & mem_data(13) & "/" & mem_data(9) & " (" & request.servervariables("remote_addr") & ")"

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("USER_INFO", 	cntmps);
		param.put("INO", 	joinStr);

		svcVisit1.updateDocuSubGoods(param);

		return jsonArray;
    }


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/update_frm_visit2_visitor_list", method = { RequestMethod.POST })
    @ResponseBody
    public Object update_frm_visit2_visitor_list(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		String odr_type = map.get("odr_type").toString();
		String currUrl = map.get("currUrl").toString();
		String[] inoData = map.get("inoData").toString().split(",");
		String[] labelData = map.get("labelData").toString().split(",");
		
		MemberDTO user = getSessionUser();//getSessionUser();

		String cntmps =  user.getEpUsername() + "/" + user.getEpGrdname() + "/" + user.getGjDeptname() + "/" + user.getEpCompname()  + "/" + currUrl;
							//mem_data(1) & "/" & mem_data(10) & "/" & mem_data(13) & "/" & mem_data(9) & " (" & request.servervariables("remote_addr") & ")"

		Map<String, Object>param = new HashMap<String, Object>();

		for (int i = 0; i < inoData.length; i++) {
			param.put("USER_INFO"	, 	cntmps);
			param.put("INO"			, 	inoData[i]);
			param.put("VISIT_LABEL"	, 	labelData[i]);
			

			if("In".equals(odr_type)) {
				String[] idcardData = map.get("idcardData").toString().split(",");
				param.put("VISIT_IDCARD"	, 	idcardData[i]);
				svcVisit1.updateVisitInfoIn(param);
			} else {
				svcVisit1.updateVisitInfoOut(param);
			}

		}



		return jsonArray;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/deleteVisit1View", method = { RequestMethod.POST })
    @ResponseBody
    public Object deleteVisit1View(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();

		String doc_code = map.get("doc_code").toString();
		String ino = map.get("ino").toString();

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("DOC_CODE"	, 	doc_code);
		param.put("INO"			, 	ino);

		svcVisit1.deleteDocument(param);

		return jsonArray;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/reuseVisit1View", method = { RequestMethod.POST })
    @ResponseBody
    public String reuseVisit1View(@RequestParam Map<String, Object> map ) throws Exception {

		String old_doc_code = map.get("old_doc_code").toString();
		MemberDTO user = getSessionUser();//getSessionUser();


		Map<String, Object>param = new HashMap<String, Object>();
		param.put("OLD_DOC_CODE", 	old_doc_code);
		param.put("MEM_DATA0"	, user.getEpLoginid());
		param.put("MEM_DATA1"	, user.getEpUsername());
		param.put("MEM_DATA2"	, user.getEpDeptname());
		param.put("MEM_DATA3"	, user.getEpComptel());
		param.put("MEM_DATA4"	, user.getEpMobile());
		param.put("MEM_DATA8"	, user.getGjMemtype());

		String doc_code = svcVisit1.insertReuse(param);

		return doc_code;
    }

	@SuppressWarnings("unchecked")
	@PostMapping(value="/saveVisit1Edit_visitor")
    @ResponseBody
    public String saveVisit1Edit_visitor(@RequestParam Map<String, Object> map ) throws Exception {

		Map<String, Object>param = new HashMap<String, Object>();

		String ino = map.get("ino").toString();
		String docCode = map.get("docCode").toString();
		String valueSt1 = map.get("valueSt1").toString();
		String valueSt2 = map.get("valueSt2").toString();
		String valueSt3 = map.get("valueSt3").toString();
		String valueSt4 = map.get("valueSt4").toString();
		String valueSt5 = map.get("valueSt5").toString();
		String valueSt6 = map.get("valueSt6").toString();
		String valueSt7 = map.get("valueSt7").toString();
		String valueSt8 = map.get("valueSt8").toString();
		String valueSt9 = map.get("valueSt9").toString();
		String valueSt10 = map.get("valueSt10").toString();
		String valueLt1 = map.get("valueLt1").toString();

		param.put("INO"	, ino);
		param.put("DOC_CODE"	, docCode);
		param.put("SUB_TYPE"	, "1");
		param.put("VALUE_ST1"	, valueSt1);
		param.put("VALUE_ST2"	, valueSt2);
		param.put("VALUE_ST3"	, valueSt3);
		param.put("VALUE_ST4"	, valueSt4);
		param.put("VALUE_ST5"	, valueSt5);
		param.put("VALUE_ST6"	, valueSt6);
		param.put("VALUE_ST7"	, valueSt7);
		param.put("VALUE_ST8"	, valueSt8);
		param.put("VALUE_ST9"	, valueSt9);
		param.put("VALUE_ST10"	, valueSt10);
		param.put("VALUE_LT1"	, valueLt1);

		MemberDTO user = getSessionUser();//getSessionUser();

		param.put("VISITOR_CODE", 	valueLt1);
		param.put("MEM_DATA0"	, user.getEpLoginid());
		param.put("MEM_DATA1"	, user.getEpUsername());

		ino = svcVisit1.saveVisit1Edit_visitor(param);

		return ino;
    }

	@SuppressWarnings("unchecked")
	@PostMapping(value="/visit1Edit_VisitorSearch")
    @ResponseBody
    public Object visit1Edit_VisitorSearch(@RequestParam Map<String, Object> map ) throws Exception {

		String searchType = (String)map.get("cboPopVisit1SearchType");
		String searchText = (String)map.get("txtPopVisitor");

		Map<String, Object>param = new HashMap<String, Object>();
		param.put("STATUS"	, "1");
		switch (searchType) {
		case "1": { param.put("VISITOR_NAME"	, searchText); break; }
		case "2": { param.put("VISITOR_COMPNAME"	, searchText); break; }
		case "3": { param.put("VISITOR_GRDNAME"	, searchText); break; }
		case "4": { param.put("VISITOR_TEL"	, searchText); break; }

		}

		List<TB_VisitorDTO> list = svcTable.selectTbVisitor(param);

		return list;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1Edit_deleteVisitor")
    @ResponseBody
    public String visit1Edit_deleteVisitor(@RequestParam Map<String, Object> map  ) throws Exception {

		String inoData = (String)map.get("inoData");
		if(StringUtils.isNotBlank(inoData)) {
			Map<String, Object>param = new HashMap<String, Object>();
			param.put("INO_LIST"	, inoData);
			map.put("groupCode",gcode);
			svcVisit1.deleteDocumentSub(param);
		}
		return "";
    }

	@SuppressWarnings("unchecked")
	@PostMapping(value="/saveVisit1Edit_item")
    @ResponseBody
    public String saveVisit1Edit_item(@RequestParam Map<String, Object> map ) throws Exception {

		Map<String, Object>param = new HashMap<String, Object>();

		String ino = map.get("ino").toString();
		String docCode = map.get("docCode").toString();
		String valueSt1 = map.get("valueSt1").toString();
		String valueSt2 = map.get("valueSt2").toString();
		String valueSt3 = map.get("valueSt3").toString();
		String valueSt4 = map.get("valueSt4").toString();
		String valueSt5 = map.get("valueSt5").toString();
		String valueSt6 = map.get("valueSt6").toString();

		param.put("INO"	, ino);
		param.put("SUB_TYPE"	, "2");
		param.put("DOC_CODE"	, docCode);
		param.put("VALUE_ST1"	, valueSt1);
		param.put("VALUE_ST2"	, valueSt2);
		param.put("VALUE_ST3"	, valueSt3);
		param.put("VALUE_ST4"	, valueSt4);
		param.put("VALUE_ST5"	, valueSt5);
		param.put("VALUE_ST6"	, valueSt6);

		MemberDTO user = getSessionUser();//getSessionUser();

		param.put("MEM_DATA0"	, user.getEpLoginid());
		param.put("MEM_DATA1"	, user.getEpUsername());

		ino = svcVisit1.saveVisit1Edit_item(param);

		return ino;
    }

	@Autowired
	private ResourceLoader resourceLoader;

	@SuppressWarnings("unchecked")
	@PostMapping(value="/saveSignDocument")
    @ResponseBody
	public String saveSignDocument(HttpServletRequest req, @RequestParam Map<String, Object> map ) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();

		String docCode = map.get("docCode").toString();
		//String inhtml = map.get("inhtml").toString(); //보통은 가져온 것을 뿌리지만 jqxgrid 때문에 불가능.

		param.put("DOC_CODE"		, docCode);
		List<TB_DocuDTO> list = svcTable.selectTBDocu(param);
		TB_DocuDTO indata = list.get(0);

		String filePath = "classpath:static/html/template/visit1approval.html";
		InputStream inputStream = resourceLoader.getResource(filePath).getInputStream();
		String htmlString = FileCopyUtils.copyToString(new InputStreamReader(inputStream,"UTF-8"));

		Document doc = Jsoup.parse(htmlString);

		doc.getElementById("indata_writeName").text(indata.getWriteName());//성명
		doc.getElementById("indata_writeDeptname").text(indata.getWriteDeptname()+"");//부서명
		doc.getElementById("indata_writeComptel").text(indata.getWriteComptel()+"");//전화번호
		doc.getElementById("indata_writeMobile").text(indata.getWriteMobile()+"");//핸드폰

		doc.getElementById("indata_docCode").text(indata.getDocCode());//문서번호
		doc.getElementById("indata_ssoStatus").text(CommonUtils.get_appname(indata.getSsoStatus()));//결재상태
		doc.getElementById("indata_reqTypeName").val(indata.getReqTypeName());//접견자
		doc.getElementById("indata_reqName").val(indata.getReqName()+"");//
		doc.getElementById("indata_reqDeptname").text(indata.getReqDeptname()+"");//부서명
		doc.getElementById("indata_reqComptel").text(indata.getReqComptel()+"");//전화번호
		doc.getElementById("indata_reqMobile").text(indata.getReqMobile()+"");//핸드폰
		doc.getElementById("indata_valueDate1").text(indata.getValueDate1()+"");//방문기간
		doc.getElementById("indata_valueDate2").text(indata.getValueDate2()+"");//
		doc.getElementById("indata_valueOpt1").text(indata.getValueOpt1().equals("1") ? "있음" : "없음");//차량
		doc.getElementById("indata_valueSt3").text(indata.getValueSt3());//방문유형
		doc.getElementById("indata_valueSt4").text(indata.getValueSt4());//방문목적
		doc.getElementById("indata_valueLt1").text(indata.getValueLt1()+"");//방문상세목적
		doc.getElementById("indata_valueOpt2").text(indata.getValueOpt2().equals("1") ? "있음" : "없음");//반입물품
		doc.getElementById("indata_valueSt5").text(indata.getValueSt5());//방문장소
		doc.getElementById("indata_valueSt6").text(indata.getValueSt6());//접견장소

		param.clear();
		param.put("pageCode", getCurrentMenuId());
		RequireDTO requireDto = requireService.selectTbRequireContents(param);

		if( StringUtils.isNotBlank(requireDto.getContents()) ) {
			doc.getElementById("precautionsAppr").html(requireDto.getContents());
		}

		param.clear();
		param.put("GCODE"	, gcode);
		param.put("DOC_CODE", 	docCode);
		param.put("DOC_SUB_TYPE", "1");

		List<TB_DocuSubDTO> listVisitor = svcVisit1.selectDocumentSubList(param);

		Elements mainWrap = doc.select(".divMainVisit");

		if(listVisitor.size() > 0) {

			String inhtml = ""
					+ "	   <div class='stit-wrap'>\r\n"
					+ "        <h3>내방객정보</h3>\r\n"
					+ "    </div>\r\n"
					+ "    <div id='divVisitor' class='view-wrap'>\r\n"
					+ "        <table summary='내방객정보'>\r\n"
					+ "            <caption>내방객정보</caption>\r\n"
					+ "            <colgroup>\r\n"
					+ "                <col width='7%'>\r\n"
					+ "                <col width=''>\r\n"
					+ "                <col width='7%'>\r\n"
					+ "                <col width=''>\r\n"
					+ "                <col width=''>\r\n"
					+ "                <col width=''>\r\n"
					+ "                <col width='7%'>\r\n"
					+ "                              \r\n"
					+ "            </colgroup>\r\n"
					+ "            <tbody>\r\n"
					+ "                <tr>\r\n"
					+ "                    <th class='cen'>성명</th>\r\n"
					+ "                    <th class='cen'>회사명</th>\r\n"
					+ "                    <th class='cen'>직책</th>\r\n"
					+ "                    <th class='cen'>연락처</th>\r\n"
					+ "                    <th class='cen'>차량번호</th>\r\n"
					+ "                    <th class='cen'>차량종류</th>\r\n"
					+ "                    <th class='cen'>차량모델</th>                                                                                                                                         \r\n"
					+ "                </tr>                            \r\n";


			for (TB_DocuSubDTO item : listVisitor) {
				String carInfo =  item.getValueSt5() + " " + item.getValueSt6() + " " + item.getValueSt7() + " " + item.getValueSt8();

				inhtml = inhtml + ""
						+ "                <tr>\r\n"
						+ "                    <td>" + item.getValueSt1() + "</td>\r\n" //성명
						+ "                    <td>" + item.getValueSt2() + "</td>\r\n" 		//회사명
						+ "                    <td>" + item.getValueSt3() + "</td>\r\n"  			//직책
						+ "                    <td>" + item.getValueSt4() + "</td>\r\n"	//연락처
						+ "                    <td>" + carInfo + "</td>\r\n"	//차량번호
						+ "                    <td>" + item.getValueSt9() + "</td>\r\n"			//차량종류
						+ "                    <td>" + item.getValueSt10() + "</td> \r\n"			//차량모델
						+ "                </tr> \r\n";

			}


			inhtml =  inhtml + ""
					+ "                </tbody>\r\n"
					+ "            </table>           \r\n"
					+ "    </div>  ";

			mainWrap.append(inhtml);

		}

		param.clear();
		param.put("GCODE"	, gcode);
		param.put("DOC_CODE", 	docCode);
		param.put("DOC_SUB_TYPE", "2");

		List<TB_DocuSubDTO> listItem = svcVisit1.selectDocumentSubList(param);

		if(listItem.size() > 0) {

			String inhtml = ""
					+ "	   <div class='stit-wrap'>\r\n"
					+ "        <h3>반입물품</h3>\r\n"
					+ "    </div>\r\n"
					+ "    <div id='divVisitor' class='view-wrap'>\r\n"
					+ "        <table summary='내방객정보'>\r\n"
					+ "            <caption>내방객정보</caption>\r\n"
					+ "            <colgroup>\r\n"
					+ "                <col width='15%'>\r\n"
					+ "                <col width='20%'>\r\n"
					+ "                <col width=''>\r\n"
					+ "                <col width='10%'>\r\n"
					+ "                <col width='10%'>\r\n"
					+ "                              \r\n"
					+ "            </colgroup>\r\n"
					+ "            <tbody>\r\n"
					+ "                <tr>\r\n"
					+ "                    <th class='cen'>품명</th>\r\n"
					+ "                    <th class='cen'>모델명(규격)</th>\r\n"
					+ "                    <th class='cen'>제조번호(S/N)</th>\r\n"
					+ "                    <th class='cen'>단위</th>\r\n"
					+ "                    <th class='cen'>비고</th>                                                                                                                                         \r\n"
					+ "                </tr>                            \r\n";


			for (TB_DocuSubDTO item : listItem) {

				inhtml = inhtml + ""
						+ "                <tr>\r\n"
						+ "                    <td>" + item.getValueSt1() + "</td>\r\n"
						+ "                    <td>" + item.getValueSt2() + "</td>\r\n"
						+ "                    <td>" + item.getValueSt3() + "</td>\r\n"
						+ "                    <td>" + item.getValueSt5() + "</td>\r\n"
						+ "                    <td>" + item.getValueSt6() + "</td> \r\n"
						+ "                </tr> \r\n";

			}


			inhtml =  inhtml + ""
					+ "                </tbody>\r\n"
					+ "            </table>           \r\n"
					+ "    </div>  ";

			mainWrap.append(inhtml);

		}

		param.clear();
		param.put("DOC_CODE"	, docCode);
		param.put("SIGN_TITLE"	, "[LInC+] 방문예약을 승인요청합니다.");
		param.put("SIGN_BODY"	, doc.toString());
		svcVisit1.insertSignDocu(param);

		return docCode;
	}


	@SuppressWarnings("unchecked")
	@PostMapping(value="/saveParking13")
    @ResponseBody
	public String saveParking13(HttpServletRequest req, @RequestParam Map<String, Object> map ) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();

		String docCode = map.get("docCode").toString();
		//String inhtml = map.get("inhtml").toString(); //보통은 가져온 것을 뿌리지만 jqxgrid 때문에 불가능.

		param.put("DOC_CODE"		, docCode);
		List<TB_DocuDTO> list = svcTable.selectTBDocu(param);
		TB_DocuDTO docu = list.get(0);

		param.put("DOC_SUB_TYPE"		, "1");
		List<TB_DocuSubDTO> listSub = svcTable.selectTBDocuSub(param);
		TB_DocuSubDTO docuSub = listSub.get(0);


		param.clear();
		param.put("acPlate1"			, docuSub.getValueSt5());
		param.put("acPlate3"			, docuSub.getValueSt6() + docuSub.getValueSt8());
		param.put("acUserName"			, docuSub.getValueSt1());
		param.put("acCarModel1"			, docuSub.getValueSt10());
		param.put("acTelNo1"			, docuSub.getValueSt4());
		param.put("dtValidStartDate"	, docuSub.getValueDate1());
		param.put("dtValidEndDate"		, docuSub.getValueDate2());
		String acReserved2 = docu.getValueSt4() + "(" + docu.getValueSt11() + ")" + docu.getReqName();
		param.put("acReserved2"			, acReserved2);

		svcVisit1.insertCustdef(param);

		return "";
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping(value="/sendVisit1Mesage")
    @ResponseBody
    public String sendVisit1Mesage(@RequestParam Map<String, Object> map ) throws Exception {

		Map<String, Object>param = new HashMap<String, Object>();

		
		String docCode = map.get("docCode").toString();
		
		param.put("DOC_CODE"		, docCode);
		List<TB_DocuDTO> list = svcTable.selectTBDocu(param);
		TB_DocuDTO docu = list.get(0);

		param.put("DOC_SUB_TYPE"		, "1");
		List<TB_DocuSubDTO> listSub = svcTable.selectTBDocuSub(param);
		
		String sendTel = docu.getReqMobile();
		if(StringUtils.isBlank(sendTel))sendTel = docu.getReqComptel();
		sendTel = sendTel.replace("+82-10", "010");
		
		String valueDate1 = docu.getValueDate1();
		String valueDate2 = docu.getValueDate2();
		
		String visitLoc = docu.getValueSt5();
		
		for(var sub : listSub) {

			String valueSt5 = StringUtils.isBlank(sub.getValueSt5()) ? "" : sub.getValueSt5();
			String valueSt6 = StringUtils.isBlank(sub.getValueSt6()) ? "" : sub.getValueSt6();
			String valueSt7 = StringUtils.isBlank(sub.getValueSt7()) ? "" : sub.getValueSt7();
			String valueSt8 = StringUtils.isBlank(sub.getValueSt8()) ? "" : sub.getValueSt8();
			String carInfo =  valueSt5 + " " + valueSt6 + " " + valueSt7 + " " + valueSt8;
			String receiveTel = sub.getValueSt4();
			
			param.put("docCode"	, docCode);
			param.put("SEND_TEL", sendTel);
			param.put("valueDate1"	, valueDate1);
			param.put("valueDate2"	, valueDate2);
			param.put("visitorName"	, sub.getValueSt1());
			param.put("visitLoc"	, visitLoc);
			param.put("carInfo"	, carInfo);
			param.put("RECEIVE_TEL"	, receiveTel.replace("+82-10", "010"));
									
			svcVisit1.insertKakaoMsg(param);
		}
		

		return "seccess";
    }

//	//updateTBDocu4DocCode
//	@SuppressWarnings("unchecked")
//	@PostMapping(value="/updateTBDocu4reg")
//    @ResponseBody
//    public String updateTBDocu4reg(@RequestParam Map<String, Object> map ) throws Exception {
//
//		Map<String, Object>param = new HashMap<String, Object>();
//
//		String docCode = map.get("docCode").toString();
//
//		param.put("docType"		, "2");
//		param.put("ssoStatus"	, "2");
//		param.put("docCode"		, docCode);
//		svcTable.updateTBDocu4DocCode(param);
//
//		return docCode;
//	}


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1ExcelUploadVisitor", method = { RequestMethod.POST })
	public Object visit1ExcelUploadVisitor(RedirectAttributes redirectAttributes, HttpServletRequest request, final MultipartHttpServletRequest multiRequest) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();

		try {
		    final Map<String, MultipartFile> files = multiRequest.getFileMap();
		    final Map<String, String[]> map =  multiRequest.getParameterMap();
		    String[] arr_ino = map.get("ino");
		    String[] arr_docCode = map.get("docCode");
		    String ino = arr_ino[0];
		    String docCode = arr_docCode[0];

		    MultipartFile file = files.get("file");
		    String orgFileNm = file.getOriginalFilename();
		    boolean empty = file.isEmpty();

		    file.transferTo(new File(FILE_ROOT_PATH + "\\" + orgFileNm));
		    File excelFile = new File(FILE_ROOT_PATH, orgFileNm);
		    FileInputStream fs = new FileInputStream(excelFile);

			XSSFWorkbook workbook = new XSSFWorkbook(fs);
		    XSSFSheet sheet = workbook.getSheetAt(0);

		    FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();

		    String[] headerOrigin = {"내방객 성명","회사명","직책","연락처","차량지역","차량번호1","차량번호2","차량번호3","차량종류","차량모델"};
		    List<TB_VisitorDTO> lstVisitor = new ArrayList<TB_VisitorDTO>();


		    for (Row row : sheet) {

		    	Iterator<Cell> cellIterator = row.cellIterator();
	    		TB_VisitorDTO visitor = new TB_VisitorDTO();

	            while (cellIterator.hasNext()) {


	                Cell cell = cellIterator.next();
	                int idx = cell.getColumnIndex();
	                String cData = evaluator.evaluateInCell(cell).toString();
	                cData = cData.replace(".0", "");

	                if(row.getRowNum() == 0 ) {//헤더가 정상적으로 들어왔는지 확인.
	                	if( cData.equals(headerOrigin[idx]) == false ) {
	                		return "엑셀 양식을 확인해주세요. ";
	                	}
			    	} else {
			    		switch (idx) {
						case 0: visitor.setVisitorName(StringUtils.isBlank(cData)? "" : cData); break;
						case 1: visitor.setVisitorCompname(StringUtils.isBlank(cData)? "" : cData); break;
						case 2: visitor.setVisitorGrdname(StringUtils.isBlank(cData)? "" : cData); break;
						case 3: visitor.setVisitorTel(StringUtils.isBlank(cData)? "" : cData); break;
						case 4: visitor.setCarNumber1(StringUtils.isBlank(cData)? "" : cData); break;
						case 5: visitor.setCarNumber2(StringUtils.isBlank(cData)? "" : cData); break;
						case 6: visitor.setCarNumber3(StringUtils.isBlank(cData)? "" : cData); break;
						case 7: visitor.setCarNumber4(StringUtils.isBlank(cData)? "" : cData); break;
						case 8: visitor.setCarType1(StringUtils.isBlank(cData)? "" : cData); break;
						case 9: visitor.setCarType2(StringUtils.isBlank(cData)? "" : cData); break;
		                }

		            }

	            }

	            if(row.getRowNum() != 0 ) {
	            	if(StringUtils.isBlank(visitor.getVisitorName())) return "내방객 성명은 필수입니다.";
		            if(StringUtils.isBlank(visitor.getVisitorCompname())) return "내방객 회사명은 필수입니다.";
		            if(StringUtils.isBlank(visitor.getVisitorTel())) return "내방객 연락처는 필수입니다.";
		            if(CommonUtils.isValidateTel(visitor.getVisitorTel()) == false) return "내방객 연락처형식이 맞지 않습니다.\nex) 010-345-6789";

	            	lstVisitor.add(visitor);
	            }

		    }//for (Row row : sheet) {
		    sheet = null;
		    workbook.close();
		    excelFile.delete();

		    MemberDTO user = getSessionUser();//getSessionUser();

    		param.clear();
    		param.put("DOC_CODE"	, docCode);
    		param.put("DOC_SUB_TYPE"	, "1");
    		svcVisit1.deleteDocumentSub(param);

		    for(TB_VisitorDTO visitor : lstVisitor) {
		    	param.clear();
		    	param.put("INO"	, ino);
	    		param.put("DOC_CODE"	, docCode);
	    		param.put("SUB_TYPE"	, "1");
	    		param.put("VALUE_ST1"	, visitor.getVisitorName());
	    		param.put("VALUE_ST2"	, visitor.getVisitorCompname());
	    		param.put("VALUE_ST3"	, visitor.getVisitorGrdname());
	    		param.put("VALUE_ST4"	, visitor.getVisitorTel());
	    		param.put("VALUE_ST5"	, visitor.getCarNumber1());
	    		param.put("VALUE_ST6"	, visitor.getCarNumber2());
	    		param.put("VALUE_ST7"	, visitor.getCarNumber3());
	    		param.put("VALUE_ST8"	, visitor.getCarNumber4());
	    		param.put("VALUE_ST9"	, visitor.getCarType1());
	    		param.put("VALUE_ST10"	, visitor.getCarType2());


	    		param.put("MEM_DATA0"	, user.getEpLoginid());
	    		param.put("MEM_DATA1"	, user.getEpUsername());

	    		svcVisit1.saveVisit1Excel_visitor(param);

		    }

		} catch(Exception e) {
			return e.toString();
		}

		return "sucess";
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit1ExcelUploadItem", method = { RequestMethod.POST })
	public Object visit1ExcelUploadItem(RedirectAttributes redirectAttributes, HttpServletRequest request, final MultipartHttpServletRequest multiRequest) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();

		try {
		    final Map<String, MultipartFile> files = multiRequest.getFileMap();
		    final Map<String, String[]> map =  multiRequest.getParameterMap();
		    String[] arr_ino = map.get("ino");
		    String[] arr_docCode = map.get("docCode");
		    String ino = arr_ino[0];
		    String docCode = arr_docCode[0];

		    MultipartFile file = files.get("file");
		    String orgFileNm = file.getOriginalFilename();
		    boolean empty = file.isEmpty();

		    file.transferTo(new File(FILE_ROOT_PATH + "\\" + orgFileNm));
		    File excelFile = new File(FILE_ROOT_PATH, orgFileNm);
		    FileInputStream fs = new FileInputStream(excelFile);

			XSSFWorkbook workbook = new XSSFWorkbook(fs);
		    XSSFSheet sheet = workbook.getSheetAt(0);

		    FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();

		    String[] headerOrigin = {"품명","모델명(규격)","제조번호(S/N)","수량","단위","비고"};
		    List<Map<String, String>> lstItem = new ArrayList<Map<String, String>>();


		    for (Row row : sheet) {

		    	Iterator<Cell> cellIterator = row.cellIterator();
		    	Map<String, String> item = new HashMap<String, String>();
                item.put("VALUE_ST1","");
                item.put("VALUE_ST2","");
                item.put("VALUE_ST3","");
                item.put("VALUE_ST4","");
                item.put("VALUE_ST5","");
                item.put("VALUE_ST6","");

	            while (cellIterator.hasNext()) {


	                Cell cell = cellIterator.next();
	                int idx = cell.getColumnIndex();
	                String cData = evaluator.evaluateInCell(cell).toString();
	                cData = cData.replace(".0", "");

	                if(row.getRowNum() == 0 ) {//헤더가 정상적으로 들어왔는지 확인.
	                	if( cData.equals(headerOrigin[idx]) == false ) {
	                		return "엑셀 양식을 확인해주세요. ";
	                	}
			    	} else {
			    		switch (idx) {
						case 0: item.put("VALUE_ST1", StringUtils.isBlank(cData)? "" : cData); break;
						case 1: item.put("VALUE_ST2", StringUtils.isBlank(cData)? "" : cData); break;
						case 2: item.put("VALUE_ST3", StringUtils.isBlank(cData)? "" : cData); break;
						case 3: item.put("VALUE_ST4", StringUtils.isBlank(cData)? "" : cData); break;
						case 4: item.put("VALUE_ST5", StringUtils.isBlank(cData)? "" : cData); break;
						case 5: item.put("VALUE_ST6", StringUtils.isBlank(cData)? "" : cData); break;

		                }

		            }

	            }

	            if(row.getRowNum() != 0 ) {
	            	if(StringUtils.isBlank(item.get("VALUE_ST1"))) return "반입물품 품명은 필수입니다.";
		            if(StringUtils.isBlank(item.get("VALUE_ST2"))) return "반입물품 모델명(규격)은 필수입니다.";
		            if(StringUtils.isBlank(item.get("VALUE_ST4"))) return "반입물품 수량은 필수입니다.";
		            if(CommonUtils.isValidateNo(item.get("VALUE_ST4")) == false) return "반입물품 수량은 숫자만 입력가능합니다.";
		            if(StringUtils.isBlank(item.get("VALUE_ST5"))) return "반입물품 단위는 필수입니다.";

	            	lstItem.add(item);
	            }

		    }//for (Row row : sheet) {
		    sheet = null;
		    workbook.close();
		    excelFile.delete();

		    MemberDTO user = getSessionUser();//getSessionUser();

    		param.clear();
    		param.put("DOC_CODE"	, docCode);
    		param.put("DOC_SUB_TYPE"	, "2");
    		svcVisit1.deleteDocumentSub(param);

		    for(Map item : lstItem) {
		    	param.clear();
		    	param.put("INO"	, "");
	    		param.put("DOC_CODE"	, docCode);
	    		param.put("SUB_TYPE"	, "2");
	    		param.put("VALUE_ST1"	, item.get("VALUE_ST1"));
	    		param.put("VALUE_ST2"	, item.get("VALUE_ST2"));
	    		param.put("VALUE_ST3"	, item.get("VALUE_ST3"));
	    		param.put("VALUE_ST4"	, item.get("VALUE_ST4"));
	    		param.put("VALUE_ST5"	, item.get("VALUE_ST5"));
	    		param.put("VALUE_ST6"	, item.get("VALUE_ST6"));

	    		param.put("MEM_DATA0"	, user.getEpLoginid());
	    		param.put("MEM_DATA1"	, user.getEpUsername());

	    		svcVisit1.saveVisit1Edit_item(param);

		    }

		} catch(Exception e) {
			return e.toString();
		}

		return "sucess";
	}

}
