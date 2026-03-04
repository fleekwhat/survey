<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | Manage Surveys</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-list.css">
</head>
<body>

<div class="wrap">
  <div class="top">
    <h1 class="title">설문 관리</h1>
    <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/survey/form.do">설문 생성</a>
  </div>

  <c:choose>
    <c:when test="${empty list}">
      <div class="empty">등록된 설문이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <div class="card">
        <table class="tbl">
          <thead>
            <tr>
              <th style="width:70px;">ID</th>
              <th>설문</th>
              <th style="width:110px;">상태</th>
              <th style="width:240px;">기간</th>
              <th style="width:170px;">관리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="s" items="${list}">
              <tr>
                <td class="id">${s.surveyId}</td>

                <td class="title-cell">
                  <a class="link"
                     href="${pageContext.request.contextPath}/admin/survey/view.do?surveyId=${s.surveyId}">
                    <c:out value="${s.title}"/>
                  </a>
                </td>

                <td>
                  <span class="badge">${s.status}</span>
                </td>

                <td class="period">
                  <c:choose>
                    <c:when test="${not empty s.startAt || not empty s.endAt}">
                      <c:if test="${not empty s.startAt}">
                        <fmt:formatDate value="${s.startAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:if>
                      <span class="sep">~</span>
                      <c:if test="${not empty s.endAt}">
                        <fmt:formatDate value="${s.endAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:if>
                      <c:if test="${empty s.startAt && not empty s.endAt}">-</c:if>
                      <c:if test="${not empty s.startAt && empty s.endAt}">-</c:if>
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>

                <td class="actions">
                  <a class="btn btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/edit.do?surveyId=${s.surveyId}">
                    수정
                  </a>

                  <form method="post"
                        action="${pageContext.request.contextPath}/admin/survey/delete.do"
                        class="inline"
                        onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="surveyId" value="${s.surveyId}">
                    <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                  </form>

                  <a class="btn btn-sub btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/responses.do?surveyId=${s.surveyId}">
                    응답
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

</body>
</html>