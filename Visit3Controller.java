package kr.co.selc.linc.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import kr.co.selc.linc.dto.MemberDTO;
import kr.co.selc.linc.dto.TB_ContDTO;
import kr.co.selc.linc.dto.TB_DocuSubDTO;
import kr.co.selc.linc.dto.TB_VisitorBlockDTO;
import kr.co.selc.linc.dto.TB_VisitorDTO;
import kr.co.selc.linc.dto.TB_VisitorSysLogDTO;
import kr.co.selc.linc.service.CommonService;
import kr.co.selc.linc.service.SignService;
import kr.co.selc.linc.service.TableService;
import kr.co.selc.linc.service.Visit1Service;
import kr.co.selc.linc.service.Visit3Service;

@RestController
public class Visit3Controller extends BaseController  {
	@Value("${file.root.path}") 
    public  String FILE_ROOT_PATH;
	
	@Autowired
	Visit3Service svcVisit3;
	
	@Autowired
	CommonService svcComm;
	
	@Autowired
	SignService svcSign;
	
	@Autowired
	TableService svcTable;
	
	
	
	@RequestMapping(value = "/visit3")
	public ModelAndView visit3() throws Exception {
		
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)  
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode 
			<!--#include file="./include/include_app_search.asp"-->
			
		 */
		//menuCode = "010103";
		ModelAndView mv = new ModelAndView();
		
//		List<TB_SignAdmDTO> listSign = svcSign.selectAppSubmit(menuCode); //include_app_submit 처리
//		String submit_type = listSign.get(0).getSignStatus();
		
		//jsp(html)로 갈때는 setViewName // class로 갈때는 setView
		mv.setViewName("visit3");
		
		Map<String, Object>contParam = new HashMap<String, Object>();
		contParam.put("GROUP_CODE", "c2002");
		List<TB_ContDTO> listCndata = svcTable.selectTbCont(contParam);
		String contCode = "";
		String oldCode = "";
		if(listCndata != null && listCndata.size()>0) {
			contCode = listCndata.get(0).getContCode();
			oldCode = listCndata.get(0).getOldCode();
		}
		mv.addObject("contCode", contCode);
		mv.addObject("oldCode", oldCode);
		
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit3Search", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit3Search(@RequestParam Map<String, Object> map ) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		String pageNum = (String)map.get("pagenum");
		String pageSize = (String)map.get("pagesize");
		String excelYN = (String)map.get("excel");
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		if(!excelYN.equals("Y")) {
			param.put("PAGENUM", 	pageNum);
			param.put("PAGESIZE", 	pageSize);
		}
		param.put("SEARCHK0", 	(String)map.get("searchOpt0"));
		param.put("SEARCHK1", 	(String)map.get("searchOpt1"));
		param.put("SEARCHK2", 	(String)map.get("searchOpt2"));
		param.put("SEARCHK3", 	(String)map.get("searchOpt3"));
		param.put("SEARCHK5", 	(String)map.get("searchOpt5"));
		param.put("SEARCHK6", 	(String)map.get("searchOpt6"));
		param.put("SEARCHK7", 	(String)map.get("searchOpt7"));
		
