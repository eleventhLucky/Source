package kr.co.selc.linc.web.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.util.URLEncoder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.selc.linc.cmm.FileUtils;
import kr.co.selc.linc.dto.FileDTO;
import kr.co.selc.linc.service.FileService;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@RestController
public class FileController {

	@Autowired
	FileService fileService;

	@Autowired
	FileUtils fileUtils;

	@Value("${file.path}")
    public  String FILE_PATH;

	@Value("${file.template.path}")
    public  String FILE_TEMPLATE;

	@Value("${file.root.path}")
    public  String FILE_ROOT_PATH;


	  @GetMapping("/upload")
	    public String testUploadForm() {

	        return "test/uploadTest";
	    }


	    @SuppressWarnings("unchecked")
		@PostMapping("/fileUpload")
	    public Object uploadFile(@RequestParam("files") List<MultipartFile> files, @RequestParam Map<String, Object> map)  throws Exception {
	    	JSONArray jsonArray = new JSONArray();

	    	//fileUtils.uplaodFile(file);

	    	//jsonArray.set(0, jsonArray);

	    	FileDTO fileDTO = new FileDTO();

	    	fileDTO.setAttachCode((String)map.get("attachCode"));
	    	fileDTO.setDelStatus("");
	    	fileDTO.setRegId((String)map.get("regId"));
	    	fileDTO.setFileType((String)map.get("fileType"));
	    	fileDTO.setAttachSubCode((String)map.get("attachSubCode"));
	    	fileDTO.setFilePath(FILE_PATH);

	    	// groupCode fileType docSubType name dept
	    	String dbFileName = "";


	    	int i = 0;

			for (MultipartFile multipartFile : files) {
		    JSONObject jsonData = new JSONObject();
			fileDTO.setFileLength(fileUtils.getFileSize(multipartFile.getSize()));

			dbFileName = fileUtils.uplaodFile(multipartFile);

			fileDTO.setFileName(dbFileName);
			jsonData.put("fileName", dbFileName);
			fileService.saveFileInfo(fileDTO);
			jsonData.put("attachSeq", fileDTO.getAttachSeq());
			jsonData.put("fileLength", fileDTO.getFileLength());
			jsonArray.add(jsonData);
			}

			JSONObject json = new JSONObject();

			json.put("data" , jsonArray.toArray());

	        return json;
	    }

	    @SuppressWarnings("unchecked")
		@PostMapping("/fileWindowPopup")
	    public ModelAndView fileWindowPopup(@RequestParam Map<String, Object> map) throws IOException {

	    	ModelAndView mv = new ModelAndView();

	    	mv.setViewName("./popup/popup_file_upload");

	    	FileDTO fileDTO = new FileDTO();

	    	fileDTO.setAttachCode((String)map.get("attachCode"));
	    	//fileDTO.setDelStatus("");
	    	fileDTO.setRegId((String)map.get("regId"));
	    	fileDTO.setFileType((String)map.get("fileType"));
	    	fileDTO.setAttachSubCode((String)map.get("attachSubCode"));

	    	mv.addObject("indata", fileDTO);

	        return mv;
	    }
	    
	    @SuppressWarnings("unchecked")
		@PostMapping("/fileSecondWindowPopup")
	    public ModelAndView fileSecondWindowPopup(@RequestParam Map<String, Object> map) throws IOException {

	    	ModelAndView mv = new ModelAndView();

	    	mv.setViewName("./popup/popup_file_second_upload");

	    	FileDTO fileDTO = new FileDTO();

	    	fileDTO.setAttachCode((String)map.get("attachCode"));
	    	//fileDTO.setDelStatus("");
	    	fileDTO.setRegId((String)map.get("regId"));
	    	fileDTO.setFileType((String)map.get("fileType"));
	    	fileDTO.setAttachSubCode((String)map.get("attachSubCode"));

	    	mv.addObject("indata", fileDTO);

	        return mv;
	    }
	    
