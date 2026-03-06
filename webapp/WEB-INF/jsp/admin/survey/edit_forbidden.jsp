<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="page-error">

  <div class="ui-card error-card">

    <div class="error-badges">
      <span class="ui-badge">FORBIDDEN</span>
      <span class="ui-badge">EDIT</span>
    </div>

    <h1 class="error-title">수정할 수 없습니다</h1>

    <p class="error-msg">${message}</p>

  </div>

  <div class="error-actions">
    <a class="ui-btn"
       href="${pageContext.request.contextPath}/admin/survey/list.do">목록</a>

    <a class="ui-btn ui-btn-primary"
       href="${pageContext.request.contextPath}/admin/survey/responses.do?surveyId=${surveyId}">
       응답 보기
    </a>
  </div>

</div>