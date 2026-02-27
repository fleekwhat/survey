<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><tiles:getAsString name="title"/></title>

  <link rel="stylesheet" href="${ctx}/css/navbar.css">
</head>
<body>

  <jsp:include page="/inc/navbar.jsp"></jsp:include>
  
  <div class="page-container">
    <tiles:insertAttribute name="body"/>
  </div>

</body>
</html>