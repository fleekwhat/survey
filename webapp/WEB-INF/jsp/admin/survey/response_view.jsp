<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>응답 상세</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-response-view.css">
</head>
<body>

<div class="wrap">
  <div class="head">
    <div>
      <span class="badge">RESPONSE</span>
      <span class="badge">${resp.status}</span>
    </div>

    <h1 class="title">응답 상세</h1>

    <div class="meta">
      응답ID: ${resp.response_id}
      / 설문ID: ${resp.survey_id}
      / 회원: ${resp.login_id} (${resp.name})
      / 제출일: <fmt:formatDate value="${resp.submitted_at}" pattern="yyyy-MM-dd HH:mm"/>
      / IP: ${resp.ip_addr}
    </div>
  </div>

  <c:forEach var="it" items="${items}" varStatus="st">
    <div class="qcard">
      <p class="qname">
        Q${st.index + 1}. ${it.question_text}
        <span class="badge">${it.question_type}</span>
      </p>

      <!-- SINGLE/MULTI 선택지 -->
      <c:if test="${not empty it.choice_text}">
        <div class="answer-row">
          <span class="badge">선택</span>
          <span class="answer-text">${it.choice_text}</span>
        </div>
      </c:if>

      <!-- TEXT 답변 -->
      <c:if test="${not empty it.answer_text}">
        <div class="answer-row">
          <span class="badge">답변</span>
          <div class="answer-box">${it.answer_text}</div>
        </div>
      </c:if>

      <!-- STAR/NUMBER 값 -->
      <c:if test="${not empty it.answer_number}">
        <c:choose>
          <c:when test="${it.question_type eq 'STAR'}">
            <div class="answer-row">
              <span class="badge">별점</span>

              <!-- 표시 전용 별(5개) -->
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

                <!-- 채움 레이어(이게 있어야 별이 보임/채워짐) -->
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

              <span class="hint">(${it.answer_number}/10 = ${(it.answer_number)/2.0}점)</span>
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
(function(){
  // STAR 표시: answer_number(1~10) -> 퍼센트(0~100)
  document.querySelectorAll('.star5-readonly[data-val]').forEach(box=>{
    var v = parseInt(box.getAttribute('data-val'), 10);
    if(!isFinite(v) || v < 0) v = 0;
    if(v > 10) v = 10;
    var pct = (v / 10) * 100; // 10단계 -> 100%
    var fill = box.querySelector('.star5-fill');
    if(fill) fill.style.width = pct + '%';
  });
})();
</script>

</body>
</html>