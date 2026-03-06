package com.dohyun.survey.controller.respond;



import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dohyun.survey.common.BreadcrumbHelper;
import com.dohyun.survey.dto.Breadcrumb;
import com.dohyun.survey.dto.MyResponseDTO;
import com.dohyun.survey.dto.SurveyEditFormDTO;
import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.exception.ForbiddenException;
import com.dohyun.survey.mapper.SurveyMapper;
import com.dohyun.survey.service.SurveyService;
import com.dohyun.survey.vo.MemberVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyResponseItem;
import com.dohyun.survey.vo.SurveyResponseVO;


@Controller
@RequestMapping("/respond/survey")
public class RespondSurveyController {

	@Autowired
	private SurveyService surveyService;
	@Autowired
	private SurveyMapper surveyMapper;
	
	@RequestMapping("/home.do")
	public String main(HttpServletRequest request, Model model) {
		
		BreadcrumbHelper.set(request, model, 
				new Breadcrumb("설문조사", null));
		
		return "respond/survey/home"; // tiles.xml definition name
	}
	
	
	// ACTIVE 권한체크
	
	@GetMapping("/view.do")
	public String view(@RequestParam("surveyId") long surveyId, Model model, HttpSession session, HttpServletRequest request) {
	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");
	    SurveyViewDTO survey = surveyService.getSurveyViewForUser(surveyId, member);

	    model.addAttribute("survey", survey);
	    model.addAttribute("mode", "USER");
	    
	    BreadcrumbHelper.respond(request, model, 
				new Breadcrumb("진행중 설문", "/respond/survey/list.do"),
				new Breadcrumb("설문 참여", null)
				);
	    
	    return "respond/survey/view";
	}
	
	@PostMapping("/submit.do")
	public String submit(@RequestParam long surveyId, HttpServletRequest request) {

	    MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");


	    surveyService.submitUserResponse(surveyId, member, request);

	    return "redirect:/respond/survey/complete.do?surveyId=" + surveyId;
	}

    @GetMapping("/complete.do")
    public String complete(@RequestParam long surveyId, Model model) {
        model.addAttribute("surveyId", surveyId);
        return "respond/survey/complete";
    }


	@GetMapping("/list.do")
    public String list(HttpServletRequest request, Model model) {
        List<SurveyMainVO> list = surveyService.getActiveSurveyList();
        model.addAttribute("list", list);
        
        BreadcrumbHelper.respond(request, model, 
				new Breadcrumb("진행중 설문", null));
		
        
        return "respond/survey/list"; // 
    }
	
	@GetMapping("/my_response.do")
	public String myResponses(HttpServletRequest request, Model model) {

		 MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");


		    List<MyResponseDTO> list =
		            surveyMapper.selectMyResponses(member.getMemberId());

		    model.addAttribute("list", list);
		    
		    BreadcrumbHelper.respond(request, model, 
					new Breadcrumb("내가 제출한 설문", null));

		    return "respond/survey/my_response";
	}
	
	@GetMapping("/response_view.do")
	public String responseView(@RequestParam("responseId") long responseId,
	                           Model model,
	                           HttpSession session,
	                           HttpServletRequest request) {

	    MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");


	    surveyService.loadMyResponseDetail(responseId, member, model);
	    
	    BreadcrumbHelper.respond(request, model, 
				new Breadcrumb("내가 제출한 설문", "/respond/survey/my_response.do"),
				new Breadcrumb("내 응답 상세", null)
				);

	    return "respond/survey/response_view";
	}
	
	@GetMapping("/edit.do")
	public String edit(@RequestParam long surveyId, Model model, HttpSession session, HttpServletRequest request) {
	  MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");

	  Long memberId = member.getMemberId(); 
	  SurveyEditFormDTO dto = surveyService.getEditFormForUser(surveyId, memberId);

	  model.addAttribute("survey", dto);
	  
	  BreadcrumbHelper.respond(request, model, 
				new Breadcrumb("내가 제출한 설문", "/respond/survey/my_response.do"),
				new Breadcrumb("응답 수정", null)
				);
	  
	  return "respond/survey/edit";
	}

	@PostMapping("/update.do")
	public String update(@RequestParam long surveyId,
	                     HttpServletRequest request,
	                     HttpSession session) {
	  MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");

	  Long memberId = member.getMemberId();
	  surveyService.updateUserResponse(surveyId, memberId, request.getParameterMap());

	  return "redirect:complete.do?surveyId=" + surveyId;
	}
	
	@PostMapping("/delete.do")
	public String delete(@RequestParam long responseId, HttpSession session) {

	  MemberVO member = (MemberVO) session.getAttribute("LOGIN_MEMBER");

	  surveyService.deleteMyResponse(responseId, member.getMemberId());

	  return "redirect:/respond/survey/my_response.do";
	}
}
