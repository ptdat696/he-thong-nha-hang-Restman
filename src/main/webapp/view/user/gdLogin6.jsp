<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    String pageTitle = "Đăng nhập";
    boolean loginFailed = "1".equals(request.getParameter("error"));
%>
<%@ include file="../common/head.jspf" %>
<div class="login">
  <h1 class="page-title">Đăng nhập</h1>
  <p class="lead">Dùng tài khoản của nhân viên hoặc khách hàng.</p>

  <% if (loginFailed) { %>
  <div class="alert-err">Sai tên đăng nhập hoặc mật khẩu.</div>
  <% } %>

  <form class="form" method="post" action="doLogin6.jsp" autocomplete="off">
    <label for="inUsername">Tên đăng nhập</label>
    <input type="text" id="inUsername" name="inUsername" maxlength="255" required autofocus>

    <label for="inPassword">Mật khẩu</label>
    <input type="password" id="inPassword" name="inPassword" maxlength="255" required>

    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Đăng nhập</button>
    </div>
  </form>

  <div class="demo">
    <strong>Tài khoản mẫu</strong> (mật khẩu chung <code>123456</code>):<br>
    <code>manager</code> &middot; <code>warehouse</code> &middot; <code>sales</code> &middot;
    <code>customer1</code> &middot; <code>customer2</code>
  </div>
</div>
<%@ include file="../common/foot.jspf" %>
