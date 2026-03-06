<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="page-error page-error-delete">

  <div class="ui-card error-card">

    <div class="error-badges">
      <span class="ui-badge">ERROR</span>
      <span class="ui-badge">DELETE</span>
    </div>

    <h1 class="error-title">삭제할 수 없습니다</h1>

    <p class="error-msg">${message}</p>

  </div>

  <div class="error-actions">
    <a class="ui-btn ui-btn-primary"
       href="${pageContext.request.contextPath}/admin/survey/list.do">
       설문 목록으로 돌아가기
    </a>
  </div>

</div>