package com.dohyun.survey.dto;

import java.util.List;

import com.dohyun.survey.vo.SurveyMainVO;

public class SurveyViewDTO {
	private SurveyMainVO main;
	private List<QuestionBlock> questions;
	
	public SurveyMainVO getMain() {
		return main;
	}
	public void setMain(SurveyMainVO main) {
		this.main = main;
	}
	public List<QuestionBlock> getQuestions() {
		return questions;
	}
	public void setQuestions(List<QuestionBlock> questions) {
		this.questions = questions;
	}
}
