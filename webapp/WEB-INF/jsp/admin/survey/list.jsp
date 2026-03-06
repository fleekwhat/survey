<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/survey/admin-list.css">

<div class="page-admin-survey-list">

  <!-- head -->
  <div class="ui-card ui-page-head asl-head">
    <div class="asl-head-top">
      <div class="asl-head-left">
        <h1 class="ui-page-title">설문 관리</h1>
        <p class="ui-page-desc">설문 생성/수정/삭제 및 응답 조회</p>
      </div>

      <div class="asl-head-actions">
        <a class="ui-btn ui-btn-primary ui-btn-sm"
           href="${pageContext.request.contextPath}/admin/survey/form.do">
          설문 생성
        </a>
      </div>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty list}">
      <div class="ui-empty">등록된 설문이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <div class="ui-card is-clip asl-table">
        <table class="ui-tbl">
          <thead>
            <tr>
              <th style="width:70px;">ID</th>
              <th>설문</th>
              <th style="width:110px;">상태</th>
              <th class="col-period" style="width:240px;">기간</th>
              <th style="width:210px;">관리</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="s" items="${list}">
              <tr>
                <td class="id"><c:out value="${s.surveyId}"/></td>

                <td class="title-cell">
                  <a class="link"
                     href="${pageContext.request.contextPath}/admin/survey/view.do?surveyId=${s.surveyId}">
                    <c:out value="${s.title}"/>
                  </a>
                </td>

                <td class="center">
                  <span class="ui-badge"><c:out value="${s.status}"/></span>
                </td>

                <td class="period col-period">
                  <span class="period-inner">
                    <c:choose>
                      <c:when test="${not empty s.startAt && not empty s.endAt}">
                        <fmt:formatDate value="${s.startAt}" pattern="yyyy-MM-dd HH:mm"/>
                        <span class="sep">~</span>
                        <fmt:formatDate value="${s.endAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:when>

                      <c:when test="${not empty s.startAt && empty s.endAt}">
                        <fmt:formatDate value="${s.startAt}" pattern="yyyy-MM-dd HH:mm"/>
                        <span class="sep">~</span>
                        -
                      </c:when>

                      <c:when test="${empty s.startAt && not empty s.endAt}">
                        -
                        <span class="sep">~</span>
                        <fmt:formatDate value="${s.endAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:when>

                      <c:otherwise>
                        -
                      </c:otherwise>
                    </c:choose>
                  </span>
                </td>

                <td class="actions">
                  <a class="ui-btn ui-btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/edit.do?surveyId=${s.surveyId}">
                    수정
                  </a>

                  <form method="post"
                        action="${pageContext.request.contextPath}/admin/survey/delete.do"
                        class="inline"
                        onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="surveyId" value="${s.surveyId}">
                    <button type="submit" class="ui-btn ui-btn-sm ui-btn-danger">삭제</button>
                  </form>

                  <a class="ui-btn ui-btn-sm"
                     href="${pageContext.request.contextPath}/admin/survey/responses.do?surveyId=${s.surveyId}">
                    응답
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>

</div>