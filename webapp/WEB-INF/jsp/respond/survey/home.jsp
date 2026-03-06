<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="page-respond-home">

  <div class="ui-card ui-page-head">
    <h1 class="ui-page-title">설문조사</h1>
    <p class="ui-page-desc">원하는 메뉴를 선택하세요.</p>
  </div>

  <div class="home-grid">
    <a class="ui-card home-card"
       href="${pageContext.request.contextPath}/respond/survey/list.do">
      <div class="home-icon">📝</div>
      <div class="home-text">
        <div class="home-title">진행중 설문</div>
        <div class="home-desc">현재 참여 가능한 설문 보기</div>
      </div>
    </a>

    <a class="ui-card home-card"
       href="${pageContext.request.contextPath}/respond/survey/my_response.do">
      <div class="home-icon">📂</div>
      <div class="home-text">
        <div class="home-title">내가 제출한 설문</div>
        <div class="home-desc">내 응답 내역 확인하기</div>
      </div>
    </a>
  </div>

</div>