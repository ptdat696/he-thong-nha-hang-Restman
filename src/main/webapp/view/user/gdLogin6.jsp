<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
  <% String pageTitle="Đăng nhập" ; boolean loginFailed="1" .equals(request.getParameter("error")); %>
    <%@ include file="../common/head.jspf" %>
      <div class="login">
        <h1 class="page-title">Đăng nhập</h1>

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


      </div>
      <%@ include file="../common/foot.jspf" %>