	    @SuppressWarnings("unchecked")
		@PostMapping("/fileThirdWindowPopup")
	    public ModelAndView fileThirdWindowPopup(@RequestParam Map<String, Object> map) throws IOException {

	    	ModelAndView mv = new ModelAndView();

	    	mv.setViewName("./popup/popup_file_third_upload");

	    	FileDTO fileDTO = new FileDTO();

	    	fileDTO.setAttachCode((String)map.get("attachCode"));
	    	//fileDTO.setDelStatus("");
	    	fileDTO.setRegId((String)map.get("regId"));
	    	fileDTO.setFileType((String)map.get("fileType"));
	    	fileDTO.setAttachSubCode((String)map.get("attachSubCode"));

	    	mv.addObject("indata", fileDTO);

	        return mv;
	    }

		@PostMapping("/fileMenuWindowPopup")
	    public ModelAndView fileMenuWindowPopup(@RequestParam Map<String, Object> map) throws IOException {

	    	ModelAndView mv = new ModelAndView();

	    	mv.setViewName("./popup/popup_file_menu_upload");

	    	FileDTO fileDTO = new FileDTO();

	    	fileDTO.setAttachCode((String)map.get("attachCode"));
	    	//fileDTO.setDelStatus("");
	    	fileDTO.setRegId((String)map.get("regId"));
	    	fileDTO.setFileType((String)map.get("fileType"));
	    	fileDTO.setAttachSubCode((String)map.get("attachSubCode"));

	    	mv.addObject("indata", fileDTO);

	        return mv;
	    }


		@PostMapping("/viewFileWindowPopup")
		public ModelAndView viewFileWindowPopup(@RequestParam Map<String, Object> map) throws IOException {

			ModelAndView mv = new ModelAndView();

			mv.setViewName("./popup/popup_file_view");

			return mv;
		}

	    @SuppressWarnings("unchecked")
	    @RequestMapping(value="/deleteFileInfo" , method = { RequestMethod.POST })
	    public Object deleteFileInfo(@RequestParam Map<String, Object> map) throws Exception {

	    	String fileName = (String)map.get("fileName");

	    	fileService.deleteFileInfo(map);

	    	fileUtils.deleteFile(fileName);

	    	JSONObject json = new JSONObject();

	    	json.put("data","");

	    	return json;
	    }


	    @SuppressWarnings("unchecked")
	    @RequestMapping(value="/selectUploadFileList" , method = { RequestMethod.POST })
	    public Object selectUploadFileList(@RequestParam Map<String, Object> map) throws Exception {

	    	JSONObject returnJson = new JSONObject();


	    	List<FileDTO> fileDTO = fileService.selectUploadFileList(map);

	    	if(fileDTO.size()>0) {

	    		JSONArray jsonArray = new JSONArray();

		    	for (FileDTO item : fileDTO) {
					JSONObject json = new JSONObject();
					json.put("fileName", item.getFileName());
					json.put("fileLength", item.getFileLength());
					json.put("attachCode", item.getAttachCode());
					json.put("attachSeq", item.getAttachSeq());
					json.put("filePath", item.getFilePath());
					jsonArray.add(json);
				}
		    	returnJson.put("data", jsonArray);
	    	} else {
	    		returnJson.put("data", "");
	    	}

	    	return returnJson;
	    }


