<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Survey</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/view.css">
</head>

<body>
	<div class="wrap">
	
	  <c:set var="main" value="${survey.main}" />
	
	  <div class="head">
	    <div>
	      <span class="badge">${mode}</span>
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
	    <c:when test="${mode eq 'USER'}">
	      <form id="surveyAnswerForm" method="post" action="${pageContext.request.contextPath}/survey/submit.do">
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
	              <div class="choices">
	                <c:forEach begin="1" end="10" var="v">
	                  <label class="choice">
	                    <input type="radio" name="star_${q.questionId}" value="${v}">
	                    <span>${v} (=${v/2}점)</span>
	                  </label>
	                </c:forEach>
	              </div>
	              <div class="hint">0.5점 단위 (1=0.5점 … 10=5.0점)</div>
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
	
	          <c:if test="${q.questionType eq 'STAR'}">
	            <div class="choices">
	              <c:forEach begin="1" end="10" var="v">
	                <label class="choice">
	                  <input type="radio" disabled>
	                  <span>${v} (=${v/2}점)</span>
	                </label>
	              </c:forEach>
	            </div>
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
		  if(!form) return;
		
		  function showError(card, msg){
		    const box = card.querySelector('.error');
		    if(box){
		      box.textContent = msg;
		      box.style.display = 'block';
		    }
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
		        const v = form.querySelector(`[name="text_${qid}"]`).value.trim();
		        if(required && !v){
		          ok = false;
		          showError(card, '필수 질문입니다.');
		        }
		      }
		
		      if(type === 'SINGLE'){
		        const checked = form.querySelector(`[name="single_${qid}"]:checked`);
		        if(required && !checked){
		          ok = false;
		          showError(card, '하나를 선택하세요.');
		        }
		      }
		
		      if(type === 'MULTI'){
		        const boxes = form.querySelectorAll(`.multi_${qid}:checked`);
		        const min = parseInt(card.dataset.min || "0", 10);
		        const max = parseInt(card.dataset.max || "9999", 10);
		
		        if(required && boxes.length === 0){
		          ok = false;
		          showError(card, '필수 질문입니다.');
		          return;
		        }
		        if(boxes.length > 0){
		          if(boxes.length < min){
		            ok = false;
		            showError(card, `최소 ${min}개 선택해야 합니다.`);
		          } else if(boxes.length > max){
		            ok = false;
		            showError(card, `최대 ${max}개까지만 선택 가능합니다.`);
		          }
		        }
		      }
		
		      if(type === 'STAR'){
		        const checked = form.querySelector(`[name="star_${qid}"]:checked`);
		        if(required && !checked){
		          ok = false;
		          showError(card, '별점을 선택하세요.');
		        }
		      }
		    });
		
		    if(!ok){
		      e.preventDefault();
		      alert('입력값을 확인하세요.');
		    }
		  });
		})();
	</script>

</body>
</html>