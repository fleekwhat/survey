<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="page-survey-complete">

  <div class="ui-card sv-complete">
    <div class="sv-complete-badges">
      <span class="ui-badge">SUBMIT</span>
      <span class="ui-badge">OK</span>
    </div>

    <h1 class="sv-title">제출이 완료되었습니다.</h1>
    <p class="sv-desc">응답이 정상적으로 저장되었습니다.</p>

    <div class="sv-meta">
      surveyId: ${surveyId}
    </div>
  </div>

  <div class="sv-actions">
    <a class="ui-btn ui-btn-primary" href="${pageContext.request.contextPath}/respond/survey/my_response.do">목록으로</a>
    <a class="ui-btn" href="${pageContext.request.contextPath}/index.do">홈으로</a>
  </div>

</div>