package kr.co.selc.linc.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import kr.co.selc.linc.dto.TB_DocuDTO;
import kr.co.selc.linc.dto.TB_DocuSubDTO;
import kr.co.selc.linc.dto.TB_SignAdmDTO;
import kr.co.selc.linc.service.CommonService;
import kr.co.selc.linc.service.LuckyService;
import kr.co.selc.linc.service.SignService;
import kr.co.selc.linc.service.TableService;
import kr.co.selc.linc.service.Visit2Service;

@RestController
public class Visit2Controller extends BaseController  {
	@Value("${file.root.path}") 
    public  String FILE_ROOT_PATH;
	
	@Autowired
	LuckyService svcLucky;

	
	@Autowired
	Visit2Service svcVisit2;
	
	@Autowired
	CommonService svcComm;
	
	@Autowired
	SignService svcSign;
	
	@Autowired
	TableService svcTable;
	
	
	String gcode = "g1011";
	
	@RequestMapping(value = "/visit2")
	public ModelAndView visit2() throws Exception {
		
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		/*
		 *  <!--#include file="./include/include_level_menu.asp"-->  main_code_index, sub_code_index, sub_lev(권한 : 0,1,?)  
		    <!--#include file="./include/include_app_group.asp"-->	// doc_name, sso_type, doc_title0 ~2 , doc_return(결재 리턴:_view), msg_title(결재시 스크립트 타이틀명)
			<!--#include file="./include/include_app_submit.asp"-->   // select sign_status,contents,sign_code from gj_sign_tbl - > submit_type, submit_contents, submit_signcode 
			<!--#include file="./include/include_app_search.asp"-->
			
		 */
		
		ModelAndView mv = new ModelAndView();
		
		//jsp(html)로 갈때는 setViewName // class로 갈때는 setView
		mv.setViewName("visit2");
	
		
		return mv;
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/visit2Search", method = { RequestMethod.POST })
    @ResponseBody
    public Object visit2Search(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		//아래 헤더 가져오는 내용 바뀌어야 함. 
		
		String pageNum = (String)map.get("pagenum");
		String pageSize = (String)map.get("pagesize");
		String excelYN = (String)map.get("excel");
		
		Map<String, Object>param = new HashMap<String, Object>();
		param.putAll(map);
		param.put("GCODE"	, gcode);
			
		if(!excelYN.equals("Y")) {
			param.put("PAGENUM", 	pageNum);
			param.put("PAGESIZE", 	pageSize);
		}
		
		List<TB_DocuSubDTO> list = svcVisit2.selectDocumentList(param);
		
		return list;
	}
	
	@RequestMapping(value = "/visit2Edit", method = { RequestMethod.POST })
	public ModelAndView visit2Edit(@RequestParam Map<String, Object> map ) throws Exception {
		String menuCode = getCurrentMenuId();//CommonUtils.getMenuID();
		Map<String, Object>param = new HashMap<String, Object>();
		ModelAndView mv = new ModelAndView();
		
		String docCode = (String)map.get("docCode");
		
		param.put("GCODE"		, gcode);
		param.put("DOC_CODE"	, docCode);
		
		List<TB_DocuDTO> list = svcTable.selectTBDocu(param);
		
		mv.addObject("indata", list.get(0));
		
		mv.setViewName("visit2Edit");
		return mv;
	}
	
}
