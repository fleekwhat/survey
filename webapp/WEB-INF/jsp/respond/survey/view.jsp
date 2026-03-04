<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Survey</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/view.css">
</head>

<body>
	<div class="wrap">
	
	  <c:set var="main" value="${survey.main}" />
	
	  <div class="head">
	    <div>
	      <span class="badge">${fn:trim(mode)}</span>
	      <span class="badge">${main.status}</span>
	    </div>
	    <h1 class="title">${fn:escapeXml(main.title)}</h1>
	    <c:if test="${not empty main.description}">
	      <p class="desc">${fn:escapeXml(main.description)}</p>
	    </c:if>
	    <div class="meta">
	      <c:if test="${not empty main.startAt}">시작: ${main.startAt}</c:if>
	      <c:if test="${not empty main.endAt}"> / 종료: ${main.endAt}</c:if>
	    </div>
	  </div>
	
	  <!-- USER 모드일 때만 제출 폼 -->
	  <c:choose>
	    <c:when test="${fn:trim(mode) eq 'USER'}">
	      <form id="surveyAnswerForm" method="post" action="${pageContext.request.contextPath}/respond/survey/submit.do">
	        <input type="hidden" name="surveyId" value="${main.surveyId}" />
	
	        <c:forEach var="b" items="${survey.questions}" varStatus="st">
	          <c:set var="q" value="${b.question}" />
	          <c:set var="choices" value="${b.choices}" />
	
	          <div class="qcard" data-qid="${q.questionId}" data-qtype="${q.questionType}"
	               data-required="${q.isRequired}" data-min="${q.minSelect}" data-max="${q.maxSelect}">
	            <p class="qname">
	              Q${st.index + 1}. ${fn:escapeXml(q.questionText)}
	              <c:if test="${q.isRequired == 1}"><span class="req">*필수</span></c:if>
	            </p>
	
	            <!-- TEXT -->
	            <c:if test="${q.questionType eq 'TEXT'}">
	              <textarea name="text_${q.questionId}" placeholder="답변을 입력하세요"></textarea>
	            </c:if>
	
	            <!-- SINGLE -->
	            <c:if test="${q.questionType eq 'SINGLE'}">
	              <div class="choices">
	                <c:forEach var="c" items="${choices}">
	                  <label class="choice">
	                    <input type="radio" name="single_${q.questionId}" value="${c.choiceId}">
	                    <span>${fn:escapeXml(c.choiceText)}</span>
	                  </label>
	                </c:forEach>
	              </div>
	            </c:if>
	
	            <!-- MULTI -->
	            <c:if test="${q.questionType eq 'MULTI'}">
	              <div class="choices">
	                <c:forEach var="c" items="${choices}">
	                  <label class="choice">
	                    <input type="checkbox" class="multi_${q.questionId}" name="multi_${q.questionId}" value="${c.choiceId}">
	                    <span>${fn:escapeXml(c.choiceText)}</span>
	                  </label>
	                </c:forEach>
	              </div>
	              <div class="hint">
	                최소 ${q.minSelect}개 ~ 최대 ${q.maxSelect}개 선택
	              </div>
	            </c:if>
	
	            <!-- STAR -->
		            <c:if test="${q.questionType eq 'STAR'}">
					  <div class="star5" data-qid="${q.questionId}">
					    <!-- input 10개 -->
					    <c:forEach begin="1" end="10" var="v">
					      <input type="radio"
					             class="star5-input"
					             name="star_${q.questionId}"
					             id="star_${q.questionId}_${v}"
					             value="${v}" />
					    </c:forEach>
					
					    <!-- 클릭 overlay: label 10개 -->
					    <div class="star5-overlay">
					      <c:forEach begin="1" end="10" var="v">
					        <label class="star5-hit"
					               for="star_${q.questionId}_${v}"
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
					  <div class="star-value" id="starValue_${q.questionId}">선택: -</div>
					</c:if>
					
	            <div class="error">이 질문을 확인하세요.</div>
	          </div>
	        </c:forEach>
	
	        <div class="submit">
	          <button type="submit" class="btn btn-primary">제출</button>
	        </div>
	      </form>
	    </c:when>
	
	    <c:otherwise>
	      <!-- ADMIN 모드: 미리보기 -->
	      <c:forEach var="b" items="${survey.questions}" varStatus="st">
	        <c:set var="q" value="${b.question}" />
	        <c:set var="choices" value="${b.choices}" />
	
	        <div class="qcard">
	          <p class="qname">
	            Q${st.index + 1}. ${fn:escapeXml(q.questionText)}
	            <c:if test="${q.isRequired == 1}"><span class="req">*필수</span></c:if>
	          </p>
	
	          <c:if test="${q.questionType eq 'TEXT'}">
	            <textarea disabled placeholder="(미리보기) 주관식 답변"></textarea>
	          </c:if>
	
	          <c:if test="${q.questionType eq 'SINGLE'}">
	            <div class="choices">
	              <c:forEach var="c" items="${choices}">
	                <label class="choice">
	                  <input type="radio" disabled>
	                  <span>${fn:escapeXml(c.choiceText)}</span>
	                </label>
	              </c:forEach>
	            </div>
	          </c:if>
	
	          <c:if test="${q.questionType eq 'MULTI'}">
	            <div class="choices">
	              <c:forEach var="c" items="${choices}">
	                <label class="choice">
	                  <input type="checkbox" disabled>
	                  <span>${fn:escapeXml(c.choiceText)}</span>
	                </label>
	              </c:forEach>
	            </div>
	            <div class="hint">최소 ${q.minSelect}개 ~ 최대 ${q.maxSelect}개 선택</div>
	          </c:if>
	
	          <!-- STAR 미리보기 -->
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
	
	      <div class="submit">
	        <button type="button" class="btn" onclick="history.back()">뒤로</button>
	      </div>
	    </c:otherwise>
	  </c:choose>
	
	</div>
	
	<script>
		(function(){
		  const form = document.getElementById('surveyAnswerForm');
		
		  // ===== 1) 제출 검증 =====
		  if(form){
		    function showError(card, msg){
		      const box = card.querySelector('.error');
		      if(box){ box.textContent = msg; box.style.display = 'block'; }
		    }
		    function clearError(card){
		      const box = card.querySelector('.error');
		      if(box) box.style.display = 'none';
		    }
		
		    form.addEventListener('submit', (e) => {
		   		
		      let ok = true;
		
		      document.querySelectorAll('.qcard[data-qid]').forEach(card => {
		        clearError(card);
		
		        const qid = card.dataset.qid;
		        const type = card.dataset.qtype;
		        const required = (card.dataset.required === '1');
		        
		
		        if(type === 'TEXT'){
		        	const qid = (card.dataset.qid || '').trim();
		        	const type = (card.dataset.qtype || '').trim().toUpperCase();
		        	const requiredRaw = (card.dataset.required || '').trim();
		        	const required = (requiredRaw === '1' || requiredRaw.toLowerCase() === 'true');
		          if(required && !v){ ok=false; showError(card, '필수 질문입니다.'); }
		          
		        }
		
		        if(type === 'SINGLE'){
		          const checked = form.querySelector(`[name="single_${qid}"]:checked`);
		          if(required && !checked){ ok=false; showError(card, '하나를 선택하세요.'); }
		        }
		
		        if(type === 'MULTI'){
		        	  const minRaw = card.dataset.min;
		        	  const maxRaw = card.dataset.max;

		        	  let min = parseInt(minRaw, 10);
		        	  let max = parseInt(maxRaw, 10);

		        	  if(isNaN(min)) min = 0;
		        	  if(isNaN(max)) max = 9999;

		        	  // boxes 정의
		        	  const boxes = form.querySelectorAll(`[name="multi_${qid}"]:checked`);

		        	  if(required && boxes.length === 0){
		        	    ok = false;
		        	    showError(card, '필수 질문입니다.');
		        	    return;
		        	  }

		        	  if(boxes.length > 0){
		        	    if(boxes.length < min){
		        	      ok = false;
		        	      showError(card, '최소 ' + min + '개 선택해야 합니다.');
		        	    } else if(boxes.length > max){
		        	      ok = false;
		        	      showError(card, '최대 ' + max + '개까지만 선택 가능합니다.');
		        	    }
		        	  }
		        	}
		
		        if(type === 'STAR'){
		          const checked = form.querySelector(`[name="star_${qid}"]:checked`);
		          if(required && !checked){ ok=false; showError(card, '별점을 선택하세요.'); }
		        }
		      });
		
		      if(!ok){ e.preventDefault(); alert('입력값을 확인하세요.'); }
		    });
		  }
		
		  // ===== 2) 별점 UI 채색 =====
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
		
		    box.addEventListener('change', (e)=>{
		      if(e.target && e.target.classList.contains('star5-input')){
		        paint(Number(e.target.value));
		      }
		    });
		
		    // hover 미리보기(원하면 유지, 싫으면 이 블록 삭제)
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
		  });
		})();
		</script>
	

</body>
</html>