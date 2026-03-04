package com.dohyun.survey.dto;

import java.util.List;
import java.util.Map;

import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyQuestionVO;

public class SurveyEditFormDTO {
  private SurveyMainVO main;
  private List<SurveyQuestionVO> questions;
  private Map<Long, List<SurveyChoiceVO>> choicesByQuestionId;

  // questionId -> (기존 답: TEXT=answerText / SINGLE,MULTI=choiceId들 / STAR=answerNumber)
  private Map<Long, Object> myAnswerMap;

  private Long responseId;
  
  // getter/setter
  public SurveyMainVO getMain() {
	return main;
  }

  public void setMain(SurveyMainVO main) {
	this.main = main;
  }

  public List<SurveyQuestionVO> getQuestions() {
	return questions;
  }

  public void setQuestions(List<SurveyQuestionVO> questions) {
	this.questions = questions;
  }

  public Map<Long, List<SurveyChoiceVO>> getChoicesByQuestionId() {
	return choicesByQuestionId;
  }

  public void setChoicesByQuestionId(Map<Long, List<SurveyChoiceVO>> choicesByQuestionId) {
	this.choicesByQuestionId = choicesByQuestionId;
  }

  public Map<Long, Object> getMyAnswerMap() {
	return myAnswerMap;
  }

  public void setMyAnswerMap(Map<Long, Object> myAnswerMap) {
	this.myAnswerMap = myAnswerMap;
  }

  public Long getResponseId() {
	return responseId;
  }

  public void setResponseId(Long responseId) {
	this.responseId = responseId;
  }


}