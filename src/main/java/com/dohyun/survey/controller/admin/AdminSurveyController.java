package com.dohyun.survey.controller.admin;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.dohyun.survey.common.BreadcrumbHelper;
import com.dohyun.survey.dto.Breadcrumb;
import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.service.SurveyService;
import com.dohyun.survey.vo.MemberVO;
import com.dohyun.survey.vo.SurveyMainVO;


@Controller
@RequestMapping("/admin/survey")
public class AdminSurveyController {
	
	@Autowired
	private SurveyService surveyService; 
	
	@RequestMapping("/error/403.do")
	public String forbidden() {
	  return "common/403";
	}

	@GetMapping("/dashboard.do")
	public String adminDashboard(HttpServletRequest request, Model model) {
		BreadcrumbHelper.set(request, model, 
				new Breadcrumb("관리자 대시보드", null));
		return "admin/survey/dashboard";
	}
	
	@GetMapping("/form.do")
	public String form(HttpServletRequest request, Model model) {
		 BreadcrumbHelper.admin(request, model, 
		    		new Breadcrumb("설문 생성", null));
		return "admin/survey/form";
	}
	
	@PostMapping("/save.do")
	public String save(
		@RequestParam("title") String title,
		@RequestParam(value="description", required=false) String description,
		@RequestParam(required=false) String startAt,
		@RequestParam(required=false) String endAt,
		@RequestParam("payload") String payloadJson
	) throws Exception {
		
		surveyService.createSurvey(title, description, startAt, endAt, payloadJson);
		
		return "redirect:list.do";
	}
	
	@GetMapping("/view.do")
	public String preview(@RequestParam("surveyId") long surveyId, 
						  @SessionAttribute(value = "LOGIN_MEMBER", required = false) MemberVO member, 
						  Model model,
						  HttpServletRequest request) {
		SurveyViewDTO survey = surveyService.getSurveyView(surveyId, member);

	    model.addAttribute("survey", survey);
	    model.addAttribute("mode", "ADMIN");
	    
	    BreadcrumbHelper.admin(request, model, 
	    		new Breadcrumb("설문 관리", "/admin/survey/list.do"),
	    		new Breadcrumb("상세보기", null));
	    
		return "respond/survey/view";
	}
	
	@GetMapping("/list.do")
	public String list(HttpServletRequest request, Model model) {
		
		List<SurveyMainVO> list = surveyService.getAdminSurveyList();
		
		model.addAttribute("list", list);
		BreadcrumbHelper.admin(request, model, 
				new Breadcrumb("설문 관리", null)
				);
		
		return "admin/survey/list";
	}
	
	@GetMapping("/edit.do")
	public String edit(@RequestParam("surveyId") long surveyId,
	                   @SessionAttribute(value="LOGIN_MEMBER", required=false) MemberVO member,
	                   Model model, HttpServletRequest request) {

	    
	    
	    if (surveyService.hasResponses(surveyId)) {
	    	model.addAttribute("message", "응답이 있는 설문은 수정할 수 없습니다.");
	    	model.addAttribute("surveyId", surveyId);
	    	return "admin/survey/edit_forbidden";
	    }
	    
	    SurveyViewDTO survey = surveyService.getSurveyView(surveyId, member);
	    model.addAttribute("survey", survey);
	    BreadcrumbHelper.admin(request, model, 
	    		new Breadcrumb("설문 관리", "/admin/survey/list.do"),
	    		new Breadcrumb("설문 수정", null));

	    return "admin/survey/edit"; 
	}
	
	// ===== 수정 저장 =====
	@PostMapping("/update.do")
	public String update(@RequestParam("surveyId") long surveyId,
	                     @RequestParam("title") String title,
	                     @RequestParam(value="description", required=false) String description,
	                     @RequestParam(value="startAt", required=false) String startAt,
	                     @RequestParam(value="endAt", required=false) String endAt,
	                     @RequestParam("payload") String payloadJson,
	                     @SessionAttribute(value="LOGIN_MEMBER", required=false) MemberVO member, Model model) throws Exception {

	    
	    
	    if (surveyService.hasResponses(surveyId)) {
	        model.addAttribute("message", "응답이 있는 설문은 수정할 수 없습니다.");
	        model.addAttribute("surveyId", surveyId);
	        return "admin/survey/edit_forbidden";
	    }

	    SurveyMainVO mainVo = new SurveyMainVO();
	    mainVo.setSurveyId(surveyId);
	    mainVo.setTitle(title);
	    mainVo.setDescription(description);

	    mainVo.setStartAt(parseDateTimeLocal(startAt));
	    mainVo.setEndAt(parseDateTimeLocal(endAt));

	    surveyService.updateSurveyAll(mainVo, payloadJson);

	    return "redirect:list.do";
	}

    // ===== 삭제 (POST) =====
    @PostMapping("/delete.do")
    public String delete(@RequestParam("surveyId") long surveyId,
                         @SessionAttribute(value="LOGIN_MEMBER", required=false) MemberVO member, Model model) {

       
        
        try {
        	surveyService.deleteSurvey(surveyId);
        	return "redirect:list.do";
        } catch (IllegalStateException e) {
        	
        	model.addAttribute("message", "응답이 있는 설문은 삭제할 수 없습니다.");
        	
        	return "admin/survey/delete_error";
        }
    }

	@GetMapping("/responses.do")
	public String responses(@RequestParam("surveyId") long surveyId,
	                        Model model,
	                        HttpSession session,
	                        HttpServletRequest request) {

	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");
	    
	    BreadcrumbHelper.admin(request, model, 
	    		new Breadcrumb("설문 관리", "/admin/survey/list.do"),
	    		new Breadcrumb("응답 목록", null));
	   
	    model.addAttribute("surveyId", surveyId);
	    model.addAttribute("list", surveyService.getResponsesForAdmin(surveyId));
	    return "admin/survey/response_list";
	}

	@GetMapping("/response/view.do")
	public String responseView(@RequestParam("responseId") long responseId,
	                           Model model,
	                           HttpSession session,
	                           HttpServletRequest request) {

	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");
	    
	    Map<String, Object> resp = surveyService.getResponseMetaForAdmin(responseId);
	    
	    model.addAttribute("resp", surveyService.getResponseMetaForAdmin(responseId));
	    model.addAttribute("items", surveyService.getResponseItemsForAdmin(responseId));
	    
	    Long surveyId = ((Number) resp.get("surveyId")).longValue();
	    
	    BreadcrumbHelper.admin(request, model, 
	    		new Breadcrumb("설문 관리", "/admin/survey/list.do"),
	    		new Breadcrumb("응답 목록", "/admin/survey/responses.do?surveyId=" + surveyId),
	    		new Breadcrumb("응답 상세", null));
	    
	    return "admin/survey/response_view";
	}
	
	 // ===== helper =====
		private Timestamp parseDateTimeLocal(String s) {
		    if (s == null || s.trim().isEmpty()) return null;
		    return Timestamp.valueOf(s.replace("T", " ") + ":00");
		}
}
