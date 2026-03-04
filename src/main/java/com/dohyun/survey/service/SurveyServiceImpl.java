package com.dohyun.survey.service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.dohyun.survey.dto.QuestionBlock;
import com.dohyun.survey.dto.SurveyChoiceDTO;
import com.dohyun.survey.dto.SurveyEditFormDTO;
import com.dohyun.survey.dto.SurveyQuestionDTO;
import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.exception.ForbiddenException;
import com.dohyun.survey.mapper.SurveyMapper;
import com.dohyun.survey.vo.MemberVO;
import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyQuestionVO;
import com.dohyun.survey.vo.SurveyResponseItem;
import com.dohyun.survey.vo.SurveyResponseVO;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class SurveyServiceImpl implements SurveyService {

	@Autowired private SurveyMapper surveyMapper;
	
	
	@Override
	@Transactional
	public void createSurvey(String title, String description, String startAtStr, String endAtStr, String payloadJson) throws Exception {

	  // 1) JSON -> DTO
	  ObjectMapper mapper = new ObjectMapper();
	  List<SurveyQuestionDTO> dtos = mapper.readValue(
	      payloadJson,
	      new com.fasterxml.jackson.core.type.TypeReference<List<SurveyQuestionDTO>>() {}
	  );
	  
	  Timestamp startTs = toTimestamp(startAtStr);
	  Timestamp endTs   = toTimestamp(endAtStr);

	  // 2) survey_main 저장 (부모)
	  SurveyMainVO main = new SurveyMainVO();
	  main.setTitle(title);
	  main.setDescription(description);
	  main.setStatus(calcStatus(startTs, endTs));
	  main.setStartAt(startTs);
	  main.setEndAt(endTs);

	  surveyMapper.insertSurveyMain(main);

	  Long surveyId = main.getSurveyId();
	  if (surveyId == null) {
	    throw new RuntimeException("survey_id 생성 실패(useGeneratedKeys/keyProperty 설정 확인)");
	  }

	  // 3) 질문/선택지 저장
	  for (SurveyQuestionDTO dto : dtos) {

	    SurveyQuestionVO qvo = new SurveyQuestionVO();
	    qvo.setSurveyId(surveyId);
	    qvo.setQuestionText(dto.getQuestionText());
	    qvo.setQuestionType(dto.getQuestionType());
	    qvo.setIsRequired(dto.getIsRequired());   // DTO가 int(0/1)이면 그대로
	    qvo.setDisplayOrder(dto.getDisplayOrder());
	    qvo.setMinSelect(dto.getMinSelect());
	    qvo.setMaxSelect(dto.getMaxSelect());

	    surveyMapper.insertSurveyQuestion(qvo);

	    Long questionId = qvo.getQuestionId();
	    if (questionId == null) {
	      throw new RuntimeException("question_id 생성 실패(useGeneratedKeys/keyProperty 설정 확인)");
	    }

	    // 객관식 선택지만 저장
	    if (dto.getChoices() != null) {
	      for (SurveyChoiceDTO c : dto.getChoices()) {
	        SurveyChoiceVO cvo = new SurveyChoiceVO();
	        cvo.setQuestionId(questionId);
	        cvo.setChoiceText(c.getChoiceText());
	        cvo.setChoiceValue(c.getChoiceValue());
	        cvo.setDisplayOrder(c.getDisplayOrder());

	        surveyMapper.insertSurveyChoice(cvo);
	      }
	    }
	  }
	}
	
	private Timestamp toTimestamp(String s) {
		  if (s == null || s.trim().isEmpty()) return null;
		  return Timestamp.valueOf(s.replace("T", " ") + ":00");
		}
	
	private String calcStatus(Timestamp startAt, Timestamp endAt) {
		  Timestamp now = new Timestamp(System.currentTimeMillis());

		  if (startAt == null && endAt == null) return "DRAFT";

		  if (endAt != null && now.after(endAt)) return "CLOSED";

		  if (startAt != null && now.before(startAt)) return "SCHEDULED";

		  return "ACTIVE";
		}
	
	@Override
	public SurveyViewDTO getSurveyView(Long surveyId, MemberVO member) {
	    SurveyMainVO main = getSurveyForUser(surveyId, member); // 여기서 ADMIN/USER 구분 완료

	    List<SurveyQuestionVO> qs = surveyMapper.selectSurveyQuestions(surveyId);
	    List<SurveyChoiceVO> cs = surveyMapper.selectSurveyChoicesBySurvey(surveyId);
		
		// questionId -> choices
		Map<Long, List<SurveyChoiceVO>> choiceMap = new HashMap<>();
		for (SurveyChoiceVO c : cs) {
			choiceMap.computeIfAbsent(c.getQuestionId(), k -> new ArrayList<>()).add(c);
		}
		
		List<QuestionBlock> blocks = new ArrayList<>();
		for (SurveyQuestionVO q : qs) {
			QuestionBlock b = new QuestionBlock();
			b.setQuestion(q);
			b.setChoices(choiceMap.getOrDefault(q.getQuestionId(), Collections.emptyList()));
			blocks.add(b);
		}
		
		SurveyViewDTO dto = new SurveyViewDTO();
		dto.setMain(main);
		dto.setQuestions(blocks);
		return dto;
	}
	
	// ACTIVE 권한 체크
	
	@Override
	public SurveyMainVO getSurveyForUser(Long surveyId, MemberVO member) {

	    boolean isAdmin = member != null && "ADMIN".equals(member.getRole());

	    SurveyMainVO survey;

	    if (isAdmin) {
	        survey = surveyMapper.selectSurveyMain(surveyId); // 관리자
	    } else {
	        survey = surveyMapper.selectActiveSurveyMain(surveyId); // 일반
	    }

	    if (survey == null) {
	        throw new ForbiddenException("접근 불가 설문");
	    }

	    return survey;
	}
	
	@Override
	public SurveyViewDTO getSurveyViewForUser(long surveyId, MemberVO member) {

	    SurveyMainVO main = getSurveyForUser(surveyId, member); // 여기서 ACTIVE 차단

	    List<SurveyQuestionVO> qList = surveyMapper.selectSurveyQuestions(surveyId);

	    List<QuestionBlock> blocks = new ArrayList<>();
	    for (SurveyQuestionVO q : qList) {
	        QuestionBlock b = new QuestionBlock();
	        b.setQuestion(q);

	        // 선택지 필요한 타입이면 조회 (일단 무조건 조회해도 됨)
	        List<SurveyChoiceVO> choices = surveyMapper.selectSurveyChoices(q.getQuestionId());
	        b.setChoices(choices);

	        blocks.add(b);
	    }

	    SurveyViewDTO dto = new SurveyViewDTO();
	    dto.setMain(main);
	    dto.setQuestions(blocks);
	    return dto;
	}
	
	@Override
	public List<SurveyMainVO> getAdminSurveyList() {
		List<SurveyMainVO> list = surveyMapper.selectAdminSurveyList();
		
		// 상태를 "현재시간 기준"으로 다시 계산해서 덮어쓰기
		for (SurveyMainVO vo : list) {
			vo.setStatus(calculateStatus(vo));
		}
		return list;
	}
	
	@Override
	@Transactional
	public void updateSurveyAll(SurveyMainVO mainVo, String payloadJson) throws Exception {
	    // 1) 메인 업데이트
	    mainVo.setStatus(calculateStatus(mainVo));
	    surveyMapper.updateSurveyMain(mainVo);

	    long surveyId = mainVo.getSurveyId();

	    // 2) 기존 질문/선택지 삭제
	    surveyMapper.deleteSurveyChoicesBySurveyId(surveyId);
	    surveyMapper.deleteSurveyQuestionsBySurveyId(surveyId);
	    

	    // 3) payload 파싱 후 재삽입
	    ObjectMapper om = new ObjectMapper();
	    List<SurveyQuestionDTO> questions = om.readValue(
	        payloadJson,
	        new com.fasterxml.jackson.core.type.TypeReference<List<SurveyQuestionDTO>>() {}
	    );

	    int qOrder = 1;

	    for (SurveyQuestionDTO dto : questions) {
	        SurveyQuestionVO qvo = new SurveyQuestionVO();
	        qvo.setSurveyId(surveyId);
	        qvo.setQuestionText(dto.getQuestionText());
	        qvo.setQuestionType(dto.getQuestionType());
	        qvo.setIsRequired(dto.getIsRequired()); // int(0/1)
	        qvo.setDisplayOrder(dto.getDisplayOrder() > 0 ? dto.getDisplayOrder() : qOrder++);
	        qvo.setMinSelect(dto.getMinSelect());
	        qvo.setMaxSelect(dto.getMaxSelect());

	        surveyMapper.insertSurveyQuestion(qvo); // useGeneratedKeys로 questionId 세팅돼야 함
	        Long questionId = qvo.getQuestionId();

	        // 객관식만 choices 들어온다
	        if (dto.getChoices() != null && !dto.getChoices().isEmpty()) {
	            int cOrder = 1;
	            for (SurveyChoiceDTO cdto : dto.getChoices()) {
	                SurveyChoiceVO cvo = new SurveyChoiceVO();
	                cvo.setQuestionId(questionId);
	                cvo.setChoiceText(cdto.getChoiceText());
	                cvo.setChoiceValue(cdto.getChoiceValue());
	                cvo.setDisplayOrder(cdto.getDisplayOrder() > 0 ? cdto.getDisplayOrder() : cOrder++);

	                surveyMapper.insertSurveyChoice(cvo);
	            }
	        }
	    }
	}
	
	@Override
	@Transactional
	public void deleteSurvey(long surveyId) {
		
		int respCount = surveyMapper.countResponsesBySurveyId(surveyId);
	    if (respCount > 0) {
	        throw new IllegalStateException("응답이 있는 설문은 삭제할 수 없습니다.");
	    }
	    
	    // 1) choices
	    surveyMapper.deleteSurveyChoicesBySurveyId(surveyId);
	    // 2) questions
	    surveyMapper.deleteSurveyQuestionsBySurveyId(surveyId);
	    // 3) main
	    surveyMapper.deleteSurveyMain(surveyId);
	}
	
	@Override
	public List<SurveyMainVO> getActiveSurveyList() {
	    return surveyMapper.selectActiveSurveyList();
	}
	
	
	@Override
	@Transactional
	public Long submitResponse(long surveyId, HttpServletRequest request) {

	    MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	    if (member == null) {
	        // 로그인 안 하면 응답 불가
	        throw new ForbiddenException("로그인 필요");
	    }

	    SurveyResponseVO resp = new SurveyResponseVO();
	    resp.setSurveyId(surveyId);
	    resp.setMemberId(member.getMemberId());           // ✅ 핵심
	    resp.setRespondentKey(getOrCreateRespondentKey(request.getSession())); // 선택
	    resp.setIpAddr(getClientIp(request));
	    resp.setUserAgent(request.getHeader("User-Agent"));
	    resp.setStatus("SUBMIT");

	    surveyMapper.insertResponse(resp);
	    Long responseId = resp.getResponseId();
	    if (responseId == null) throw new IllegalStateException("responseId 생성 실패");
	    
	        // 2) request 파라미터 파싱 → survey_response_item 저장
	        Map<String, String[]> paramMap = request.getParameterMap();

	        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
	            String name = entry.getKey();

	            if ("surveyId".equals(name)) continue;

	            int idx = name.indexOf('_');
	            if (idx < 0) continue;

	            String type = name.substring(0, idx);
	            String qidStr = name.substring(idx + 1);

	            Long questionId;
	            try {
	                questionId = Long.valueOf(qidStr);
	            } catch (NumberFormatException e) {
	                continue;
	            }

	            String[] values = entry.getValue();
	            if (values == null || values.length == 0) continue;

	            if ("text".equals(type)) {
	                String text = trimToNull(values[0]);
	                if (text != null) {
	                    SurveyResponseItem item = new SurveyResponseItem();
	                    item.setResponseId(responseId);
	                    item.setQuestionId(questionId);
	                    item.setAnswerText(text);
	                    surveyMapper.insertResponseItem(item);
	                }

	            } else if ("star".equals(type) || "number".equals(type)) {
	                String v = trimToNull(values[0]);
	                if (v != null) {
	                    SurveyResponseItem item = new SurveyResponseItem();
	                    item.setResponseId(responseId);
	                    item.setQuestionId(questionId);
	                    item.setAnswerNumber(new BigDecimal(v));
	                    surveyMapper.insertResponseItem(item);
	                }

	            } else if ("single".equals(type)) {
	                String v = trimToNull(values[0]);
	                if (v != null) {
	                    SurveyResponseItem item = new SurveyResponseItem();
	                    item.setResponseId(responseId);
	                    item.setQuestionId(questionId);
	                    item.setChoiceId(Long.valueOf(v));
	                    surveyMapper.insertResponseItem(item);
	                }

	            } else if ("multi".equals(type)) {
	                for (int i = 0; i < values.length; i++) {
	                    String v = trimToNull(values[i]);
	                    if (v == null) continue;

	                    SurveyResponseItem item = new SurveyResponseItem();
	                    item.setResponseId(responseId);
	                    item.setQuestionId(questionId);
	                    item.setChoiceId(Long.valueOf(v));
	                    surveyMapper.insertResponseItem(item);
	                }
	            }
	        }

	        return responseId;
	    }
	
		

	    private String trimToNull(String s) {
	        if (s == null) return null;
	        String t = s.trim();
	        return t.length() == 0 ? null : t;
	    }

	    private String getOrCreateRespondentKey(HttpSession session) {
	        Object key = session.getAttribute("RESPONDENT_KEY");
	        if (key != null) return key.toString();

	        String newKey = UUID.randomUUID().toString();
	        session.setAttribute("RESPONDENT_KEY", newKey);
	        return newKey;
	    }

	    private String getClientIp(HttpServletRequest request) {
	        String xff = request.getHeader("X-Forwarded-For");
	        if (xff != null && xff.trim().length() > 0) {
	            String[] parts = xff.split(",");
	            return parts[0].trim();
	        }
	        return request.getRemoteAddr();
	    }
	    
	    @Override
	    public void loadMyResponseDetail(long responseId, MemberVO member, Model model) {

	        boolean isAdmin = member != null && "ADMIN".equals(member.getRole());

	        SurveyResponseVO resp = surveyMapper.selectResponseById(responseId);
	        if (resp == null) throw new ForbiddenException("응답 없음");

	        // 보안: 내 것만
	        if (!isAdmin && (member == null || !resp.getMemberId().equals(member.getMemberId()))) {
	            throw new ForbiddenException("내 응답만 조회 가능");
	        }

	        List<Map<String, Object>> items = surveyMapper.selectResponseItemsByResponseId(responseId);

	        model.addAttribute("resp", resp);
	        model.addAttribute("items", items);
	    }
	    
	    @Override
	    public List<Map<String, Object>> getResponsesForAdmin(long surveyId) {
	        return surveyMapper.selectResponsesForAdminBySurvey(surveyId);
	    }
	    
	    @Override
	    public Map<String, Object> getResponseMetaForAdmin(long responseId) {
	        Map<String, Object> resp = surveyMapper.selectResponseMetaForAdmin(responseId);
	        if (resp == null) throw new ForbiddenException("응답 없음");
	        return resp;
	    }
	    	
	    @Override
	    public List<Map<String, Object>> getResponseItemsForAdmin(long responseId) {
	        return surveyMapper.selectResponseItemsByResponseId(responseId);
	    }
	    
	    /** 수정 화면 데이터 */
	    @Override
	    public SurveyEditFormDTO getEditFormForUser(long surveyId, long memberId) {

	      // 1) 설문(활성만 수정 허용 추천)
	      SurveyMainVO main = surveyMapper.selectActiveSurveyMain(surveyId);
	      if (main == null) throw new RuntimeException("수정 가능한 설문이 아님");

	      // 2) 본인 응답 존재 확인
	      // 너가 mapper에 추가해야 함: selectMyResponseId
	      Long responseId = surveyMapper.selectMyResponseId(surveyId, memberId);
	      if (responseId == null) throw new RuntimeException("기존 응답이 없음");

	      // 3) 질문 + 선택지
	      List<SurveyQuestionVO> questions = surveyMapper.selectSurveyQuestions(surveyId);

	      Map<Long, List<SurveyChoiceVO>> choicesByQ = new HashMap<>();
	      for (SurveyQuestionVO q : questions) {
	        List<SurveyChoiceVO> choices = surveyMapper.selectSurveyChoices(q.getQuestionId());
	        choicesByQ.put(q.getQuestionId(), choices);
	      }

	      // 4) 내 기존 답 items (VO로 가져오는 걸 추천)
	      List<SurveyResponseItem> items = surveyMapper.selectResponseItems(responseId);

	      // questionId -> 답 매핑
	      Map<Long, Object> answerMap = buildAnswerMap(questions, items);

	      SurveyEditFormDTO dto = new SurveyEditFormDTO();
	      dto.setMain(main);
	      dto.setQuestions(questions);
	      dto.setChoicesByQuestionId(choicesByQ);
	      dto.setMyAnswerMap(answerMap);
	      dto.setResponseId(responseId);

	      return dto;
	    }

	    /** 수정 저장 */
	    @Override
	    @Transactional
	    public void updateUserResponse(long surveyId, long memberId, Map<String, String[]> paramMap) {

	      // 1) 설문 상태 체크(활성 설문만)
	      SurveyMainVO main = surveyMapper.selectActiveSurveyMain(surveyId);
	      if (main == null) throw new RuntimeException("수정 가능한 설문이 아님");

	      // 2) 내 responseId 확보
	      Long responseId = surveyMapper.selectMyResponseId(surveyId, memberId);
	      if (responseId == null) throw new RuntimeException("기존 응답이 없음");

	      // 3) 질문 목록 조회(서버 검증 기준)
	      List<SurveyQuestionVO> questions = surveyMapper.selectSurveyQuestions(surveyId);

	      // 4) 파싱 + 검증 + item 생성
	      List<SurveyResponseItem> newItems = new ArrayList<>();

	      for (SurveyQuestionVO q : questions) {
	        long qid = q.getQuestionId();
	        String type = q.getQuestionType(); // TEXT/SINGLE/MULTI/STAR 가정
	        boolean required = (q.getIsRequired() == 1);

	        if ("TEXT".equals(type)) {
	          String v = first(paramMap, "text_" + qid);
	          if (required && isBlank(v)) throw new RuntimeException("필수 질문 누락");
	          if (!isBlank(v)) newItems.add(itemText(responseId, qid, v.trim()));
	        }

	        else if ("SINGLE".equals(type)) {
	          String v = first(paramMap, "single_" + qid);
	          if (required && isBlank(v)) throw new RuntimeException("필수 질문 누락");
	          if (!isBlank(v)) {
	            long choiceId = Long.parseLong(v);

	            // 보안 검증: choiceId가 해당 questionId 소속인지
	            if (surveyMapper.existsChoiceInQuestion(choiceId, qid) == 0)
	              throw new RuntimeException("잘못된 선택지");

	            newItems.add(itemChoice(responseId, qid, choiceId));
	          }
	        }

	        else if ("MULTI".equals(type)) {
	          String[] vs = paramMap.get("multi_" + qid);
	          int count = (vs == null ? 0 : vs.length);

	          if (required && count == 0) throw new RuntimeException("필수 질문 누락");

	          Integer min = q.getMinSelect();
	          Integer max = q.getMaxSelect();
	          if (count > 0) {
	            if (min != null && count < min) throw new RuntimeException("최소 선택 미만");
	            if (max != null && count > max) throw new RuntimeException("최대 선택 초과");
	          }

	          if (vs != null) {
	            for (String v : vs) {
	              long choiceId = Long.parseLong(v);
	              if (surveyMapper.existsChoiceInQuestion(choiceId, qid) == 0)
	                throw new RuntimeException("잘못된 선택지");
	              newItems.add(itemChoice(responseId, qid, choiceId));
	            }
	          }
	        }

	        else if ("STAR".equals(type)) {
	          String v = first(paramMap, "star_" + qid); // 1~10 저장
	          if (required && isBlank(v)) throw new RuntimeException("필수 질문 누락");
	          if (!isBlank(v)) {
	            int n = Integer.parseInt(v);
	            if (n < 1 || n > 10) throw new RuntimeException("별점 범위 오류");
	            newItems.add(itemNumber(responseId, qid, new BigDecimal(n)));
	          }
	        }
	      }

	      // 5) 기존 item 삭제 -> 재삽입
	      surveyMapper.deleteResponseItems(responseId);
	      for (SurveyResponseItem it : newItems) {
	        surveyMapper.insertResponseItem(it);
	      }

	      // 6) response updated_at 갱신
	      surveyMapper.touchResponse(responseId);
	    }
	    
	    @Override
	    @Transactional
	    public void deleteMyResponse(long responseId, long memberId) {

	      SurveyResponseVO resp = surveyMapper.selectResponseById(responseId);
	      if (resp == null) throw new RuntimeException("응답 없음");

	      // 본인 응답만 삭제 가능
	      // SurveyResponseVO 안에 memberId 필드가 있어야 함 (없으면 아래 '3) VO 확인' 참고)
	      if (resp.getMemberId() == null || resp.getMemberId().longValue() != memberId) {
	        throw new RuntimeException("본인 응답만 삭제 가능");
	      }

	      // (선택) 상태 체크로 삭제 제한 걸고 싶으면 여기서
	      // if(!"SUBMITTED".equals(resp.getStatus())) throw new RuntimeException("삭제 불가 상태");

	      // response만 삭제하면 response_item은 FK ON DELETE CASCADE로 자동 삭제됨
	      surveyMapper.deleteResponse(responseId);
	    }

	    // ---------- helpers ----------

	    private Map<Long, Object> buildAnswerMap(List<SurveyQuestionVO> questions, List<SurveyResponseItem> items) {

	    	  // questionId -> questionType
	    	  Map<Long, String> typeByQid = new HashMap<>();
	    	  for (SurveyQuestionVO q : questions) {
	    	    typeByQid.put(q.getQuestionId(), q.getQuestionType());
	    	  }

	    	  // MULTI는 누적 필요
	    	  Map<Long, List<Long>> multiTemp = new HashMap<>();

	    	  Map<Long, Object> ansMap = new HashMap<>();

	    	  for (SurveyResponseItem it : items) {
	    	    long qid = it.getQuestionId();
	    	    String type = typeByQid.get(qid);
	    	    if (type == null) continue;

	    	    if ("TEXT".equals(type)) {
	    	      ansMap.put(qid, it.getAnswerText()); // String
	    	    }
	    	    else if ("SINGLE".equals(type)) {
	    	      ansMap.put(qid, it.getChoiceId()); // Long
	    	    }
	    	    else if ("MULTI".equals(type)) {
	    	      if (it.getChoiceId() != null) {
	    	        multiTemp.computeIfAbsent(qid, k -> new ArrayList<>()).add(it.getChoiceId());
	    	      }
	    	    }
	    	    else if ("STAR".equals(type) || "NUMBER".equals(type)) {
	    	      // BigDecimal -> Integer로 정규화 (JSP checked 비교용)
	    	      if (it.getAnswerNumber() != null) {
	    	        ansMap.put(qid, it.getAnswerNumber().intValue());
	    	      }
	    	    }
	    	  }

	    	  // MULTI: JSP contains 안전하게 "|id|" 포맷 문자열로 변환
	    	  for (Map.Entry<Long, List<Long>> e : multiTemp.entrySet()) {
	    	    StringBuilder sb = new StringBuilder("|");
	    	    for (Long cid : e.getValue()) {
	    	      sb.append(cid).append("|");
	    	    }
	    	    ansMap.put(e.getKey(), sb.toString());
	    	  }

	    	  return ansMap;
	    	}

	    private static String first(Map<String, String[]> map, String key) {
	      String[] arr = map.get(key);
	      return (arr == null || arr.length == 0) ? null : arr[0];
	    }

	    private static boolean isBlank(String s) {
	      return s == null || s.trim().isEmpty();
	    }

	    private static SurveyResponseItem itemText(long responseId, long qid, String text) {
	      SurveyResponseItem vo = new SurveyResponseItem();
	      vo.setResponseId(responseId);
	      vo.setQuestionId(qid);
	      vo.setAnswerText(text);
	      return vo;
	    }

	    private static SurveyResponseItem itemChoice(long responseId, long qid, long choiceId) {
	      SurveyResponseItem vo = new SurveyResponseItem();
	      vo.setResponseId(responseId);
	      vo.setQuestionId(qid);
	      vo.setChoiceId(choiceId);
	      return vo;
	    }

	    private static SurveyResponseItem itemNumber(long responseId, long qid, BigDecimal num) {
	      SurveyResponseItem vo = new SurveyResponseItem();
	      vo.setResponseId(responseId);
	      vo.setQuestionId(qid);
	      vo.setAnswerNumber(num);
	      return vo;
	    }
	  
	    @Override
	    @Transactional
	    public void submitUserResponse(long surveyId, MemberVO member, HttpServletRequest request) {

	        // 0) 중복 제출 체크
	        int already = surveyMapper.countMyResponse(surveyId, member.getMemberId());
	        if (already > 0) {
	            throw new ForbiddenException("이미 제출한 설문입니다.");
	        }

	        // 1) survey_response 저장
	        SurveyResponseVO resp = new SurveyResponseVO();
	        resp.setSurveyId(surveyId);
	        resp.setMemberId(member.getMemberId());
	        resp.setRespondentKey(getOrCreateRespondentKey(request.getSession()));
	        resp.setIpAddr(getClientIp(request));
	        resp.setUserAgent(request.getHeader("User-Agent"));
	        resp.setStatus("SUBMIT");

	        surveyMapper.insertResponse(resp);
	        Long responseId = resp.getResponseId();

	        // 2) response_item 저장
	        Map<String, String[]> paramMap = request.getParameterMap();

	        int inserted = 0;

	        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {

	            String name = entry.getKey();
	            if ("surveyId".equals(name)) continue;

	            int idx = name.indexOf('_');
	            if (idx < 0) continue;

	            String type = name.substring(0, idx);
	            String qidStr = name.substring(idx + 1);

	            Long questionId;
	            try {
	                questionId = Long.valueOf(qidStr);
	            } catch (NumberFormatException e) {
	                continue;
	            }

	            String[] values = entry.getValue();
	            if (values == null || values.length == 0) continue;

	            if ("text".equals(type)) {
	                String text = trimToNull(values[0]);
	                if (text == null) continue;

	                SurveyResponseItem item = new SurveyResponseItem();
	                item.setResponseId(responseId);
	                item.setQuestionId(questionId);
	                item.setAnswerText(text);
	                inserted += surveyMapper.insertResponseItem(item);

	            } else if ("single".equals(type)) {
	                String v = trimToNull(values[0]);
	                if (v == null) continue;

	                SurveyResponseItem item = new SurveyResponseItem();
	                item.setResponseId(responseId);
	                item.setQuestionId(questionId);
	                item.setChoiceId(Long.valueOf(v));
	                inserted += surveyMapper.insertResponseItem(item);

	            } else if ("multi".equals(type)) {
	                for (int i = 0; i < values.length; i++) {
	                    String v = trimToNull(values[i]);
	                    if (v == null) continue;

	                    SurveyResponseItem item = new SurveyResponseItem();
	                    item.setResponseId(responseId);
	                    item.setQuestionId(questionId);
	                    item.setChoiceId(Long.valueOf(v));
	                    inserted += surveyMapper.insertResponseItem(item);
	                }

	            } else if ("star".equals(type) || "number".equals(type)) {
	                String v = trimToNull(values[0]);
	                if (v == null) continue;

	                SurveyResponseItem item = new SurveyResponseItem();
	                item.setResponseId(responseId);
	                item.setQuestionId(questionId);
	                item.setAnswerNumber(new BigDecimal(v));
	                inserted += surveyMapper.insertResponseItem(item);
	            }
	        }

	        // 3) 최소 방어: 아무 답도 없으면 롤백시키기
	        if (inserted == 0) {
	            throw new IllegalArgumentException("제출 값이 없습니다.");
	        }
	    }
	    
	    @Override
	    public boolean hasResponses(long surveyId) {
		    return surveyMapper.countResponsesBySurveyId(surveyId) > 0;
		}
	
	
	// status 자동 계산
	private String calculateStatus(SurveyMainVO vo) {
		Timestamp now = new Timestamp(System.currentTimeMillis());
		
		if (vo.getStartAt() == null) return "DRAFT";
		
		if (now.before(vo.getStartAt())) return "READY";
		
		if (vo.getEndAt() != null && now.after(vo.getEndAt())) return "CLOSED";
		
		return "ACTIVE";
    }
	
	
	
}
