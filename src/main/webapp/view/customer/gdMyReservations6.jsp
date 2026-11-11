<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList,java.text.SimpleDateFormat" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    ArrayList<Reservation6> list;
    Reservation6DAO dao = new Reservation6DAO();
    try {
        list = dao.getReservationsByCustomer(customer.getId());
    } finally {
        dao.close();
    }

    SimpleDateFormat fmtDate = new SimpleDateFormat("dd/MM/yyyy");
    String pageTitle = "Lịch đặt bàn của tôi";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Lịch đặt bàn của tôi</h1>
<p class="lead">Danh sách tất cả đơn đặt bàn bạn đã thực hiện.</p>

<div class="toolbar">
    <span class="count"><%= list.size() %> đơn</span>
    <a class="btn btn-primary" href="gdFindTable6.jsp">+ Đặt bàn mới</a>
</div>

<% if (list.isEmpty()) { %>
<div class="empty">Bạn chưa có đơn đặt bàn nào. <a href="gdFindTable6.jsp">Đặt bàn ngay</a>.</div>
<% } else { %>
<div class="table-wrap">
  <table class="data">
    <thead>
      <tr>
        <th class="stt">STT</th>
        <th>Ngày đặt</th>
        <th>Giờ</th>
        <th>Số bàn</th>
        <th>Sức chứa</th>
        <th>Số khách</th>
        <th>Tên liên hệ</th>
        <th>Điện thoại</th>
        <th>Trạng thái</th>
      </tr>
    </thead>
    <tbody>
    <% int stt = 0; for (Reservation6 r : list) { stt++;
        String dateStr = fmtDate.format(r.getReservationDate());
        String timeStr = r.getReservationTime().toString().substring(0, 5);
        String status  = r.getStatus();
        String badgeCss;
        String statusLabel;
        if (Reservation6.CONFIRMED.equals(status)) {
            badgeCss    = "badge-on";
            statusLabel = "Đã xác nhận";
        } else if (Reservation6.CANCELLED.equals(status)) {
            badgeCss    = "badge-off";
            statusLabel = "Đã hủy";
        } else {
            badgeCss    = "badge-pending";
            statusLabel = "Chờ xác nhận";
        }
    %>
      <tr>
        <td class="stt"><%= stt %></td>
        <td><%= dateStr %></td>
        <td><%= timeStr %></td>
        <td><strong><%= esc(r.getTable().getTableNumber()) %></strong></td>
        <td><%= r.getTable().getCapacity() %> người</td>
        <td><%= r.getNumberOfGuests() %></td>
        <td><%= esc(r.getCustomerName()) %></td>
        <td><%= esc(r.getCustomerPhone()) %></td>
        <td><span class="badge <%= badgeCss %>"><%= statusLabel %></span></td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>
<% } %>

<div style="margin-top:24px;">
  <a class="btn" href="gdMainCustomer6.jsp">← Trang chủ</a>
</div>
<%@ include file="../common/foot.jspf" %>

