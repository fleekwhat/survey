package com.dohyun.survey.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.dohyun.survey.dto.SurveyEditFormDTO;
import com.dohyun.survey.dto.SurveyViewDTO;
import com.dohyun.survey.vo.MemberVO;
import com.dohyun.survey.vo.SurveyMainVO;

public interface SurveyService {
	void createSurvey(String title, String description, String startAt, String endAt, String payloadJson) throws Exception;
	SurveyViewDTO getSurveyView(Long surveyId, MemberVO member);
	SurveyMainVO getSurveyForUser(Long surveyId, MemberVO member);
	SurveyViewDTO getSurveyViewForUser(long surveyId, MemberVO member);
	List<SurveyMainVO> getAdminSurveyList();
	void updateSurveyAll(SurveyMainVO mainVo, String payloadJson) throws Exception;
	void deleteSurvey(long surveyId);
	List<SurveyMainVO> getActiveSurveyList();
	Long submitResponse(long surveyId, HttpServletRequest request);
	void loadMyResponseDetail(long responseId, MemberVO member, Model model);
	List<Map<String, Object>> getResponsesForAdmin(long surveyId);
	Map<String, Object> getResponseMetaForAdmin(long responseId);
	List<Map<String, Object>> getResponseItemsForAdmin(long responseId);
	/** 수정 화면 데이터 */
	SurveyEditFormDTO getEditFormForUser(long surveyId, long memberId);
	/** 수정 저장 */
	void updateUserResponse(long surveyId, long memberId, Map<String, String[]> paramMap);
	void deleteMyResponse(long responseId, long memberId);
	void submitUserResponse(long surveyId, MemberVO member, HttpServletRequest request);
	boolean hasResponses(long surveyId);
	
	
}
