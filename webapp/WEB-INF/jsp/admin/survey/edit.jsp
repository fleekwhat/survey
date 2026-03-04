<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | Edit Survey</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-edit.css">
</head>
<body>

<c:set var="main" value="${survey.main}" />

<!-- datetime-local value용 문자열 미리 만들어두기 -->
<c:set var="startAtValue" value="" />
<c:set var="endAtValue" value="" />

<c:if test="${not empty main.startAt}">
  <fmt:formatDate value="${main.startAt}" pattern="yyyy-MM-dd'T'HH:mm" var="startAtValue"/>
</c:if>

<c:if test="${not empty main.endAt}">
  <fmt:formatDate value="${main.endAt}" pattern="yyyy-MM-dd'T'HH:mm" var="endAtValue"/>
</c:if>

<div class="admin-form-scope">
	<form id="surveyForm" method="post" action="${pageContext.request.contextPath}/admin/survey/update.do">
	  <input type="hidden" name="surveyId" value="${main.surveyId}">
	  <input type="hidden" name="payload" id="payload">
	
	  <!-- ===== Meta card ===== -->
	  <div class="survey-meta">
	    <h1 class="title">설문 수정</h1>
	
	    <label for="title">제목</label>
	    <input type="text" name="title" id="title" required value="${fn:escapeXml(main.title)}">
	
	    <label for="description">설명</label>
	    <textarea name="description" id="description" rows="4">${fn:escapeXml(main.description)}</textarea>
	
	    <label for="startAt">시작일시</label>
	    <input type="datetime-local" name="startAt" id="startAt" value="${startAtValue}">
	
	    <label for="endAt">종료일시</label>
	    <input type="datetime-local" name="endAt" id="endAt" value="${endAtValue}">
	  </div>
	
	  <!-- ===== Action bar ===== -->
	  <div class="survey-actions">
	    <button type="button" id="addQuestion">질문 추가</button>
	  </div>
	
	  <!-- ===== Question list ===== -->
	  <div id="questionList" class="question-list"></div>
	
	  <!-- ===== Submit area ===== -->
	  <div class="survey-submit">
	    <button type="submit">저장</button>
	    <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/survey/list.do'">목록</button>
	  </div>
	</form>
</div>

