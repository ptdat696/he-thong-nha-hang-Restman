<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof SalesStaff6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    SalesStaff6 staff = (SalesStaff6) u;
    String pageTitle = "Trang chủ nhân viên bán hàng";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Trang chủ</h1>
<p class="lead">Xin chào, <strong><%= esc(staff.getFullName()) %></strong>. Chọn chức năng cần dùng.</p>

<section class="menu-group">
  <h2>Phục vụ tại nhà hàng</h2>
  <div class="menu-grid">
    <button type="button" class="tile" onclick="comingSoon()">Nhận khách</button>
    <button type="button" class="tile" onclick="comingSoon()">Nhận gọi món</button>
    <button type="button" class="tile" onclick="comingSoon()">Nhận thanh toán tại bàn</button>
    <button type="button" class="tile" onclick="comingSoon()">Làm thẻ thành viên</button>
  </div>
</section>

<section class="menu-group">
  <h2>Khách đặt trực tuyến</h2>
  <div class="menu-grid">
    <a class="tile tile-main" href="gdReservationList6.jsp">Xác nhận đặt bàn</a>
    <button type="button" class="tile" onclick="comingSoon()">Xác nhận thông tin đặt món</button>
  </div>
</section>
<%@ include file="../common/foot.jspf" %>
