package com.dohyun.survey.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.dohyun.survey.mapper.MemberMapper;
import com.dohyun.survey.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	private MemberMapper memberMapper;
	@Autowired
	private PasswordEncoder passwordEncoder; // BCryptPasswordEncoder
		
	@Override
	public MemberVO login(String loginId, String rawPassword) {
		MemberVO m = memberMapper.selectMemberByLoginId(loginId);
		if (m == null) return null;
		
		if (!passwordEncoder.matches(rawPassword, m.getPasswordHash())) {
			return null;
		}
		return m;
	}
}
