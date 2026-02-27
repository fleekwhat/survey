package com.dohyun.survey.dto;

import java.util.List;

public class SurveyQuestionDTO {
	private String questionText;
	private String questionType;
	private int isRequired;
	private int displayOrder;
	private Integer minSelect;
	private Integer maxSelect;
	private List<SurveyChoiceDTO> choices;
	
	public String getQuestionText() {
		return questionText;
	}
	public void setQuestionText(String qeustionText) {
		this.questionText = qeustionText;
	}
	public String getQuestionType() {
		return questionType;
	}
	public void setQuestionType(String qeustionType) {
		this.questionType = qeustionType;
	}
	public int getIsRequired() {
		return isRequired;
	}
	public void setIsRequired(int isRequired) {
		this.isRequired = isRequired;
	}
	public int getDisplayOrder() {
		return displayOrder;
	}
	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}
	public Integer getMinSelect() {
		return minSelect;
	}
	public void setMinSelect(Integer minSelect) {
		this.minSelect = minSelect;
	}
	public Integer getMaxSelect() {
		return maxSelect;
	}
	public void setMaxSelect(Integer maxSelect) {
		this.maxSelect = maxSelect;
	}
	public List<SurveyChoiceDTO> getChoices() {
		return choices;
	}
	public void setChoices(List<SurveyChoiceDTO> choices) {
		this.choices = choices;
	}
	
	
}
