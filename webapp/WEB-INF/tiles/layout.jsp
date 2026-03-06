<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><tiles:getAsString name="title"/></title>

  <link rel="icon" href="${ctx}/favicon.ico">
  <link rel="stylesheet" href="${ctx}/css/common/tokens.css">
  <link rel="stylesheet" href="${ctx}/css/common/ui.css">
  <link rel="stylesheet" href="${ctx}/css/common/navbar.css">
  <link rel="stylesheet" href="${ctx}/css/survey/view.css">
  <link rel="stylesheet" href="${ctx}/css/common/breadcrumb.css">
  <link rel="stylesheet" href="${ctx}/css/common/page-head.css">

  <tiles:importAttribute name="css" ignore="true"/>
  <c:if test="${not empty css}">
    <link rel="stylesheet" href="${ctx}${css}">
  </c:if>
</head>
<body>

  <jsp:include page="/inc/navbar.jsp"></jsp:include>

  <div class="page-container">

    <c:if test="${not empty breadcrumbs}">
      <nav class="breadcrumb" aria-label="Breadcrumb">
        <div class="wrap">
          <ol class="breadcrumb-list">
            <c:forEach var="bc" items="${breadcrumbs}" varStatus="st">
              <li class="breadcrumb-item">
                <c:choose>
                  <c:when test="${not empty bc.url}">
                    <a class="breadcrumb-link" href="${bc.url}">
                      <c:out value="${bc.label}" />
                    </a>
                  </c:when>
                  <c:otherwise>
                    <span class="breadcrumb-current" aria-current="page">
                      <c:out value="${bc.label}" />
                    </span>
                  </c:otherwise>
                </c:choose>
              </li>

              <c:if test="${not st.last}">
                <li class="breadcrumb-sep" aria-hidden="true">/</li>
              </c:if>
            </c:forEach>
          </ol>
        </div>
      </nav>
    </c:if>

    <div class="wrap">
      <tiles:insertAttribute name="body"/>
    </div>

  </div>
</body>
</html>