		int idx = 0;
		List<TB_VisitorDTO> list = svcVisit3.selectVisitorList(param);
		for(TB_VisitorDTO data : list) {
			String visitorTel = data.getVisitorTel();
			visitorTel = visitorTel.replace("+82-10", "010");
			String[] splitTel = visitorTel.split("-");
			if(splitTel.length > 2) {
				splitTel[1] = "****";
				visitorTel = splitTel[0] + "-" + splitTel[1] + "-" +  splitTel[2] ; 
			} 
			
			data.setVisitorTel2( visitorTel );
		}
		
		
		return list;
    }	
	
	@RequestMapping(value = "/visit3Edit", method = { RequestMethod.POST })
	public ModelAndView visit3Edit(@RequestParam Map<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("visit3Edit");
		Map<String, Object>param = new HashMap<String, Object>();
		MemberDTO user = getSessionUser();
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		
		Map<String, Object>contParam = new HashMap<String, Object>();
		contParam.put("GROUP_CODE", "c2002");
		List<TB_ContDTO> listCndata = svcTable.selectTbCont(contParam);
		mv.addObject("cont", listCndata.get(0));
		
		
		TB_VisitorDTO indata ;
		
		String ino = (String)map.get("ino");
		String visitorCode = (String)map.get("visitorCode");
		
		if(StringUtils.isBlank(ino) && StringUtils.isBlank(visitorCode)) {
			indata = new TB_VisitorDTO();
			String tmpDocCode = "t" + svcComm.selectCurrDateTimeSpan().replaceAll("[^0-9]", "");
			indata.setVisitorCode(tmpDocCode);
			
		} else {
			param.clear();
			param.put("VISITOR_CODE", 	visitorCode);
			List<TB_VisitorDTO> lstVisitor = svcTable.selectTbVisitor(param);
			indata = lstVisitor.get(0);
		}
		mv.addObject("ino", ino);
		mv.addObject("indata", indata);
		
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit3View_visitorLog", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit3View_visitorLog(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		param.put("VISITOR_CODE", 	(String)map.get("visitorCode"));
		List<TB_VisitorDTO> list = svcVisit3.selectTbVisitorLog(param);
		
		return list;
    }	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit3View_visitorSysLog", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit3View_visitorSysLog(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		param.put("VISITOR_CODE", 	(String)map.get("visitorCode"));
		List<TB_VisitorSysLogDTO> list = svcVisit3.selectTbVisitorSysLog(param);
		
		return list;
    }	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit3View_docuSub", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit3View_docuSub(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		param.put("VISITOR_CODE", 	(String)map.get("visitorCode"));
		List<TB_DocuSubDTO> list = svcVisit3.selectTBDocuSub(param);
		
		return list;
    }	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit3View_visitorBlock", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit3View_visitorBlock(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		param.put("BLOCK_NAME", 	(String)map.get("visitorName"));
		param.put("BLOCK_TEL", 	(String)map.get("visitorTel"));
		List<TB_VisitorBlockDTO> list = svcTable.selectTbVisitorBlock(param);
		
		return list;
    }	
	
	@SuppressWarnings("unchecked")
	@PostMapping(value="/visit3Edit_Save")
    @ResponseBody
    public String visit3Edit_Save(@RequestParam Map<String, Object> map) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();
		String visitorCode = "";
		param.put("INO"	, map.get("ino"));
		param.put("STATUS"	, map.get("status"));
		param.put("VISITOR_CODE"	, map.get("visitorCode"));
		param.put("VISITOR_NAME"	, map.get("visitorName"));
		param.put("VISITOR_COMPNAME"	, map.get("visitorCompname"));
		param.put("VISITOR_GRDNAME"	, map.get("visitorGrdname"));
		param.put("VISITOR_TEL"	, map.get("visitorTel"));
		param.put("CAR_NUMBER1"	, map.get("carNumber1"));
		param.put("CAR_NUMBER2"	, map.get("carNumber2"));
		param.put("CAR_NUMBER3"	, map.get("carNumber3"));
		param.put("CAR_NUMBER4"	, map.get("carNumber4"));
		param.put("CAR_TYPE1"	, map.get("carType1"));
		param.put("CAR_TYPE2"	, map.get("carType2"));
		param.put("VISIT_DATE"	, map.get("visitDate"));
		param.put("VISITOR_DEPTNAME"	, map.get("visitorDeptname"));
		param.put("VISITOR_MAIL"	, map.get("visitorMail"));
		param.put("VISITOR_ADDRESS"	, map.get("visitorAddress"));

		
		visitorCode = svcVisit3.saveVisitor(param);
		
		return visitorCode;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/deleteVisit3View", method = { RequestMethod.POST })
    @ResponseBody
    public String deleteVisit3View(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		param.put("VISITOR_CODE", 	(String)map.get("visitorCode"));
		
		svcVisit3.deleteVisitor(param);
		
		return "";
    }
	
}
