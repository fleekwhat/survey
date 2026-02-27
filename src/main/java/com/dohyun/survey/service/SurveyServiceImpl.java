package com.dohyun.survey.service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dohyun.survey.dto.QuestionBlock;
import com.dohyun.survey.dto.SurveyChoiceDTO;
import com.dohyun.survey.dto.SurveyQuestionDTO;
import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.mapper.SurveyMapper;
import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyQuestionVO;
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
	public SurveyViewDTO getSurveyView(long surveyId) {
		SurveyMainVO main = surveyMapper.selectSurveyMain(surveyId);
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
}
