package com.dohyun.survey.controller;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dohyun.survey.dto.Breadcrumb;

@Controller
public class HomeController {

	 @RequestMapping({"/", "/index.do"})
	  public String home(HttpServletRequest request, Model model) {
		 String ctx = request.getContextPath();
		 
		 model.addAttribute("title", "home");
		 
		 model.addAttribute("breadcrumbs", Arrays.asList(
				 new Breadcrumb("Home", null)
				 ));
		 
		 return "index"; // tiles definition name
	 }
}
