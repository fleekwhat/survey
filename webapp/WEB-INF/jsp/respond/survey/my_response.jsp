<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 제출한 설문</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/respond-my-response.css">
</head>
<body>
  <div class="wrap">
  	<h1 class="title">내가 제출한 설문</h1>
		<div class="card">
			      <table class="tbl">
				<tr>
					<th>No</th>
					<th>설문제목</th>
					<th>상태</th>
					<th>제출일</th>
					<th>관리</th>
				</tr>
		
				 <c:forEach var="r" items="${list}" varStatus="st">
					<tr>
						<td>${fn:length(list) - st.index}</td>
						 <!-- 설문 제목 -->
				        <td>
				        	<a href="${pageContext.request.contextPath}/respond/survey/response_view.do?responseId=${r.responseId}">
			        			${r.surveyTitle}
				       		</a>
				        </td>
						<td>${r.status}</td>
						<td><fmt:formatDate value="${r.submittedAt}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td class="actions">
						  <c:if test="${r.surveyStatus eq 'ACTIVE'}">
						    <a class="btn btn-sub btn-sm"
						       href="${pageContext.request.contextPath}/respond/survey/edit.do?surveyId=${r.surveyId}">
						      수정
						    </a>
						  </c:if>
						
						  <form class="inline" method="post"
						        action="${pageContext.request.contextPath}/respond/survey/delete.do"
						        onsubmit="return confirm('정말 삭제하시겠습니까?');">
						    <input type="hidden" name="responseId" value="${r.responseId}">
						    <button class="btn btn-danger btn-sm" type="submit">삭제</button>
						  </form>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
 	</div>
</body>
</html>