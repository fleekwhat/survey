package com.dohyun.survey.vo;

import java.sql.Timestamp;

public class SurveyQuestionVO {
	private Long questionId;
    private Long surveyId;
    private String questionText;
    private String questionType;
    private int isRequired;      // 0/1
    private int displayOrder;
    private Integer minSelect;
    private Integer maxSelect;
    private Timestamp createdAt;
    
	public Long getQuestionId() {
		return questionId;
	}
	public void setQuestionId(Long questionId) {
		this.questionId = questionId;
	}
	public Long getSurveyId() {
		return surveyId;
	}
	public void setSurveyId(Long surveyId) {
		this.surveyId = surveyId;
	}
	public String getQuestionText() {
		return questionText;
	}
	public void setQuestionText(String questionText) {
		this.questionText = questionText;
	}
	public String getQuestionType() {
		return questionType;
	}
	public void setQuestionType(String questionType) {
		this.questionType = questionType;
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
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
    
    
}
