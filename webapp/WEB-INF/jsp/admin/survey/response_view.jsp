<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-admin-response-view">

  <!-- 공통 헤더 -->
  <div class="ui-card ui-page-head arv-head">
    <div class="arv-head-top">
      <div class="arv-badges">
        <span class="ui-badge">RESPONSE</span>
        <span class="ui-badge"><c:out value="${resp.status}"/></span>
      </div>
    </div>

    <h1 class="ui-page-title">응답 상세</h1>
    <p class="ui-page-desc">관리자 응답 상세 화면입니다.</p>
  </div>

  <!-- 메타 -->
  <div class="ui-card is-clip arv-meta">
    <table class="ui-tbl arv-meta-tbl">
      <tbody>
        <tr>
          <th style="width:140px;">응답ID</th>
          <td><c:out value="${resp.responseId}"/></td>
        </tr>
        <tr>
          <th>설문ID</th>
          <td><c:out value="${resp.surveyId}"/></td>
        </tr>
        <tr>
          <th>회원</th>
          <td><c:out value="${resp.loginId}"/> (<c:out value="${resp.name}"/>)</td>
        </tr>
        <tr>
          <th>제출일</th>
          <td><fmt:formatDate value="${resp.submittedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
        </tr>
        <tr>
          <th>IP</th>
          <td><c:out value="${resp.ipAddr}"/></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- Q/A -->
  <c:forEach var="it" items="${items}" varStatus="st">
    <div class="ui-card arv-qcard">
      <div class="arv-qhead">
        <p class="arv-qname">
          Q${st.index + 1}. <c:out value="${it.question_text}"/>
        </p>
        <span class="ui-badge"><c:out value="${it.question_type}"/></span>
      </div>

      <c:if test="${not empty it.choice_text}">
        <div class="arv-row">
          <span class="ui-badge">선택</span>
          <span class="arv-text"><c:out value="${it.choice_text}"/></span>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_text}">
        <div class="arv-row">
          <span class="ui-badge">답변</span>
          <div class="arv-box"><c:out value="${it.answer_text}"/></div>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_number}">
        <c:choose>
          <c:when test="${it.question_type eq 'STAR'}">
            <div class="arv-row">
              <span class="ui-badge">별점</span>

              <div class="star5 star5-readonly" data-val="${it.answer_number}">
                <div class="star5-icons" aria-hidden="true">
                  <c:forEach begin="1" end="5" var="i">
                    <svg viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21 16.54 13.97
                               22 9.24 14.81 8.63 12 2
                               9.19 8.63 2 9.24
                               7.46 13.97 5.82 21z"/>
                    </svg>
                  </c:forEach>
                </div>

                <div class="star5-fill" aria-hidden="true">
                  <div class="star5-icons">
                    <c:forEach begin="1" end="5" var="i">
                      <svg viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21 16.54 13.97
                                 22 9.24 14.81 8.63 12 2
                                 9.19 8.63 2 9.24
                                 7.46 13.97 5.82 21z"/>
                      </svg>
                    </c:forEach>
                  </div>
                </div>
              </div>

              <span class="arv-hint">
                (<c:out value="${it.answer_number}"/>/10 = ${it.answer_number/2.0}점)
              </span>
            </div>
          </c:when>

          <c:otherwise>
            <div class="arv-row">
              <span class="ui-badge">값</span>
              <span class="arv-text"><c:out value="${it.answer_number}"/></span>
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>

    </div>
  </c:forEach>

</div>

<script>
(function(){
  var boxes = document.querySelectorAll('.page-admin-response-view .star5-readonly[data-val]');
  for(var i = 0; i < boxes.length; i++){
    var box = boxes[i];
    var v = parseInt(box.getAttribute('data-val'), 10);
    if(!isFinite(v)) v = 0;
    v = Math.max(0, Math.min(10, v));
    var pct = (v / 10) * 100;

    var fill = box.querySelector('.star5-fill');
    if(fill) fill.style.width = pct + '%';
  }
})();
</script>