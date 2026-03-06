<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-admin-response-list">

  <!-- head -->
  <div class="ui-card ui-page-head arl-head">
    <div class="arl-head-top">
      <div class="arl-head-left">
        <h1 class="ui-page-title">응답 목록</h1>
        <p class="ui-page-desc arl-sub">surveyId = ${surveyId}</p>
      </div>

      <div class="arl-head-actions">
        <a class="ui-btn ui-btn-sm"
           href="${pageContext.request.contextPath}/admin/survey/dashboard.do">
          대시보드
        </a>
      </div>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty list}">
      <div class="ui-empty">등록된 응답이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <div class="ui-card is-clip arl-table">
        <table class="ui-tbl">
          <thead>
            <tr>
              <th style="width:120px;">응답ID</th>
              <th>회원</th>
              <th style="width:120px;">상태</th>
              <th class="col-submitted-at" style="width:180px;">제출일</th>
              <th style="width:120px;">상세</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="r" items="${list}">
              <tr>
                <td class="rid"><c:out value="${r.response_id}"/></td>

                <td>
                  <div class="member">
                    <span class="login"><c:out value="${r.login_id}"/></span>
                    <span class="name"><c:out value="${r.name}"/></span>
                  </div>
                </td>

                <td class="center">
                  <span class="ui-badge"><c:out value="${r.status}"/></span>
                </td>

                <td class="date col-submitted-at">
                  <fmt:formatDate value="${r.submitted_at}" pattern="yyyy-MM-dd HH:mm"/>
                </td>

                <td class="center">
                  <a class="ui-btn ui-btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/response/view.do?responseId=${r.response_id}">
                    상세보기
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>

</div>