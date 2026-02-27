package com.dohyun.survey.mapper;

import java.util.List;

import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyQuestionVO;

public interface SurveyMapper {
	
	// 1) 설문(부모) 저장
	int insertSurveyMain(SurveyMainVO vo);
	
	// 2) 질문(자식) 저장
	int insertSurveyQuestion(SurveyQuestionVO vo);
	
	// 3) 선택지 저장
	int insertSurveyChoice(SurveyChoiceVO vo);
	
	SurveyMainVO selectSurveyMain(Long surveyId);
	List<SurveyQuestionVO> selectSurveyQuestions(Long surveyId);
	List<SurveyChoiceVO> selectSurveyChoicesBySurvey(Long surveyId);
}
