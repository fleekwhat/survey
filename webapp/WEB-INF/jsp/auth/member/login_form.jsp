<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="page-login">
  <div class="auth-scope">
    <form class="ui-card auth-card"
          action="${pageContext.request.contextPath}/auth/member/login.do"
          method="post">

      <h1 class="auth-title">로그인</h1>

      <label class="auth-label" for="loginId">아이디</label>
      <input class="auth-input"
             type="text"
             id="loginId"
             name="loginId"
             autocomplete="username"
             required>

      <label class="auth-label" for="password">비밀번호</label>
      <input class="auth-input"
             type="password"
             id="password"
             name="password"
             autocomplete="current-password"
             required>

      <button class="ui-btn ui-btn-primary auth-btn" type="submit">로그인</button>
    </form>
  </div>
</div>