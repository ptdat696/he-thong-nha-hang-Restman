<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
  <% Object u=session.getAttribute("user"); if (!(u instanceof Manager6)) {
    response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp" ); return; } Manager6 manager=(Manager6)
    u; String pageTitle="Trang chủ nhân viên quản lí" ; %>
    <%@ include file="../common/head.jspf" %>
      <h1 class="page-title">Trang chủ</h1>
      <p class="lead">Xin chào, <strong>
          <%= esc(manager.getFullName()) %>
        </strong>. Chọn chức năng cần dùng.</p>

      <section class="menu-group">
        <h2>Xem thống kê</h2>
        <div class="menu-grid">
          <button type="button" class="tile" onclick="comingSoon()">Thống kê món ăn</button>
          <button type="button" class="tile" onclick="comingSoon()">Thống kê nguyên liệu</button>
          <button type="button" class="tile" onclick="comingSoon()">Thống kê khách hàng</button>
          <button type="button" class="tile" onclick="comingSoon()">Thống kê nhà cung cấp</button>
        </div>
      </section>

      <section class="menu-group">
        <h2>Quản lí</h2>
        <div class="menu-grid">
          <a class="tile tile-main" id="linkDishMgmt" href="gdDishManagement6.jsp">Quản lí món ăn</a>
          <button type="button" class="tile" onclick="comingSoon()">Lên combo</button>
        </div>
      </section>
      <%@ include file="../common/foot.jspf" %>