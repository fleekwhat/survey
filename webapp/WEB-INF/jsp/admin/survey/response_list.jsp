<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | Responses</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-response-list.css">
</head>
<body>

<div class="wrap">
  <div class="top">
    <h1 class="title">응답 목록</h1>
    <div class="sub">surveyId = ${surveyId}</div>
  </div>

  <c:choose>
    <c:when test="${empty list}">
      <div class="empty">등록된 응답이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <div class="card">
        <table class="tbl">
          <thead>
            <tr>
              <th style="width:120px;">응답ID</th>
              <th>회원</th>
              <th style="width:120px;">상태</th>
              <th style="width:180px;">제출일</th>
              <th style="width:120px;">상세</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="r" items="${list}">
              <tr>
     
                <td class="rid">${r.response_id}</td>

                <td>
                  <div class="member">
                    <span class="login">${r.login_id}</span>
                    <span class="name">${r.name}</span>
                  </div>
                </td>

                <td class="center">
                  <span class="badge">${r.status}</span>
                </td>

                <td class="date">
                  <fmt:formatDate value="${r.submitted_at}" pattern="yyyy-MM-dd HH:mm"/>
                </td>

                <!-- 상세보기 버튼으로 이동 -->
                <td class="center">
                  <a class="btn btn-sub btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/response/view.do?responseId=${r.response_id}">
                    상세보기
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