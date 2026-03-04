<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/respond-response-view.css">

<div class="wrap">
  <div class="head">
    <div>
      <span class="badge">MY RESPONSE</span>
      <span class="badge">${resp.status}</span>
    </div>

    <h1 class="title">내 응답 상세</h1>

    <div class="meta">
      응답번호: ${resp.responseId}
      / 설문ID: ${resp.surveyId}
      / 제출일: <fmt:formatDate value="${resp.submittedAt}" pattern="yyyy-MM-dd HH:mm"/>
    </div>
  </div>

  <c:forEach var="it" items="${items}" varStatus="st">
    <div class="qcard">
      <p class="qname">
        Q${st.index + 1}. ${it.question_text}
        <span class="badge">${it.question_type}</span>
      </p>

      <c:if test="${not empty it.choice_text}">
        <div class="answer-row">
          <span class="badge">선택</span>
          <span class="answer-text">${it.choice_text}</span>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_text}">
        <div class="answer-row">
          <span class="badge">답변</span>
          <div class="answer-box">${it.answer_text}</div>
        </div>
      </c:if>

      <c:if test="${not empty it.answer_number}">
        <c:choose>
        
          <c:when test="${it.question_type eq 'STAR'}">
            <div class="answer-row">
              <span class="badge">별점</span>

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

              <span class="hint">${it.answer_number}/10</span>
            </div>
          </c:when>

         
          <c:otherwise>
            <div class="answer-row">
              <span class="badge">값</span>
              <span class="answer-text">${it.answer_number}</span>
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>
    </div>
  </c:forEach>
</div>

<script>
document.addEventListener('DOMContentLoaded', function(){
  document.querySelectorAll('.star5-readonly').forEach(function(box){
    var v = Number(box.getAttribute('data-val')); // 1~10
    if (!Number.isFinite(v)) v = 0;
    v = Math.max(0, Math.min(10, v));
    var pct = (v / 10) * 100;

    var fill = box.querySelector('.star5-fill');
    if (fill) fill.style.width = pct + '%';
  });
});
</script>