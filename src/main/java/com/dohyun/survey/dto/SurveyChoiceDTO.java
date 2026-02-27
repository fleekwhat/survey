package com.dohyun.survey.dto;

public class SurveyChoiceDTO {
	private String choiceText;
	private String choiceValue;
	private int displayOrder;
	
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
