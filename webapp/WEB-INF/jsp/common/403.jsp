<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="page-error">

  <div class="ui-card error-card">
    <div class="error-badges">
      <span class="ui-badge">ERROR</span>
      <span class="ui-badge">403</span>
    </div>

    <h1 class="error-code">403</h1>
    <p class="error-title">접근 권한이 없습니다.</p>
    <p class="error-desc">해당 페이지에 접근할 권한이 없습니다.</p>

    <c:if test="${not empty msg}">
      <div class="error-msg">
        ${msg}
      </div>
    </c:if>

    <div class="error-actions">
      <a class="ui-btn ui-btn-primary"
         href="${pageContext.request.contextPath}/respond/survey/home.do">
        메인으로 이동
      </a>
      <button type="button" class="ui-btn" onclick="history.back()">뒤로</button>
    </div>
  </div>

</div>