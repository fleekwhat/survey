<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설문 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/respond-list.css">
</head>
<body>
  <div class="wrap">
  	<div class="page-my-response">	
	    <h1 class="title">진행중 설문</h1>
	
	    <c:if test="${empty list}">
	      <div class="empty">현재 진행중인 설문이 없습니다.</div>
	    </c:if>
	
	    <c:if test="${not empty list}">
	      <div class="card">
	        <table class="tbl">
	          <thead>
	            <tr>
	              <th style="width:70px;">No</th>
	              <th>제목</th>
	              <th style="width:220px;">기간</th>
	              <th style="width:120px;">상태</th>
	              <th style="width:120px;">참여</th>
	            </tr>
	          </thead>
	          <tbody>
	            <c:forEach var="s" items="${list}" varStatus="st">
	              <tr>
	                <td>${st.index + 1}</td>
	                <td class="title-cell">${fn:escapeXml(s.title)}</td>
	                <td>
	                  <c:choose>
	                    <c:when test="${not empty s.startAt || not empty s.endAt}">
	                      <c:if test="${not empty s.startAt}">${s.startAt}</c:if>
	                      <c:if test="${not empty s.endAt}"> ~ ${s.endAt}</c:if>
	                    </c:when>
	                    <c:otherwise>-</c:otherwise>
	                  </c:choose>
	                </td>
	                <td>
	                  <span class="badge">${s.status}</span>
	                </td>
	                <td>
	                  <a class="btn btn-primary btn-sm"
	                     href="${pageContext.request.contextPath}/respond/survey/view.do?surveyId=${s.surveyId}">
	                    참여
	                  </a>
	                </td>
	              </tr>
	            </c:forEach>
	          </tbody>
	        </table>
	      </div>
	    </c:if>
	  </div>
  </div>
</body>
</html>