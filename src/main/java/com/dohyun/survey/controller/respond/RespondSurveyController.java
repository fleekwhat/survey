package com.dohyun.survey.controller.respond;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.service.SurveyService;


@Controller
@RequestMapping("/respond/survey")
public class RespondSurveyController {

	@Autowired
	private SurveyService surveyService;
	
	@RequestMapping("/main.do")
	public String main() {
		return "respond/survey/main"; // tiles.xml definition name
	}
	
	@GetMapping("/view/{surveyId}.do")
	public String view(@PathVariable long surveyId, Model model) {
		
		SurveyViewDTO survey = surveyService.getSurveyView(surveyId);

	    model.addAttribute("survey", survey);
	    model.addAttribute("mode", "USER");
	    
		return "respond/survey/view";
	}
}
