<%@ page contentType="text/html; charset=UTF-8" %>
<div class="error-box">
  <h1>403</h1>
  <p>해당 페이지에 접근할 권한이 없습니다.</p>
  <a class="btn" href="${pageContext.request.contextPath}/respond/survey/main.do">메인으로 이동</a>
</div>

<style>
  .error-box{
    background:#fff; padding:50px; border-radius:10px;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
    text-align:center; max-width:420px; margin:60px auto;
  }
  .error-box h1{ font-size:60px; color:#e74c3c; margin:0 0 10px; }
  .error-box p{ color:#555; margin:0 0 30px; }
  .btn{ display:inline-block; padding:10px 20px; background:#3498db; color:#fff;
        text-decoration:none; border-radius:5px; }
  .btn:hover{ background:#2980b9; }
</style>
