package com.dohyun.survey.vo;

public class SurveyChoiceVO {
	private Long choiceId;
    private Long questionId;
    private String choiceText;
    private String choiceValue;
    private int displayOrder;
    
	public Long getChoiceId() {
		return choiceId;
	}
	public void setChoiceId(Long choiceId) {
		this.choiceId = choiceId;
	}
	public Long getQuestionId() {
		return questionId;
	}
	public void setQuestionId(Long questionId) {
		this.questionId = questionId;
	}
	public String getChoiceText() {
		return choiceText;
	}
	public void setChoiceText(String choiceText) {
		this.choiceText = choiceText;
	}
	public String getChoiceValue() {
		return choiceValue;
	}
	public void setChoiceValue(String choiceValue) {
		this.choiceValue = choiceValue;
	}
	public int getDisplayOrder() {
		return displayOrder;
	}
	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}
    
    
}
