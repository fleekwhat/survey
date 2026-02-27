package com.dohyun.survey.vo;

import java.sql.Timestamp;

public class SurveyMainVO {
	private Long surveyId;
	private String title;
    private String description;
    private Timestamp startAt; 
    private Timestamp endAt;
    private String status; // DRAFT 작성중, SCHEDULED 예약됨 (시작전), ACTIVE 진행중, CLOSED 종료
    
	public Long getSurveyId() {
		return surveyId;
	}
	public void setSurveyId(Long surveyId) {
		this.surveyId = surveyId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Timestamp getStartAt() {
		return startAt;
	}
	public void setStartAt(Timestamp startAt) {
		this.startAt = startAt;
	}
	public Timestamp getEndAt() {
		return endAt;
	}
	public void setEndAt(Timestamp endAt) {
		this.endAt = endAt;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
  
    
}
