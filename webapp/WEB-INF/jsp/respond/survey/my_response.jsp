<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-my-response">

  <div class="ui-card ui-page-head">
    <h1 class="ui-page-title">내가 제출한 설문</h1>
    <p class="ui-page-desc">내 응답 내역을 확인하고 관리할 수 있습니다.</p>
  </div>


  <c:choose>
    <c:when test="${empty list}">
      <div class="ui-empty">제출한 설문이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <div class="ui-card is-clip">
        <table class="ui-tbl myresp-tbl">
          <thead>
            <tr>
              <th style="width:80px;">No</th>
              <th>설문제목</th>
              <th style="width:120px;">상태</th>
              <th style="width:180px;">제출일</th>
              <th style="width:160px;">관리</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="r" items="${list}" varStatus="st">
              <tr>
                <td class="col-no">${fn:length(list) - st.index}</td>

                <td class="col-title">
                  <a class="title-link"
                     href="${pageContext.request.contextPath}/respond/survey/response_view.do?responseId=${r.responseId}">
                    ${fn:escapeXml(r.surveyTitle)}
                  </a>
                </td>

                <td class="col-status">
                  <span class="ui-badge">${fn:escapeXml(r.status)}</span>
                </td>

                <td class="col-date">
                  <fmt:formatDate value="${r.submittedAt}" pattern="yyyy-MM-dd HH:mm" />
                </td>

                <td class="col-actions">
                  <div class="actions">
                    <c:if test="${r.surveyStatus eq 'ACTIVE'}">
                      <a class="ui-btn ui-btn-sm"
                         href="${pageContext.request.contextPath}/respond/survey/edit.do?surveyId=${r.surveyId}">
                        수정
                      </a>
                    </c:if>

                    <form class="inline" method="post"
                          action="${pageContext.request.contextPath}/respond/survey/delete.do"
                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                      <input type="hidden" name="responseId" value="${r.responseId}">
                      <button class="ui-btn ui-btn-sm ui-btn-danger" type="submit">삭제</button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>

</div>