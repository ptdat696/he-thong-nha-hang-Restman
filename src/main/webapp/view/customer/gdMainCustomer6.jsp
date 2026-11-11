<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;
    String pageTitle = "Trang chủ khách hàng";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Trang chủ</h1>
<p class="lead">Xin chào, <strong><%= esc(customer.getFullName()) %></strong>. Chọn chức năng cần dùng.</p>

<section class="menu-group">
  <h2>Dành cho khách hàng</h2>
  <div class="menu-grid">
    <button type="button" class="tile" onclick="comingSoon()">Tìm kiếm</button>
    <a class="tile tile-main" id="linkBookTable" href="gdFindTable6.jsp">Đặt bàn</a>
    <a class="tile" href="gdMyReservations6.jsp">Lịch đặt bàn của tôi</a>
    <button type="button" class="tile" onclick="comingSoon()">Đặt món trực tuyến</button>
  </div>
</section>
<%@ include file="../common/foot.jspf" %>
