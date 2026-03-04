<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error</title>
</head>
<body>
	<h2>삭제할 수 없습니다</h2>

	<p>${message}</p>
	
	<a href="${pageContext.request.contextPath}/admin/survey/list.do">
	설문 목록으로 돌아가기
</a>
</body>
</html>