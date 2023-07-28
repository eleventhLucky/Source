package kr.co.selc.linc.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
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
import kr.co.selc.linc.service.Visit4Service;

@RestController
public class Visit4Controller extends BaseController  {
	@Value("${file.root.path}") 
    public  String FILE_ROOT_PATH;
	
	@Autowired
	Visit4Service svcVisit4;
	
	@Autowired
	CommonService svcComm;
	
	@Autowired
	SignService svcSign;
	
	@Autowired
	TableService svcTable;
	
	
	
	@RequestMapping(value = "/visit4")
	public ModelAndView visit4() throws Exception {
		
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)  
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode 
			<!--#include file="./include/include_app_search.asp"-->
			
		 */
		
		ModelAndView mv = new ModelAndView();
		
		//jsp(html)로 갈때는 setViewName // class로 갈때는 setView
		mv.setViewName("visit4");
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit4Search", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit4Search(@RequestParam Map<String, Object> map ) throws Exception {
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
		param.put("SEARCHK5", 	(String)map.get("searchOpt5"));
		param.put("SEARCHK6", 	(String)map.get("searchOpt6"));
		param.put("SEARCHK7", 	(String)map.get("searchOpt7"));
		
		int idx = 0;
		List<TB_VisitorBlockDTO> list = svcVisit4.selectVisitorBlockList(param);
		
		return list;
    }	
	
	@RequestMapping(value = "/visit4Edit", method = { RequestMethod.POST })
	public ModelAndView visit4Edit(@RequestParam Map<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("visit4Edit");
		Map<String, Object>param = new HashMap<String, Object>();
		MemberDTO user = getSessionUser();
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		
		
		TB_VisitorBlockDTO indata ;
		
		String ino = (String)map.get("ino");
		String blockCode = (String)map.get("blockCode");
		
		if(StringUtils.isBlank(ino) && StringUtils.isBlank(blockCode)) { 
			indata = new TB_VisitorBlockDTO();
			String tmpBlockCode = "t" + svcComm.selectCurrDateTimeSpan().replaceAll("[^0-9]", "");
			indata.setBlockCode(tmpBlockCode);
			
		} else {
			param.clear();
			param.put("BLOCK_CODE", 	blockCode);
			List<TB_VisitorBlockDTO> lstBlock = svcTable.selectTbVisitorBlock(param);
			indata = lstBlock.get(0);
		}
		mv.addObject("ino", ino);
		mv.addObject("indata", indata);
		
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit4View_visitorLog", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit4View_visitorLog(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		
		param.put("VISITOR_NAME", 	(String)map.get("blockName"));
		param.put("VISITOR_TEL", 	(String)map.get("blockTel"));
		List<TB_VisitorDTO> list = svcVisit4.selectTbVisitorLog(param);
		
		return list;
    }	
	
	
	
	
	@SuppressWarnings("unchecked")
	@PostMapping(value="/visit4Edit_Save")
    @ResponseBody
    public String visit4Edit_Save(@RequestParam Map<String, Object> map) throws Exception {
		Map<String, Object>param = new HashMap<String, Object>();
		String visitorCode = "";
		param.put("INO"	, map.get("ino"));
		param.put("STATUS"	, map.get("status"));
		param.put("BLOCK_CODE"	, map.get("blockCode"));
		param.put("BLOCK_NAME"	, map.get("blockName"));
		param.put("BLOCK_COMPNAME"	, map.get("blockCompname"));
		param.put("BLOCK_GRDNAME"	, map.get("blockGrdname"));
		param.put("BLOCK_TEL"	, map.get("blockTel"));
		param.put("CAR_NUMBER1"	, map.get("carNumber1"));
		param.put("CAR_NUMBER2"	, map.get("carNumber2"));
		param.put("CAR_NUMBER3"	, map.get("carNumber3"));
		param.put("CAR_NUMBER4"	, map.get("carNumber4"));
		param.put("CAR_TYPE1"	, map.get("carType1"));
		param.put("CAR_TYPE2"	, map.get("carType2"));
		param.put("BLOCK_DATE"	, map.get("blockDate"));
		param.put("BLOCK_DEPTNAME"	, map.get("blockDeptname"));
		param.put("BLOCK_MAIL"	, map.get("blockMail"));
		param.put("BLOCK_ADDRESS"	, map.get("blockAddress"));

		
		visitorCode = svcVisit4.saveVisitorBlock(param);
		
		return visitorCode;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/deleteVisit4View", method = { RequestMethod.POST })
    @ResponseBody
    public String deleteVisit4View(@RequestParam Map<String, Object> map ) throws Exception {
		
		Map<String, Object>param = new HashMap<String, Object>();
		param.put("BLOCK_CODE", 	(String)map.get("blockCode"));
		
		svcVisit4.deleteVisitorBlock(param);
		
		return "";
    }
	
}
