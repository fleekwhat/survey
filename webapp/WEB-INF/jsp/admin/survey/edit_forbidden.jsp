<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정불가</title>
</head>
<body>
	<h2>수정할 수 없습니다</h2>
		<p>${message}</p>
		
		<a href="${pageContext.request.contextPath}/admin/survey/list.do">목록</a>
		<a href="${pageContext.request.contextPath}/admin/survey/responses.do?surveyId=${surveyId}">응답 보기</a>
</body>
</html>