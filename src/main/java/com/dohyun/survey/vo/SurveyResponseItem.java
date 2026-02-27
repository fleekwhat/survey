package com.dohyun.survey.vo;

import java.math.BigDecimal;
import java.util.Date;

public class SurveyResponseItem {

	private Long itemId;        // PK
    private Long responseId;    // 응답 세션 FK
    private Long questionId;    // 질문 FK
    private Long choiceId;      // 선택지 FK (객관식일 때만)
    private String answerText;  // 주관식 답변
    private BigDecimal answerNumber; // 숫자형 답변 (평점/숫자)
    private Date createdAt;     // 생성시간
    
	public Long getItemId() {
		return itemId;
	}
	public void setItemId(Long itemId) {
		this.itemId = itemId;
	}
	public Long getResponseId() {
		return responseId;
	}
	public void setResponseId(Long responseId) {
		this.responseId = responseId;
	}
	public Long getQuestionId() {
		return questionId;
	}
	public void setQuestionId(Long questionId) {
		this.questionId = questionId;
	}
	public Long getChoiceId() {
		return choiceId;
	}
	public void setChoiceId(Long choiceId) {
		this.choiceId = choiceId;
	}
	public String getAnswerText() {
		return answerText;
	}
	public void setAnswerText(String answerText) {
		this.answerText = answerText;
	}
	public BigDecimal getAnswerNumber() {
		return answerNumber;
	}
	public void setAnswerNumber(BigDecimal answerNumber) {
		this.answerNumber = answerNumber;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
}
