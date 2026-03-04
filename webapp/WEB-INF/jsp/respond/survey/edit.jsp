<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>응답 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/respond-edit.css">
</head>
<body class="page-respond-edit">

<c:set var="main" value="${survey.main}" />

<div class="wrap">
  <h1 class="title">응답 수정</h1>

  <div class="survey-meta">
    <div><b>설문ID:</b> ${main.surveyId}</div>
    <div><b>제목:</b> ${fn:escapeXml(main.title)}</div>
    <div><b>응답ID:</b> ${survey.responseId}</div>
  </div>

  <form id="surveyEditForm" method="post"
        action="${pageContext.request.contextPath}/respond/survey/update.do">
    <input type="hidden" name="surveyId" value="${main.surveyId}" />

  <c:forEach var="q" items="${survey.questions}" varStatus="st">
    <c:set var="qid" value="${q.questionId}" />
    <c:set var="choices" value="${survey.choicesByQuestionId[qid]}" />
    <c:set var="ans" value="${survey.myAnswerMap[qid]}" />

    <div class="qcard"
         data-qid="${qid}"
         data-qtype="${q.questionType}"
         data-required="${q.isRequired}"
         data-min="${q.minSelect}"
         data-max="${q.maxSelect}">

      <p>
        <b>Q${st.index + 1}.</b> ${fn:escapeXml(q.questionText)}
        <c:if test="${q.isRequired == 1}"><span>(필수)</span></c:if>
        <span>[${q.questionType}]</span>
      </p>

      <!-- TEXT -->
      <c:if test="${q.questionType eq 'TEXT'}">
        <textarea name="text_${qid}" rows="4" cols="80"
                  placeholder="답변을 입력하세요">${fn:escapeXml(ans)}</textarea>
      </c:if>

      <!-- SINGLE -->
      <c:if test="${q.questionType eq 'SINGLE'}">
        <c:forEach var="c1" items="${choices}">
          <label>
            <input type="radio"
                   name="single_${qid}"
                   value="${c1.choiceId}"
                   <c:if test="${ans eq c1.choiceId}">checked</c:if> />
            ${fn:escapeXml(c1.choiceText)}
          </label><br/>
        </c:forEach>
      </c:if>

      <!-- MULTI : ans는 List<Long> 또는 long[] 같은 형태로 넣는다고 가정 -->
      <c:if test="${q.questionType eq 'MULTI'}">
        <c:forEach var="c1" items="${choices}">
          <label>
            <input type="checkbox"
                   name="multi_${qid}"
                   value="${c1.choiceId}"
                   <c:if test="${ans ne null and fn:contains(ans, c1.choiceId)}">checked</c:if> />
            ${fn:escapeXml(c1.choiceText)}
          </label><br/>
        </c:forEach>
        <div>최소 ${q.minSelect}개 ~ 최대 ${q.maxSelect}개 선택</div>
      </c:if>

      <!-- STAR (1~10) -->
      <c:if test="${q.questionType eq 'STAR'}">
		  <div class="star5" data-qid="${qid}">
		    <!-- input 10개 -->
		    <c:forEach begin="1" end="10" var="v">
		      <input type="radio"
		             class="star5-input"
		             name="star_${qid}"
		             id="star_${qid}_${v}"
		             value="${v}"
		             <c:if test="${ans eq v}">checked</c:if> />
		    </c:forEach>
		
		    <!-- 클릭 overlay: label 10개 -->
		    <div class="star5-overlay">
		      <c:forEach begin="1" end="10" var="v">
		        <label class="star5-hit"
		               for="star_${qid}_${v}"
		               title="${v/2}점"></label>
		      </c:forEach>
		    </div>
		
		    <!-- 보이는 별 5개 -->
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
		  <div class="star-value" id="starValue_${qid}">선택: -</div>
	</c:if>

      <!-- NUMBER -->
      <c:if test="${q.questionType eq 'NUMBER'}">
        <input type="number" name="number_${qid}" value="${ans}" />
      </c:if>

      <div class="error" style="display:none;color:red;margin-top:6px;"></div>
      <hr/>
    </div>
  </c:forEach>

   <div class="survey-submit">
      <button type="submit">수정 저장</button>
      <button type="button" class="btn-sub" onclick="history.back()">취소</button>
    </div>
  </form>
</div>

