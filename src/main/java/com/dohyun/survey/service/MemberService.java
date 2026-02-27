package com.dohyun.survey.service;

import java.awt.List;

import com.dohyun.survey.vo.MemberVO;

public interface MemberService {
	
	MemberVO login(String loginId, String rawPassword);
}
