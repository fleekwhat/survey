<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | Create Survey</title>
</head>
<body>
	
	<form id="surveyForm" method="post" action="${pageContext.request.contextPath}/admin/survey/save.do">
		
		<div class="survey-meta">
			<input type="text" name="title" id="title" placeholder="설문 제목" required>
			<textarea name="description" id="description" placeholder="설문 설명"></textarea>
			
			  <label>시작일시</label>
			  <input type="datetime-local" name="startAt" id="startAt">
			
			  <label>종료일시</label>
			  <input type="datetime-local" name="endAt" id="endAt">
		</div>
		
		
		
		<div class="survey-actions">
			<button type="button" id="addQuestion">질문 추가</button>
		</div>
		
		<div id="questionList" class="question-list"></div>
		
		<input type="hidden" name="payload" id="payload">
		
		<div class="survey-submit">
			<button type="submit">저장</button>
		</div>
	</form>
	
	<script>
		(() => {
		  const form = document.getElementById('surveyForm');
		  const qList = document.getElementById('questionList');
		  const addBtn = document.getElementById('addQuestion');
		
		  const TYPE = { TEXT:'TEXT', SINGLE:'SINGLE', MULTI:'MULTI', STAR:'STAR' };
		
		  let questions = [];
		  let nextId = 1;
		
		  function newQuestion() {
		    const q = {
		      id: nextId++,
		      questionText: '',
		      type: TYPE.TEXT,
		      required: true,
		      minSelect: null,
		      maxSelect: null,
		      choices: []
		    };
		    normalize(q);
		    return q;
		  }
		
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
		
		  function toInt(v){
		    const n = parseInt(v, 10);
		    return Number.isFinite(n) ? n : null;
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
		      const showStarHint = (q.type === TYPE.STAR);
		
		      const card = el('div', { class:'question-card', dataset:{ id: q.id } });
		      
		      // head
		      const head = el('div', { class:'q-head' },
		    	el('div', { class:'q-title', text: 'Q' + (idx + 1) }),
		        el('div', { class:'q-tools' },
		          el('button', { type:'button', class:'q-up', text:'▲' }),
		          el('button', { type:'button', class:'q-down', text:'▼' }),
		          el('button', { type:'button', class:'q-del', text:'삭제' })
		        )
		      );
		      card.appendChild(head);
		
		      // question text
		      const rowText = el('div', { class:'q-row' },
		        el('input', { type:'text', class:'q-text', placeholder:'질문 내용을 입력', value: q.questionText })
		      );
		      card.appendChild(rowText);
		
		      // type + required
		      const select = el('select', { class:'q-type' },
		        option(TYPE.TEXT, '주관식'),
		        option(TYPE.SINGLE, '객관식(단일)'),
		        option(TYPE.MULTI, '객관식(복수)'),
		        option(TYPE.STAR, '별점(0.5단위, 5점)')
		      );
		      select.value = q.type; // selected 처리(안전)
		
		      const reqLabel = el('label', { class:'q-req' },
		        el('input', { type:'checkbox', class:'q-required' }),
		        ' 필수'
		      );
		      reqLabel.querySelector('input').checked = !!q.required;
		
		      const rowType = el('div', { class:'q-row q-row-inline' },
		        el('label', { text:'유형' }),
		        select,
		        reqLabel
		      );
		      card.appendChild(rowType);
		
		      // star hint
		      if (showStarHint) {
		        card.appendChild(
		          el('div', { class:'q-hint', text:'별점은 0.5점 단위(총 10단계)로 저장됩니다. (1=0.5점 … 10=5.0점)' })
		        );
		      }
		
		      // multi min/max
		      if (showMultiLimit) {
		        const minInput = el('input', { type:'number', class:'q-min', min:'1', value: (q.minSelect ?? 1) });
		        const maxInput = el('input', { type:'number', class:'q-max', min:'1', value: (q.maxSelect ?? q.choices.length) });
		
		        card.appendChild(
		          el('div', { class:'q-row q-row-inline' },
		            el('label', { text:'최소 선택' }),
		            minInput,
		            el('label', { text:'최대 선택' }),
		            maxInput,
		            el('span', { class:'q-hint-inline', text:'※ 선택지 개수 이하' })
		          )
		        );
		      }
		
		      // choices
		      if (showChoices) {
		        const box = el('div', { class:'choice-box' });
		        const head = el('div', { class:'choice-head' },
		          el('div', { text:'선택지' }),
		          el('button', { type:'button', class:'c-add', text:'선택지 추가' })
		        );
		        box.appendChild(head);
		
		        q.choices.forEach((c, cidx) => {
		          const input = el('input', { type:'text', class:'c-text', placeholder:'선택지 내용', value: c.text, dataset:{ cidx } });
		          const del = el('button', { type:'button', class:'c-del', text:'삭제', dataset:{ cidx } });
		
		          box.appendChild(
		            el('div', { class:'choice-row' }, input, del)
		          );
		        });
		
		        card.appendChild(box);
		      }
		
		      qList.appendChild(card);
		    });
		
		    bindEvents(); // 렌더 후 이벤트 연결
		  }
		
		  function bindEvents(){
		    qList.querySelectorAll('.question-card').forEach(card => {
		      const id = Number(card.dataset.id);
		      const q = questions.find(x => x.id === id);
		      if (!q) return;
		
		      // text
		      const textEl = card.querySelector('.q-text');
		      textEl.oninput = (e) => q.questionText = e.target.value;
		
		      // type
		      const typeEl = card.querySelector('.q-type');
		      typeEl.onchange = (e) => {
		        q.type = e.target.value;
		        normalize(q);
		        render();
		      };
		
		      // required
		      const reqEl = card.querySelector('.q-required');
		      reqEl.onchange = (e) => q.required = e.target.checked;
		
		      // delete
		      card.querySelector('.q-del').onclick = () => {
		        questions = questions.filter(x => x.id !== id);
		        render();
		      };
		
		      // move
		      card.querySelector('.q-up').onclick = () => move(id, -1);
		      card.querySelector('.q-down').onclick = () => move(id, +1);
		
		      // MULTI min/max
		      const minEl = card.querySelector('.q-min');
		      const maxEl = card.querySelector('.q-max');
		      if(minEl && maxEl){
		        minEl.oninput = () => { q.minSelect = toInt(minEl.value); normalize(q); };
		        maxEl.oninput = () => { q.maxSelect = toInt(maxEl.value); normalize(q); };
		      }
		
		      // add choice
		      const addChoiceBtn = card.querySelector('.c-add');
		      if(addChoiceBtn){
		        addChoiceBtn.onclick = () => {
		          q.choices.push({text:''});
		          normalize(q);
		          render();
		        };
		      }
		
		      // choice input/delete
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
		
		  // 제출 전 payload 생성
		  form.addEventListener('submit', (e) => {
		    const title = document.getElementById('title').value.trim();
		    if(!title){ alert('제목은 필수'); e.preventDefault(); return; }
		    if(questions.length === 0){ alert('질문을 1개 이상 추가'); e.preventDefault(); return; }
			
		    // 날짜 검증
		    const s = document.getElementById('startAt').value;
		    const e2 = document.getElementById('endAt').value;
		    if (s && e2 && s > e2) {
		      alert('종료일시는 시작일시 이후여야 함');
		      e.preventDefault();
		      return;
		    }
		    
		    // 질문/선택지 검증
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
			
		    // 모든 검증 통과 후 payload 생성
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
		
		  addBtn.onclick = () => {
		    questions.push(newQuestion());
		    render();
		  };
		
		  // 초기 1문항
		  questions.push(newQuestion());
		  render();
		})();
	</script>
</body>
</html>