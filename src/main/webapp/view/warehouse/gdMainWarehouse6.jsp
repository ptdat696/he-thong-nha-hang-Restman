<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof WarehouseStaff6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    WarehouseStaff6 staff = (WarehouseStaff6) u;
    String pageTitle = "Trang chủ nhân viên kho";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Trang chủ</h1>
<p class="lead">Xin chào, <strong><%= esc(staff.getFullName()) %></strong>. Chọn chức năng cần dùng.</p>

<section class="menu-group">
  <h2>Kho</h2>
  <div class="menu-grid">
    <button type="button" class="tile" onclick="comingSoon()">Nhập nguyên liệu từ nhà cung cấp</button>
    <button type="button" class="tile" onclick="comingSoon()">Quản lí thông tin nhà cung cấp</button>
  </div>
</section>
<%@ include file="../common/foot.jspf" %>
