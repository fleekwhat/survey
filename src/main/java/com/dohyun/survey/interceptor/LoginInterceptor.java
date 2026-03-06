package com.dohyun.survey.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class LoginInterceptor implements HandlerInterceptor {

    public static final String REDIRECT_URL_KEY = "LOGIN_REDIRECT_URL";

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {

        HttpSession session = req.getSession(false);

        // 로그인 여부 체크
        if (session == null || session.getAttribute("LOGIN_MEMBER") == null) {

            // 원래 보던 페이지 저장(무한루프 방지 + GET만 저장)
            if (shouldSaveRedirectUrl(req)) {
                String redirectUrl = buildRedirectUrl(req);
                // 세션이 없으면 만들어서 저장
                req.getSession(true).setAttribute(REDIRECT_URL_KEY, redirectUrl);
            }

            res.sendRedirect(req.getContextPath() + "/auth/member/login_form.do");
            return false;
        }

        return true;
    }

    private boolean shouldSaveRedirectUrl(HttpServletRequest req) {
        // POST 같은 건 저장해봤자 의미가 없거나 위험함
        if (!"GET".equalsIgnoreCase(req.getMethod())) return false;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        // 로그인/로그아웃/에러 페이지 자체는 저장하면 루프 가능
        if (uri.startsWith(ctx + "/auth/")) return false;
        if (uri.startsWith(ctx + "/error/")) return false;

        // 정적 리소스는 제외(원하면 더 추가)
        if (uri.startsWith(ctx + "/css/")) return false;
        if (uri.startsWith(ctx + "/js/")) return false;
        if (uri.startsWith(ctx + "/images/")) return false;
        if (uri.startsWith(ctx + "/uploads/")) return false;

        return true;
    }

    private String buildRedirectUrl(HttpServletRequest req) {
        String uri = req.getRequestURI();
        String qs = req.getQueryString();

        // contextPath 제거해서 "redirect:"에 바로 붙일 수 있게 만듦
        String ctx = req.getContextPath();
        String path = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;

        if (qs != null && !qs.isEmpty()) {
            path += "?" + qs;
        }

        return path; // 예: /respond/survey/view.do?surveyId=18
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
