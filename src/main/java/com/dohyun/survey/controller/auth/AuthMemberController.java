package com.dohyun.survey.controller.auth;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dohyun.survey.interceptor.LoginInterceptor;
import com.dohyun.survey.service.MemberService;
import com.dohyun.survey.vo.MemberVO;

@Controller
@RequestMapping("/auth/member")
public class AuthMemberController {

	@Autowired
	private MemberService memberService;
	
	@RequestMapping("/login_form.do")
	private String MemberLoginForm() {
		return "auth/member/login_form";
	}
	
	@PostMapping("/login.do")
	public String MemberLogin(HttpSession session, @RequestParam("loginId") String loginId, @RequestParam("password") String password) {
		
		MemberVO m = memberService.login(loginId, password);
		if (m == null) return "redirect:/auth/member/login_form.do?error=1";
		
		session.setAttribute("LOGIN_MEMBER", m);
		session.setAttribute("LOGIN_ROLE", m.getRole()); // ADMIN / USER
		
		String redirectUrl = (String) session.getAttribute(LoginInterceptor.REDIRECT_URL_KEY); // "LOGIN_REDIRECT_URL"
	    if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
	        session.removeAttribute(LoginInterceptor.REDIRECT_URL_KEY);
	        return "redirect:" + redirectUrl;
	    }

	    return "redirect:/index.do";
	}
	
	@GetMapping("/logout.do")
	public String logout(HttpSession session) {
	    session.invalidate();
	    return "redirect:/index.do";
	}
}
