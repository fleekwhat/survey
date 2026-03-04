<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-dashboard.css">
</head>
<body>

<div class="wrap">
  <h1 class="title">관리자 대시보드</h1>

  <div class="card dash-card">
    <a class="dash-btn" href="${pageContext.request.contextPath}/admin/survey/form.do">
      <div class="dash-icon">＋</div>
      <div class="dash-text">
        <div class="dash-title">설문 생성</div>
        <div class="dash-desc">새로운 설문을 생성합니다</div>
      </div>
    </a>

    <a class="dash-btn" href="${pageContext.request.contextPath}/admin/survey/list.do">
      <div class="dash-icon">≡</div>
      <div class="dash-text">
        <div class="dash-title">설문 관리</div>
        <div class="dash-desc">설문 목록을 확인하고 수정합니다</div>
      </div>
    </a>
  </div>
</div>

</body>
</html>