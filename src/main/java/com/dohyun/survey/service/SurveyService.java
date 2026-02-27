package com.dohyun.survey.service;

import com.dohyun.survey.dto.SurveyViewDTO;

public interface SurveyService {
	void createSurvey(String title, String description, String startAt, String endAt, String payloadJson) throws Exception;
	SurveyViewDTO getSurveyView(long surveyId);
}
