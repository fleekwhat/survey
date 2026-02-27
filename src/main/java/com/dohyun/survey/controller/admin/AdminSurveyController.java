package com.dohyun.survey.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.service.SurveyService;


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
		
		return "redirect:/admin/survey/list.do";
	}
	
	@GetMapping("/preview/{surveyId}.do")
	public String preview(@PathVariable long surveyId, Model model) {
		SurveyViewDTO survey = surveyService.getSurveyView(surveyId);

	    model.addAttribute("survey", survey);
	    model.addAttribute("mode", "ADMIN");
		return "respond/survey/view";
	}
	
	@GetMapping("/list.do")
	private String list() {
		return "admin/survey/list";
	}
	
}