	    @SuppressWarnings("deprecation")
		@RequestMapping(value = "/fileDownload")
	    public void fileDownload(@RequestParam Map<String, Object> map, HttpServletResponse response) throws Exception {

	    	try {
	    		   String fileName = (String)map.get("fileName");
	    		   String filePath = (String)map.get("filePath");
	    		   String fileFullPath = "";
	    		   if( StringUtils.isBlank(filePath) ) {
	    			   fileFullPath =  FILE_ROOT_PATH + FILE_PATH + fileName;
	    		   }else {
	    			   fileFullPath =  FILE_ROOT_PATH + filePath + fileName;
	    		   }

	    		   try {
	    		    File file = new File(fileFullPath);
	    		    FileInputStream in = new FileInputStream(fileFullPath);

	    		    response.setContentType(URLConnection.guessContentTypeFromStream(in));
	    		    response.setContentLength(Files.readAllBytes(file.toPath()).length);
	    		    //response.setHeader("Content-Disposition","attachment; filename=\"" + java.net.URLEncoder.encode(fileName) +"\"");
	    		    response.setHeader("Content-Disposition","attachment; filename=\"" + fileName +"\"");


	    		    FileCopyUtils.copy(in, response.getOutputStream());
	    		    in.close();
	    		   } catch (FileNotFoundException e) {
	    		    e.printStackTrace();
	    		   } catch (IOException e) {
	    		    e.printStackTrace();
	    		   }
	    		  } catch (Exception e) {
	    		   e.printStackTrace();
	    		  }

	    }

	    @SuppressWarnings("unchecked")
	    @RequestMapping(value="/popupDownloadList" , method = { RequestMethod.POST })
	    public Object popupDownloadList(@RequestParam Map<String, Object> map) throws Exception {

	    	JSONObject returnJson = new JSONObject();

	    	String attachCode =  (String)map.get("attachCode");
	    	String attachSubCode =  (String)map.get("attachSubCode");

	    	List<FileDTO> fileDTO = fileService.selectUploadFileList(map);

	    	if(fileDTO.size()>0) {

	    		JSONArray jsonArray = new JSONArray();

		    	for (FileDTO item : fileDTO) {
					JSONObject json = new JSONObject();
					json.put("fileName", item.getFileName());
					json.put("filePath", item.getFilePath());
					json.put("fileLength", item.getFileLength());
					json.put("attachCode", item.getAttachCode());
					jsonArray.add(json);
				}
		    	returnJson.put("data", jsonArray);
	    	} else {
	    		returnJson.put("data", "");
	    	}

	    	return returnJson;
	    }



		@SuppressWarnings("deprecation")
		@RequestMapping(value = "/excelDownload")
	    public void excelDownload(@RequestParam Map<String, Object> map, HttpServletResponse response) throws Exception {

	    	try {
	    		   String fileName = map.get("filename").toString();//  "건강검진업로드.xls";
	    		   String filePath =  FILE_ROOT_PATH + FILE_TEMPLATE + fileName;

	    		   try {
	    		    File file = new File(filePath);
	    		    FileInputStream in = new FileInputStream(filePath);

	    		    //response.setContentType(URLConnection.guessContentTypeFromStream(in));
	    		    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    		    response.setContentLength(Files.readAllBytes(file.toPath()).length);
	    		    //response.setHeader("Content-Disposition","attachment; filename=\"" + java.net.URLEncoder.encode(fileName) +"\"");
	    		    response.setHeader("Content-Disposition","attachment; filename=\"" + fileName +"\"");

	    		    FileCopyUtils.copy(in, response.getOutputStream());
	    		    in.close();
	    		   } catch (FileNotFoundException e) {
	    		    e.printStackTrace();
	    		   } catch (IOException e) {
	    		    e.printStackTrace();
	    		   }
	    		  } catch (Exception e) {
	    		   e.printStackTrace();
	    		  }

	    }

	@RequestMapping(value = "/templateFileDownload")
	public void templateFileDownload(@RequestParam Map<String, Object> map, HttpServletResponse response) throws Exception {
		String fileName = (String) map.get("filename");
		String filePath = FILE_ROOT_PATH + FILE_PATH + fileName;
		try {
			File file = new File(filePath);
			FileInputStream in = new FileInputStream(filePath);

			response.setContentType(URLConnection.guessContentTypeFromStream(in));
			response.setContentLength(Files.readAllBytes(file.toPath()).length);
			response.setHeader("Content-Disposition","attachment; filename=\"" + fileName +"\"");

			FileCopyUtils.copy(in, response.getOutputStream());
			in.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}