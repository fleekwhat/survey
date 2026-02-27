<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="topbar">
  <div class="tb-inner">

    <div class="tb-left">
      <a class="brand" href="${pageContext.request.contextPath}/index.do">SurveyManager</a>

      <nav class="nav">
        <a class="nav-link" href="${pageContext.request.contextPath}/index.do">Home</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/respond/survey/main.do">설문조사</a>

        <c:if test="${sessionScope.LOGIN_ROLE == 'ADMIN'}">
          <a class="nav-link admin-link" href="${pageContext.request.contextPath}/admin/survey/dashboard.do">관리자</a>
        </c:if>
      </nav>
    </div>

    <div class="tb-right">
      <c:if test="${sessionScope.LOGIN_MEMBER == null}">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/auth/member/login_form.do">로그인</a>
      </c:if>

      <c:if test="${sessionScope.LOGIN_MEMBER != null}">
        <span class="user">
          <span class="avatar" aria-hidden="true"></span>
          <span class="user-name">${sessionScope.LOGIN_MEMBER.name}</span>
          <span class="user-suffix">님</span>
        </span>
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/auth/member/logout.do">로그아웃</a>
      </c:if>
    </div>

  </div>
</div>