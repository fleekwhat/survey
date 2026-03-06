<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-response-view">

  <!-- 공통 헤더 컴포넌트 -->
  <div class="ui-card ui-page-head respv-head">
    <div class="respv-badges">
      <span class="ui-badge">MY RESPONSE</span>
      <span class="ui-badge">${resp.status}</span>
    </div>

    <h1 class="ui-page-title">내 응답 상세</h1>

    <p class="ui-page-desc respv-meta">
      응답번호: ${resp.responseId}
      / 설문ID: ${resp.surveyId}
      / 제출일: <fmt:formatDate value="${resp.submittedAt}" pattern="yyyy-MM-dd HH:mm"/>
    </p>
  </div>

  <c:forEach var="it" items="${items}" varStatus="st">
    <div class="ui-card respv-qcard">
      <div class="respv-qhead">
        <p class="respv-qname">
          Q${st.index + 1}. <c:out value="${it.question_text}"/>
        </p>
        <span class="ui-badge"><c:out value="${it.question_type}"/></span>
      </div>

      <c:if test="${not empty it.choice_text}">
        <div class="respv-row">
          <span class="ui-badge">선택</span>
          <span class="respv-text"><c:out value="${it.choice_text}"/></span>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_text}">
        <div class="respv-row">
          <span class="ui-badge">답변</span>
          <div class="respv-box"><c:out value="${it.answer_text}"/></div>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_number}">
        <c:choose>
          <c:when test="${it.question_type eq 'STAR'}">
            <div class="respv-row">
              <span class="ui-badge">별점</span>

              <div class="respv-star5 star5-readonly" data-val="${it.answer_number}">
                <div class="respv-star5-icons" aria-hidden="true">
                  <c:forEach begin="1" end="5" var="i">
                    <svg viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21 16.54 13.97
                               22 9.24 14.81 8.63 12 2
                               9.19 8.63 2 9.24
                               7.46 13.97 5.82 21z"/>
                    </svg>
                  </c:forEach>
                </div>

                <div class="respv-star5-fill" aria-hidden="true">
                  <div class="respv-star5-icons">
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

              <span class="respv-hint"><c:out value="${it.answer_number}"/>/10</span>
            </div>
          </c:when>

          <c:otherwise>
            <div class="respv-row">
              <span class="ui-badge">값</span>
              <span class="respv-text"><c:out value="${it.answer_number}"/></span>
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>

    </div>
  </c:forEach>

</div>

<script>
document.addEventListener('DOMContentLoaded', function(){
  var boxes = document.querySelectorAll('.page-response-view .star5-readonly');
  for(var i = 0; i < boxes.length; i++){
    var box = boxes[i];
    var v = Number(box.getAttribute('data-val'));
    if(!isFinite(v)) v = 0;
    v = Math.max(0, Math.min(10, v));
    var pct = (v / 10) * 100;

    var fill = box.querySelector('.respv-star5-fill');
    if(fill) fill.style.width = pct + '%';
  }
});
</script>