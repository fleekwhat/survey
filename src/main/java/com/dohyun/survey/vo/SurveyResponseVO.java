package com.dohyun.survey.vo;

import java.util.Date;

public class SurveyResponseVO {

	private Long responseId;     // PK
    private Long surveyId;       // 설문 ID (FK)
    private String respondentKey; // 응답자 식별키 (UUID/세션 등)
    private String ipAddr;        // IP
    private String userAgent;     // 브라우저
    private String status;        // 상태 (TEMP, SUBMIT 등)
    private Date submittedAt;     // 제출시간
    
	public Long getResponseId() {
		return responseId;
	}
	public void setResponseId(Long responseId) {
		this.responseId = responseId;
	}
	public Long getSurveyId() {
		return surveyId;
	}
	public void setSurveyId(Long surveyId) {
		this.surveyId = surveyId;
	}
	public String getRespondentKey() {
		return respondentKey;
	}
	public void setRespondentKey(String respondentKey) {
		this.respondentKey = respondentKey;
	}
	public String getIpAddr() {
		return ipAddr;
	}
	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}
	public String getUserAgent() {
		return userAgent;
	}
	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getSubmittedAt() {
		return submittedAt;
	}
	public void setSubmittedAt(Date submittedAt) {
		this.submittedAt = submittedAt;
	}
}
