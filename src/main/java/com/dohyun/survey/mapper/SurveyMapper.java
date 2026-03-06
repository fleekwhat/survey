package com.dohyun.survey.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.dohyun.survey.dto.AdminResponseMetaDTO;
import com.dohyun.survey.dto.AdminResponseRowDTO;
import com.dohyun.survey.dto.MyResponseDTO;
import com.dohyun.survey.vo.SurveyChoiceVO;
import com.dohyun.survey.vo.SurveyMainVO;
import com.dohyun.survey.vo.SurveyQuestionVO;
import com.dohyun.survey.vo.SurveyResponseItem;
import com.dohyun.survey.vo.SurveyResponseVO;

public interface SurveyMapper {
	
	// 1) 설문(부모) 저장
	int insertSurveyMain(SurveyMainVO vo);
	
	// 2) 질문(자식) 저장
	int insertSurveyQuestion(SurveyQuestionVO vo);
	
	// 3) 선택지 저장
	int insertSurveyChoice(SurveyChoiceVO vo);
	
	SurveyMainVO selectSurveyMain(@Param("surveyId") long surveyId);
	SurveyMainVO selectActiveSurveyMain(@Param("surveyId") long surveyId);

	List<SurveyQuestionVO> selectSurveyQuestions(@Param("surveyId") long surveyId);

	// 설문 전체 choices(유지 가능)
	List<SurveyChoiceVO> selectSurveyChoicesBySurvey(@Param("surveyId") long surveyId);

	// 질문 1개에 대한 choices (서비스에서 QuestionBlock 만들 때 필요)
	List<SurveyChoiceVO> selectSurveyChoices(@Param("questionId") long questionId);
	
	List<SurveyMainVO> selectAdminSurveyList();
	int updateSurveyMain(SurveyMainVO vo);
	int deleteSurveyChoicesBySurveyId(long surveyId);
	int deleteSurveyQuestionsBySurveyId(long surveyId);
	int deleteSurveyMain(long surveyId);
	
	List<SurveyMainVO> selectActiveSurveyList();
	
	int insertResponse(SurveyResponseVO vo);
	int insertResponseItem(SurveyResponseItem vo);
	
	List<MyResponseDTO> selectMyResponses(Long memberId);
	
	SurveyResponseVO selectResponseById(Long responseId);
	List<Map<String, Object>> selectResponseItemsByResponseId(Long responseId);
	
	List<Map<String, Object>> selectResponsesForAdminBySurvey(Long surveyId);
	Map<String, Object> selectResponseMetaForAdmin(Long responseId);
	
	//중복체크
	int countMyResponse(@Param("surveyId") long surveyId,
						@Param("memberId") long memberId);
	
	// (A) surveyId + memberId 로 내 response_id 가져오기 (수정 대상)
	Long selectMyResponseId(@Param("surveyId") long surveyId,
	                        @Param("memberId") long memberId);

	// (B) response_id 기준으로 기존 item 싹 삭제
	int deleteResponseItems(@Param("responseId") long responseId);

	// (C) response 헤더 updated_at 갱신
	int touchResponse(@Param("responseId") long responseId);

	// (D) 보안: choiceId가 해당 questionId 소속인지 검증
	int existsChoiceInQuestion(@Param("choiceId") long choiceId,
	                           @Param("questionId") long questionId);

	// (옵션) edit.jsp에 기존 응답 채우려면 item 조회가 VO로 있으면 편함
	List<SurveyResponseItem> selectResponseItems(@Param("responseId") long responseId);

	int deleteResponse(long responseId);
	
	int countResponsesBySurveyId(long surveyId);
	
	

}
