<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-my-response">

  <div class="ui-card ui-page-head">
    <h1 class="ui-page-title">진행중 설문</h1>
    <p class="ui-page-desc">현재 참여 가능한 설문 목록입니다.</p>
  </div>

  <c:if test="${empty list}">
    <div class="ui-empty">현재 진행중인 설문이 없습니다.</div>
  </c:if>

  <c:if test="${not empty list}">
    <div class="ui-card is-clip">
      <table class="ui-tbl">
        <thead>
          <tr>
            <th style="width:70px;">No</th>
            <th>제목</th>
            <th style="width:220px;">기간</th>
            <th style="width:120px;">상태</th>
            <th style="width:120px;">참여</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach var="s" items="${list}" varStatus="st">
            <tr>
              <td>${st.index + 1}</td>

              <td class="title-cell">
                ${fn:escapeXml(s.title)}
              </td>

              <td class="period-cell">
                <c:choose>
                  <c:when test="${not empty s.startAt || not empty s.endAt}">
                    <span class="period-inner">
                      <c:if test="${not empty s.startAt}">
                        <fmt:formatDate value="${s.startAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:if>

                      <c:if test="${not empty s.startAt || not empty s.endAt}">
                        <span class="sep">~</span>
                      </c:if>

                      <c:if test="${not empty s.endAt}">
                        <fmt:formatDate value="${s.endAt}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:if>
                    </span>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>

              <td>
                <span class="ui-badge">${s.status}</span>
              </td>

              <td>
                <a class="ui-btn ui-btn-primary ui-btn-sm"
                   href="${pageContext.request.contextPath}/respond/survey/view.do?surveyId=${s.surveyId}">
                  참여
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>

</div>