<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제출 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
</head>
<body>
  <div class="wrap">
    <div class="head">
      <h1 class="title">제출이 완료되었습니다.</h1>
      <p class="desc">응답이 정상적으로 저장되었습니다.</p>
      <div class="meta">surveyId: ${surveyId}</div>
    </div>

    <div class="submit">
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/respond/survey/my_response.do">목록으로</a>
      <a class="btn" href="${pageContext.request.contextPath}/index.do">홈으로</a>
    </div>
  </div>
</body>
</html>