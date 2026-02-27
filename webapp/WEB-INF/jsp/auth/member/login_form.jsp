<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<form action="login.do" method="post">
		<div>아이디: <input type="text" name="loginId"></div>
		<div>비밀번호: <input type="password" name="password"></div>
		<button type="submit">로그인</button>
	</form>
</body>
</html>