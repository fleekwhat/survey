package com.dohyun.survey.exception;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(ForbiddenException.class)
	public ModelAndView handleForbidden(ForbiddenException e, HttpServletResponse resp) {
	    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
	    ModelAndView mv = new ModelAndView("error/403");
	    mv.addObject("msg", e.getMessage());
	    return mv;
	}
}
