package com.dohyun.survey.common;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.dohyun.survey.dto.Breadcrumb;

public class BreadcrumbHelper {
	
	 public static void set(HttpServletRequest request, Model model, Breadcrumb... crumbs) {
	        String ctx = request.getContextPath();

	        List<Breadcrumb> list = new ArrayList<>();

	        // 기본 Home 자동 포함
	        list.add(new Breadcrumb("Home", ctx + "/index.do"));

	        if (crumbs != null) {
	            for (Breadcrumb c : crumbs) {
	                if (c == null) continue;

	                String url = c.getUrl();
	                if (url != null) {
	                    // "/admin/..." 형태면 ctx 자동 부착
	                    if (url.startsWith("/")) url = ctx + url;
	                }
	                list.add(new Breadcrumb(c.getLabel(), url));
	            }
	        }

	        model.addAttribute("breadcrumbs", list);
	    }

	    // 편의: Admin 공통 prefix
	    public static void admin(HttpServletRequest request, Model model, Breadcrumb... crumbs) {
	        set(request, model,
	            new Breadcrumb("관리자 대시보드", "/admin/survey/dashboard.do"),
	            crumbs == null ? new Breadcrumb[0] : crumbs
	        );
	    }
	    
	    // 편의: Respond(사용자) 공통 prefix
	    public static void respond(HttpServletRequest request, Model model, Breadcrumb... crumbs) {
	        set(request, model,
	            new Breadcrumb("설문조사", "/respond/survey/home.do"),
	            crumbs == null ? new Breadcrumb[0] : crumbs
	        );
	    }

	    // varargs 합치기(자바8 호환)
	    private static void set(HttpServletRequest request, Model model, Breadcrumb base, Breadcrumb[] tail) {
	        Breadcrumb[] merged = merge(base, tail);
	        set(request, model, merged);
	    }

	    private static Breadcrumb[] merge(Breadcrumb base, Breadcrumb[] tail) {
	        int n = (tail == null ? 0 : tail.length);
	        Breadcrumb[] arr = new Breadcrumb[n + 1];
	        arr[0] = base;
	        for (int i = 0; i < n; i++) arr[i + 1] = tail[i];
	        return arr;
	    }

}