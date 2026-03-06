<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="main" value="${survey.main}" />

<div class="page-survey-view">

  <div class="ui-card ui-page-head">
	  <div class="sv-head-top">
	    <div class="sv-badges">
	      <span class="ui-badge">${fn:trim(mode)}</span>
	      <span class="ui-badge">${main.status}</span>
	    </div>
	  </div>
	
	  <h1 class="ui-page-title">${fn:escapeXml(main.title)}</h1>
	
	  <c:if test="${not empty main.description}">
	    <p class="ui-page-desc">${fn:escapeXml(main.description)}</p>
	  </c:if>
	
	  <p class="ui-page-desc sv-view-meta">
	    <c:if test="${not empty main.startAt}">
	      시작: <fmt:formatDate value="${main.startAt}" pattern="yyyy-MM-dd HH:mm"/>
	    </c:if>
	    <c:if test="${not empty main.endAt}">
	      <span class="sv-meta-sep">/</span>
	      종료: <fmt:formatDate value="${main.endAt}" pattern="yyyy-MM-dd HH:mm"/>
	    </c:if>
	  </p>
	</div>

  <c:choose>
    <c:when test="${fn:trim(mode) eq 'USER'}">
      <form id="surveyAnswerForm" method="post"
            action="${pageContext.request.contextPath}/respond/survey/submit.do">
        <input type="hidden" name="surveyId" value="${main.surveyId}" />

        <c:forEach var="b" items="${survey.questions}" varStatus="st">
          <c:set var="q" value="${b.question}" />
          <c:set var="choices" value="${b.choices}" />

          <div class="ui-card qcard"
               data-qid="${q.questionId}"
               data-qtype="${q.questionType}"
               data-required="${q.isRequired}"
               data-min="${q.minSelect}"
               data-max="${q.maxSelect}">

            <p class="qname">
              Q${st.index + 1}. ${fn:escapeXml(q.questionText)}
              <c:if test="${q.isRequired == 1}">
                <span class="req">*필수</span>
              </c:if>
            </p>

            <c:if test="${q.questionType eq 'TEXT'}">
              <textarea class="ui-textarea" name="text_${q.questionId}" placeholder="답변을 입력하세요"></textarea>
            </c:if>

            <c:if test="${q.questionType eq 'SINGLE'}">
              <div class="choices">
                <c:forEach var="c1" items="${choices}">
                  <label class="choice">
                    <input type="radio" name="single_${q.questionId}" value="${c1.choiceId}">
                    <span>${fn:escapeXml(c1.choiceText)}</span>
                  </label>
                </c:forEach>
              </div>
            </c:if>

            <c:if test="${q.questionType eq 'MULTI'}">
              <div class="choices">
                <c:forEach var="c1" items="${choices}">
                  <label class="choice">
                    <input type="checkbox" name="multi_${q.questionId}" value="${c1.choiceId}">
                    <span>${fn:escapeXml(c1.choiceText)}</span>
                  </label>
                </c:forEach>
              </div>
              <div class="hint">최소 ${q.minSelect}개 ~ 최대 ${q.maxSelect}개 선택</div>
            </c:if>

            <c:if test="${q.questionType eq 'STAR'}">
              <div class="star5" data-qid="${q.questionId}">
                <c:forEach begin="1" end="10" var="v">
                  <input type="radio"
                         class="star5-input"
                         name="star_${q.questionId}"
                         id="star_${q.questionId}_${v}"
                         value="${v}" />
                </c:forEach>

                <div class="star5-overlay">
                  <c:forEach begin="1" end="10" var="v">
                    <label class="star5-hit"
                           for="star_${q.questionId}_${v}"
                           title="${v/2}점"></label>
                  </c:forEach>
                </div>

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
              </div>

              <div class="hint">0.5점 단위 (1=0.5점 … 10=5.0점)</div>
              <div class="star-value" id="starValue_${q.questionId}">선택: -</div>
            </c:if>

            <div class="error" style="display:none;"></div>
          </div>
        </c:forEach>

        <div class="sv-submit">
          <button type="submit" class="ui-btn ui-btn-primary">제출</button>
        </div>
      </form>
    </c:when>

    <c:otherwise>
      <c:forEach var="b" items="${survey.questions}" varStatus="st">
        <c:set var="q" value="${b.question}" />
        <c:set var="choices" value="${b.choices}" />

        <div class="ui-card qcard preview">
          <p class="qname">
            Q${st.index + 1}. ${fn:escapeXml(q.questionText)}
            <c:if test="${q.isRequired == 1}">
              <span class="req">*필수</span>
            </c:if>
          </p>

          <c:if test="${q.questionType eq 'TEXT'}">
            <textarea class="ui-textarea" disabled placeholder="(미리보기) 주관식 답변"></textarea>
          </c:if>

          <c:if test="${q.questionType eq 'SINGLE'}">
            <div class="choices">
              <c:forEach var="c1" items="${choices}">
                <label class="choice">
                  <input type="radio" disabled>
                  <span>${fn:escapeXml(c1.choiceText)}</span>
                </label>
              </c:forEach>
            </div>
          </c:if>

          <c:if test="${q.questionType eq 'MULTI'}">
            <div class="choices">
              <c:forEach var="c1" items="${choices}">
                <label class="choice">
                  <input type="checkbox" disabled>
                  <span>${fn:escapeXml(c1.choiceText)}</span>
                </label>
              </c:forEach>
            </div>
            <div class="hint">최소 ${q.minSelect}개 ~ 최대 ${q.maxSelect}개 선택</div>
          </c:if>

          <c:if test="${q.questionType eq 'STAR'}">
            <div class="star5 preview">
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
            </div>
            <div class="hint">0.5점 단위 (1=0.5점 … 10=5.0점)</div>
          </c:if>
        </div>
      </c:forEach>

      <div class="sv-submit">
        <button type="button" class="ui-btn" onclick="history.back()">뒤로</button>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<script>
