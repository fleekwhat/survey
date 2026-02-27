package com.dohyun.survey.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dohyun.survey.vo.MemberVO;

public class AdminInterceptor implements HandlerInterceptor {
	@Override
	  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
	      throws Exception {

	    Object obj = request.getSession().getAttribute("LOGIN_MEMBER");
	    if (obj == null) {
	      response.sendRedirect(request.getContextPath() + "/auth/member/login_form.do");
	      return false;
	    }

	    MemberVO m = (MemberVO) obj;

	    if (!"ADMIN".equals(m.getRole())) {
	      response.sendRedirect(request.getContextPath() + "/error/403.do");
	      return false;
	    }

	    return true;
	  }
	
	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {	
	}
	
	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {
	}
}
