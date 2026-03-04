package com.dohyun.survey.controller.admin;

import java.sql.Timestamp;
import java.util.List;

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
	private String adminDashboard() {
		return "admin/survey/dashboard";
	}
	
	@GetMapping("/form.do")
	private String form() {
		return "admin/survey/form";
	}
	
	@PostMapping("/save.do")
	private String save(
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
						  Model model) {
		SurveyViewDTO survey = surveyService.getSurveyView(surveyId, member);

	    model.addAttribute("survey", survey);
	    model.addAttribute("mode", "ADMIN");
		return "respond/survey/view";
	}
	
	@GetMapping("/list.do")
	private String list(Model model) {
		
		List<SurveyMainVO> list = surveyService.getAdminSurveyList();
		
		model.addAttribute("list", list);
		
		return "admin/survey/list";
	}
	
	@GetMapping("/edit.do")
	public String edit(@RequestParam("surveyId") long surveyId,
	                   @SessionAttribute(value="LOGIN_MEMBER", required=false) MemberVO member,
	                   Model model) {

	    if (member == null || !"ADMIN".equals(member.getRole())) {
	        throw new RuntimeException("권한 없음");
	    }
	    
	    if (surveyService.hasResponses(surveyId)) {
	    	model.addAttribute("message", "응답이 있는 설문은 수정할 수 없습니다.");
	    	model.addAttribute("surveyId", surveyId);
	    	return "admin/survey/edit_forbidden";
	    }

	    SurveyViewDTO survey = surveyService.getSurveyView(surveyId, member);
	    model.addAttribute("survey", survey);

	    return "admin/survey/edit"; // /WEB-INF/views/admin/survey/edit.jsp
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

	    if (member == null || !"ADMIN".equals(member.getRole())) {
	        throw new RuntimeException("권한 없음");
	    }
	    
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

        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new RuntimeException("권한 없음");
        }
        
        try {
        	surveyService.deleteSurvey(surveyId);
        	return "redirect:list.do";
        } catch (IllegalStateException e) {
        	
        	model.addAttribute("message", "응답이 있는 설문은 삭제할 수 없습니다.");
        	
        	return "admin/survey/delete_error";
        	
        }
    }
//
    // ===== helper =====
	private Timestamp parseDateTimeLocal(String s) {
	    if (s == null || s.trim().isEmpty()) return null;
	    return Timestamp.valueOf(s.replace("T", " ") + ":00");
	}
	
	@GetMapping("/responses.do")
	public String responses(@RequestParam("surveyId") long surveyId,
	                        Model model,
	                        HttpSession session) {

	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");
	    if (member == null || !"ADMIN".equals(member.getRole())) {
	        return "redirect:/admin/survey/error/403.do";
	    }

	    model.addAttribute("surveyId", surveyId);
	    model.addAttribute("list", surveyService.getResponsesForAdmin(surveyId));
	    return "admin/survey/response_list";
	}

	@GetMapping("/response/view.do")
	public String responseView(@RequestParam("responseId") long responseId,
	                           Model model,
	                           HttpSession session) {

	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");
	    if (member == null || !"ADMIN".equals(member.getRole())) {
	        return "redirect:/admin/survey/error/403.do";
	    }

	    model.addAttribute("resp", surveyService.getResponseMetaForAdmin(responseId));
	    model.addAttribute("items", surveyService.getResponseItemsForAdmin(responseId));
	    return "admin/survey/response_view";
	}
	
}
