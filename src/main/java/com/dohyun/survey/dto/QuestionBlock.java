package com.dohyun.survey.dto;

import java.util.List;

import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyQuestionVO;

public class QuestionBlock {
	private SurveyQuestionVO question;
	private List<SurveyChoiceVO> choices;
	
	public SurveyQuestionVO getQuestion() {
		return question;
	}
	public void setQuestion(SurveyQuestionVO question) {
		this.question = question;
	}
	public List<SurveyChoiceVO> getChoices() {
		return choices;
	}
	public void setChoices(List<SurveyChoiceVO> choices) {
		this.choices = choices;
	}
}
