package com.dohyun.survey.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class LoginInterceptor implements HandlerInterceptor {

	 @Override
	  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
	    HttpSession session = req.getSession(false);
	    if (session == null || session.getAttribute("LOGIN_MEMBER") == null) {
	      res.sendRedirect(req.getContextPath() + "/auth/member/login_form.do");
	      return false;
	    }
	    return true;
	  }
	
	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {		
	}
	
	@Override
		public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
				throws Exception {
		}	
	
}