(function(){
  var form = document.getElementById('surveyAnswerForm');
  if(!form) return;

  function showError(card, msg){
    var box = card.querySelector('.error');
    if(box){
      box.textContent = msg;
      box.style.display = 'block';
    }
  }

  function clearError(card){
    var box = card.querySelector('.error');
    if(box){
      box.textContent = '';
      box.style.display = 'none';
    }
  }

  form.addEventListener('submit', function(e){
    var ok = true;
    var firstError = null;

    var cards = form.querySelectorAll('.qcard[data-qid]');
    for(var i = 0; i < cards.length; i++){
      var card = cards[i];
      clearError(card);

      var qid = (card.dataset.qid || '').trim();
      var type = (card.dataset.qtype || '').trim().toUpperCase();
      var requiredRaw = (card.dataset.required || '').trim();
      var required = (requiredRaw === '1' || requiredRaw.toLowerCase() === 'true');

      function fail(msg){
        ok = false;
        showError(card, msg);
        if(!firstError) firstError = card;
      }

      if(type === 'TEXT'){
        var ta = card.querySelector('textarea[name="text_' + qid + '"]');
        var v = ta ? ta.value.trim() : '';
        if(required && !v) fail('필수 질문입니다.');
      }

      if(type === 'SINGLE'){
        var checked = card.querySelector('input[type="radio"][name="single_' + qid + '"]:checked');
        if(required && !checked) fail('하나를 선택하세요.');
      }

      if(type === 'MULTI'){
        var min = parseInt((card.dataset.min || '').trim(), 10);
        var max = parseInt((card.dataset.max || '').trim(), 10);
        if(isNaN(min)) min = 0;
        if(isNaN(max)) max = 9999;

        var boxes = card.querySelectorAll('input[type="checkbox"][name="multi_' + qid + '"]:checked');

        if(required && boxes.length === 0){
          fail('필수 질문입니다.');
        } else if(boxes.length > 0){
          if(boxes.length < min) fail('최소 ' + min + '개 선택해야 합니다.');
          else if(boxes.length > max) fail('최대 ' + max + '개까지만 선택 가능합니다.');
        }
      }

      if(type === 'STAR'){
        var checkedStar = card.querySelector('input[type="radio"][name="star_' + qid + '"]:checked');
        if(required && !checkedStar) fail('별점을 선택하세요.');
      }
    }

    if(!ok){
      e.preventDefault();
      if(firstError && firstError.scrollIntoView){
        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
      alert('입력값을 확인하세요.');
    }
  });
})();

(function(){
  var form = document.getElementById('surveyAnswerForm');
  if(!form) return;

  function paint(box, v){
    var stars = box.querySelectorAll('.star5-icons svg');
    var full = Math.floor(v / 2);
    var half = (v % 2 === 1);

    for(var i = 0; i < stars.length; i++){
      var s = stars[i];
      s.style.fill = '#e5e7eb';
      s.style.clipPath = 'none';

      if(i < full){
        s.style.fill = '#f59e0b';
      } else if(i === full && half){
        s.style.fill = '#f59e0b';
        s.style.clipPath = 'inset(0 50% 0 0)';
      }
    }

    var qid = box.dataset.qid;
    var out = document.getElementById('starValue_' + qid);
    if(out) out.textContent = '선택: ' + (v / 2).toFixed(1) + '점';
  }

  function clearPaint(box){
    var stars = box.querySelectorAll('.star5-icons svg');
    for(var i = 0; i < stars.length; i++){
      stars[i].style.fill = '#e5e7eb';
      stars[i].style.clipPath = 'none';
    }
    var qid = box.dataset.qid;
    var out = document.getElementById('starValue_' + qid);
    if(out) out.textContent = '선택: -';
  }

  var boxes = form.querySelectorAll('.star5[data-qid]');
  for(var b = 0; b < boxes.length; b++){
    (function(box){
      function paintCheckedOrClear(){
        var checked = box.querySelector('.star5-input:checked');
        if(checked) paint(box, Number(checked.value));
        else clearPaint(box);
      }

      box.addEventListener('change', function(e){
        if(e.target && e.target.classList.contains('star5-input')){
          paint(box, Number(e.target.value));
        }
      });

      var hits = box.querySelectorAll('.star5-hit');
      for(var i = 0; i < hits.length; i++){
        (function(idx){
          hits[idx].addEventListener('mouseenter', function(){
            paint(box, idx + 1);
          });
        })(i);
      }

      box.addEventListener('mouseleave', function(){
        paintCheckedOrClear();
      });

      paintCheckedOrClear();
    })(boxes[b]);
  }
})();
</script>