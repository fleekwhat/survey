<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설문조사</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/respond-home.css">
</head>
<body>

<div class="wrap">
  <h1 class="title">설문조사</h1>

  <div class="home-grid">

    <a class="home-card"
       href="${pageContext.request.contextPath}/respond/survey/list.do">
      <div class="home-icon">📝</div>
      <div class="home-text">
        <div class="home-title">진행중 설문</div>
        <div class="home-desc">현재 참여 가능한 설문 보기</div>
      </div>
    </a>

    <a class="home-card sub"
       href="${pageContext.request.contextPath}/respond/survey/my_response.do">
      <div class="home-icon">📂</div>
      <div class="home-text">
        <div class="home-title">내가 제출한 설문</div>
        <div class="home-desc">내 응답 내역 확인하기</div>
      </div>
    </a>

  </div>
</div>

</body>
</html>