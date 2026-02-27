package com.dohyun.survey.mapper;

import com.dohyun.survey.vo.MemberVO;

public interface MemberMapper {
	
	MemberVO selectMemberByLoginId(String loginId);
}
