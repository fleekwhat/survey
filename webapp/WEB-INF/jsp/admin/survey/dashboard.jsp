<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
</head>
<body>
	<h1>관리자 대시보드</h1>
	<div>
		<a href="${pageContext.request.contextPath}/admin/survey/form.do">설문 생성</a>
		<a href="${pageContext.request.contextPath}/admin/survey/manage.do">설문 관리</a>
	</div>
</body>
</html>