<script>
(() => {
  const form = document.getElementById('surveyForm');
  const qList = document.getElementById('questionList');
  const addBtn = document.getElementById('addQuestion');

  const TYPE = { TEXT:'TEXT', SINGLE:'SINGLE', MULTI:'MULTI', STAR:'STAR' };

  // HTML escape된 문자열을 JS에서 원래 문자열로 복원
  function htmlDecode(s){
    if(s == null) return '';
    const ta = document.createElement('textarea');
    ta.innerHTML = s;
    return ta.value;
  }

  function toInt(v){
    const n = parseInt(v, 10);
    return Number.isFinite(n) ? n : null;
  }

  let questions = [];
  let nextId = 1;

  function normalize(q) {
    if (q.type === TYPE.TEXT) {
      q.minSelect = null;
      q.maxSelect = null;
      q.choices = [];
    } else if (q.type === TYPE.SINGLE) {
      q.minSelect = 1;
      q.maxSelect = 1;
      if (!Array.isArray(q.choices) || q.choices.length < 2) q.choices = [{text:''},{text:''}];
    } else if (q.type === TYPE.MULTI) {
      if (!Array.isArray(q.choices) || q.choices.length < 2) q.choices = [{text:''},{text:''}];
      q.minSelect = (q.minSelect == null) ? 1 : q.minSelect;
      q.maxSelect = (q.maxSelect == null) ? q.choices.length : Math.min(q.maxSelect, q.choices.length);
      if (q.minSelect > q.maxSelect) q.minSelect = q.maxSelect;
    } else if (q.type === TYPE.STAR) {
      q.minSelect = 1;
      q.maxSelect = 10;
      q.choices = [];
    }
  }

  // ---------- DOM helpers ----------
  function el(tag, attrs, ...children){
    const node = document.createElement(tag);
    if (attrs) {
      for (const [k, v] of Object.entries(attrs)) {
        if (k === 'class') node.className = v;
        else if (k === 'dataset') Object.assign(node.dataset, v);
        else if (k === 'text') node.textContent = v;
        else if (k.startsWith('on') && typeof v === 'function') node.addEventListener(k.slice(2), v);
        else if (v === true) node.setAttribute(k, k);
        else if (v !== false && v != null) node.setAttribute(k, String(v));
      }
    }
    for (const c of children) {
      if (c == null) continue;
      if (typeof c === 'string') node.appendChild(document.createTextNode(c));
      else node.appendChild(c);
    }
    return node;
  }

  function option(value, label){
    const o = document.createElement('option');
    o.value = value;
    o.textContent = label;
    return o;
  }

  // ---------- render ----------
  function render(){
    qList.innerHTML = '';

    questions.forEach((q, idx) => {
      const showChoices = (q.type === TYPE.SINGLE || q.type === TYPE.MULTI);
      const showMultiLimit = (q.type === TYPE.MULTI);

      const card = el('div', { class:'question-card', dataset:{ id: q.id } });

      // header
      const head = el('div', { class:'q-head' },
        el('div', { class:'q-title', text: 'Q' + (idx + 1) }),
        el('div', { class:'q-tools' },
          el('button', { type:'button', class:'q-up', text:'▲' }),
          el('button', { type:'button', class:'q-down', text:'▼' }),
          el('button', { type:'button', class:'q-del', text:'삭제' })
        )
      );
      card.appendChild(head);

      // 질문 텍스트
      card.appendChild(
        el('div', { class:'q-row' },
          el('input', { type:'text', class:'q-text', placeholder:'질문 내용', value: q.questionText })
        )
      );

      // type select
      const select = el('select', { class:'q-type' },
        option(TYPE.TEXT, '주관식'),
        option(TYPE.SINGLE, '객관식(단일)'),
        option(TYPE.MULTI, '객관식(복수)'),
        option(TYPE.STAR, '별점(0.5단위, 5점)')
      );
      select.value = q.type;

      // required
      const reqLabel = el('label', { class:'q-req' },
        el('input', { type:'checkbox', class:'q-required' }),
        ' 필수'
      );
      reqLabel.querySelector('input').checked = !!q.required;

      card.appendChild(
        el('div', { class:'q-row q-row-inline' },
          el('span', { class:'q-hint-inline', text:'유형' }),
          select,
          reqLabel
        )
      );

      // MULTI min/max
      if (showMultiLimit) {
        const minInput = el('input', { type:'number', class:'q-min', min:'1', value: (q.minSelect ?? 1) });
        const maxInput = el('input', { type:'number', class:'q-max', min:'1', value: (q.maxSelect ?? q.choices.length) });

        card.appendChild(
          el('div', { class:'q-row q-row-inline' },
            el('span', { class:'q-hint-inline', text:'최소' }),
            minInput,
            el('span', { class:'q-hint-inline', text:'최대' }),
            maxInput,
            el('span', { class:'q-hint-inline', text:'(선택지 개수 이하)' })
          )
        );
      }

      // choices
      if (showChoices) {
        const box = el('div', { class:'choice-box' });

        box.appendChild(
          el('div', { class:'choice-head' },
            el('span', { text:'선택지' }),
            el('button', { type:'button', class:'c-add', text:'선택지 추가' })
          )
        );

        q.choices.forEach((c, cidx) => {
          const input = el('input', { type:'text', class:'c-text', placeholder:'선택지', value: c.text, dataset:{ cidx } });
          const del = el('button', { type:'button', class:'c-del', text:'삭제', dataset:{ cidx } });
          box.appendChild(el('div', { class:'choice-row' }, input, del));
        });

        card.appendChild(box);
      } else {
        // 힌트(선택지 없는 타입)
        if(q.type === TYPE.TEXT){
          card.appendChild(el('div', { class:'q-hint', text:'주관식 질문입니다.' }));
        } else if(q.type === TYPE.STAR){
          card.appendChild(el('div', { class:'q-hint', text:'별점은 0.5 단위(최대 5점)로 응답됩니다.' }));
        }
      }

      qList.appendChild(card);
    });

    bindEvents();
  }

  function bindEvents(){
    qList.querySelectorAll('div[data-id]').forEach(card => {
      const id = Number(card.dataset.id);
      const q = questions.find(x => x.id === id);
      if (!q) return;

      const textEl = card.querySelector('.q-text');
      textEl.oninput = (e) => q.questionText = e.target.value;

      const typeEl = card.querySelector('.q-type');
      typeEl.onchange = (e) => {
        q.type = e.target.value;
        normalize(q);
        render();
      };

      const reqEl = card.querySelector('.q-required');
      reqEl.onchange = (e) => q.required = e.target.checked;

      card.querySelector('.q-del').onclick = () => {
        questions = questions.filter(x => x.id !== id);
        render();
      };

      card.querySelector('.q-up').onclick = () => move(id, -1);
      card.querySelector('.q-down').onclick = () => move(id, +1);

      const minEl = card.querySelector('.q-min');
      const maxEl = card.querySelector('.q-max');
      if(minEl && maxEl){
        minEl.oninput = () => { q.minSelect = toInt(minEl.value); normalize(q); };
        maxEl.oninput = () => { q.maxSelect = toInt(maxEl.value); normalize(q); };
      }

      const addChoiceBtn = card.querySelector('.c-add');
      if(addChoiceBtn){
        addChoiceBtn.onclick = () => {
          q.choices.push({text:''});
          normalize(q);
          render();
        };
      }

      card.querySelectorAll('.c-text').forEach(input => {
        input.oninput = (e) => {
          const cidx = Number(e.target.dataset.cidx);
          q.choices[cidx].text = e.target.value;
        };
      });

      card.querySelectorAll('.c-del').forEach(btn => {
        btn.onclick = () => {
          const cidx = Number(btn.dataset.cidx);
          q.choices.splice(cidx, 1);
          normalize(q);
          render();
        };
      });
    });
  }

  function move(id, dir){
    const i = questions.findIndex(q => q.id === id);
    const j = i + dir;
    if(i < 0 || j < 0 || j >= questions.length) return;
    [questions[i], questions[j]] = [questions[j], questions[i]];
    render();
  }

  // ===== 초기 데이터 주입 =====
  const initial = [
    <c:forEach var="b" items="${survey.questions}" varStatus="st">
      {
        id: ${st.index + 1},
        questionText: htmlDecode('${fn:escapeXml(b.question.questionText)}'),
        type: '${fn:escapeXml(b.question.questionType)}',
        required: ${b.question.isRequired == 1 ? "true" : "false"},
        minSelect: <c:choose>
          <c:when test="${empty b.question.minSelect}">null</c:when>
          <c:otherwise>${b.question.minSelect}</c:otherwise>
        </c:choose>,
        maxSelect: <c:choose>
          <c:when test="${empty b.question.maxSelect}">null</c:when>
          <c:otherwise>${b.question.maxSelect}</c:otherwise>
        </c:choose>,
        choices: [
          <c:forEach var="c" items="${b.choices}" varStatus="ct">
            { text: htmlDecode('${fn:escapeXml(c.choiceText)}') }<c:if test="${!ct.last}">,</c:if>
          </c:forEach>
        ]
      }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  if(initial.length > 0){
    questions = initial.map(q => {
      if (q.minSelect === '' || q.minSelect === undefined) q.minSelect = null;
      if (q.maxSelect === '' || q.maxSelect === undefined) q.maxSelect = null;
      normalize(q);
      return q;
    });
    nextId = questions.length + 1;
  } else {
    questions = [{ id:1, questionText:'', type:TYPE.TEXT, required:true, minSelect:null, maxSelect:null, choices:[] }];
    normalize(questions[0]);
    nextId = 2;
  }

  render();

  addBtn.onclick = () => {
    const q = { id: nextId++, questionText:'', type:TYPE.TEXT, required:true, minSelect:null, maxSelect:null, choices:[] };
    normalize(q);
    questions.push(q);
    render();
  };

  // ===== 제출 전 payload 생성 =====
  form.addEventListener('submit', (e) => {
    const title = document.getElementById('title').value.trim();
    if(!title){ alert('제목은 필수'); e.preventDefault(); return; }
    if(questions.length === 0){ alert('질문을 1개 이상 추가'); e.preventDefault(); return; }

    const startAt = document.getElementById('startAt').value;
    const endAt = document.getElementById('endAt').value;
    if(startAt && endAt && startAt > endAt){
      alert('종료일시는 시작일시 이후여야 함');
      e.preventDefault();
      return;
    }

    for(const q of questions){
      if(!q.questionText.trim()){ alert('빈 질문이 있음'); e.preventDefault(); return; }

      if(q.type === TYPE.SINGLE || q.type === TYPE.MULTI){
        if(!q.choices || q.choices.length < 2){ alert('객관식은 선택지 2개 이상'); e.preventDefault(); return; }
        if(q.choices.some(c => !c.text.trim())){ alert('빈 선택지가 있음'); e.preventDefault(); return; }

        if(q.type === TYPE.MULTI){
          if(q.minSelect < 1 || q.maxSelect < 1){ alert('최소/최대는 1 이상'); e.preventDefault(); return; }
          if(q.minSelect > q.maxSelect){ alert('최소 선택이 최대 선택보다 큼'); e.preventDefault(); return; }
          if(q.maxSelect > q.choices.length){ alert('최대 선택은 선택지 개수 이하'); e.preventDefault(); return; }
        }
      }

      if(q.type === TYPE.STAR){
        q.maxSelect = 10;
        q.minSelect = 1;
      }
    }

    const payload = questions.map((q, idx) => ({
      questionText: q.questionText.trim(),
      questionType: q.type,
      isRequired: q.required ? 1 : 0,
      displayOrder: idx + 1,
      minSelect: (q.type === TYPE.MULTI || q.type === TYPE.STAR) ? q.minSelect : (q.type === TYPE.SINGLE ? 1 : null),
      maxSelect: (q.type === TYPE.MULTI || q.type === TYPE.STAR) ? q.maxSelect : (q.type === TYPE.SINGLE ? 1 : null),
      choices: (q.type === TYPE.SINGLE || q.type === TYPE.MULTI)
        ? q.choices.map((c, cidx) => ({
            choiceText: c.text.trim(),
            choiceValue: null,
            displayOrder: cidx + 1
          }))
        : []
    }));

    document.getElementById('payload').value = JSON.stringify(payload);
  });
})();
</script>

</body>
</html>