<script>
(function(){
  var form = document.getElementById('surveyEditForm');
  if(!form) return;

  function showError(card, msg){
    var box = card.querySelector('.error');
    if(box){ box.textContent = msg; box.style.display = 'block'; }
  }
  function clearError(card){
    var box = card.querySelector('.error');
    if(box) box.style.display = 'none';
  }

  form.addEventListener('submit', function(e){
    var ok = true;

    document.querySelectorAll('.qcard[data-qid]').forEach(function(card){
      clearError(card);

      var qid = (card.dataset.qid || '').trim();
      var type = (card.dataset.qtype || '').trim().toUpperCase();
      var required = ((card.dataset.required || '').trim() === '1');

      if(type === 'TEXT'){
        var el = form.querySelector('[name="text_' + qid + '"]');
        var v = el ? el.value.trim() : '';
        if(required && !v){ ok=false; showError(card,'필수 질문입니다.'); }
      }

      if(type === 'SINGLE'){
        var checked = form.querySelector('[name="single_' + qid + '"]:checked');
        if(required && !checked){ ok=false; showError(card,'하나를 선택하세요.'); }
      }

      if(type === 'MULTI'){
        var min = parseInt(card.dataset.min, 10);
        var max = parseInt(card.dataset.max, 10);
        if(isNaN(min)) min = 0;
        if(isNaN(max)) max = 9999;

        var boxes = form.querySelectorAll('[name="multi_' + qid + '"]:checked');

        if(required && boxes.length === 0){
          ok=false; showError(card,'필수 질문입니다.'); return;
        }
        if(boxes.length > 0){
          if(boxes.length < min){ ok=false; showError(card,'최소 ' + min + '개 선택해야 합니다.'); }
          else if(boxes.length > max){ ok=false; showError(card,'최대 ' + max + '개까지만 선택 가능합니다.'); }
        }
      }
		
      if(type === 'STAR'){
        var checkedStar = form.querySelector('[name="star_' + qid + '"]:checked');
        if(required && !checkedStar){ ok=false; showError(card,'별점을 선택하세요.'); }
      }

      if(type === 'NUMBER'){
        var n = form.querySelector('[name="number_' + qid + '"]');
        var v = n ? n.value.trim() : '';
        if(required && !v){ ok=false; showError(card,'값을 입력하세요.'); }
      }
    });

    if(!ok){
      e.preventDefault();
      alert('입력값을 확인하세요.');
    }
  });
})();

(function(){
	  // ===== 별점 UI 채색 =====
	  document.querySelectorAll('.star5[data-qid]').forEach(box=>{
	    const qid = box.dataset.qid;
	    const out = document.getElementById('starValue_' + qid);

	    function paint(v){
	      const stars = box.querySelectorAll('.star5-icons svg');
	      const full = Math.floor(v / 2);
	      const half = (v % 2 === 1);

	      stars.forEach((s, i)=>{
	        s.style.fill = '#e5e7eb';
	        s.style.clipPath = 'none';

	        if(i < full){
	          s.style.fill = '#f59e0b';
	        } else if(i === full && half){
	          s.style.fill = '#f59e0b';
	          s.style.clipPath = 'inset(0 50% 0 0)';
	        }
	      });

	      if(out) out.textContent = '선택: ' + (v/2).toFixed(1) + '점';
	    }

	    // 변경 시 칠하기
	    box.addEventListener('change', (e)=>{
	      if(e.target && e.target.classList.contains('star5-input')){
	        paint(Number(e.target.value));
	      }
	    });

	    // hover 미리보기
	    box.querySelectorAll('.star5-hit').forEach((lab, idx)=>{
	      lab.addEventListener('mouseenter', ()=> paint(idx + 1));
	    });

	    box.addEventListener('mouseleave', ()=>{
	      const checked = box.querySelector('.star5-input:checked');
	      if(checked) paint(Number(checked.value));
	      else{
	        const stars = box.querySelectorAll('.star5-icons svg');
	        stars.forEach(s=>{ s.style.fill='#e5e7eb'; s.style.clipPath='none'; });
	        if(out) out.textContent = '선택: -';
	      }
	    });

	    // 초기값(기존 응답) 반영
	    const checked = box.querySelector('.star5-input:checked');
	    if(checked) paint(Number(checked.value));
	  });
	})();
</script>

</body>
</html>