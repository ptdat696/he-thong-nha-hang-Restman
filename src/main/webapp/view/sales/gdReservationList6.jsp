<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList,java.text.SimpleDateFormat" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof SalesStaff6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    SalesStaff6 staff = (SalesStaff6) u;

    // Lọc theo trạng thái nếu có
    String filterStatus = request.getParameter("status");
    if (filterStatus == null) filterStatus = "";

    ArrayList<Reservation6> allList;
    Reservation6DAO dao = new Reservation6DAO();
    try {
        allList = dao.getAllReservations();
    } finally {
        dao.close();
    }

    // Lọc theo trạng thái
    ArrayList<Reservation6> list = new ArrayList<Reservation6>();
    for (Reservation6 r : allList) {
        if (filterStatus.isEmpty() || filterStatus.equals(r.getStatus())) {
            list.add(r);
        }
    }

    // Đếm theo trạng thái
    int cntPending = 0, cntConfirmed = 0, cntCancelled = 0;
    for (Reservation6 r : allList) {
        if (Reservation6.PENDING.equals(r.getStatus()))   cntPending++;
        else if (Reservation6.CONFIRMED.equals(r.getStatus())) cntConfirmed++;
        else if (Reservation6.CANCELLED.equals(r.getStatus())) cntCancelled++;
    }

    SimpleDateFormat fmtDate = new SimpleDateFormat("dd/MM/yyyy");
    String pageTitle = "Quản lí đặt bàn";

    // Thông báo kết quả xác nhận/hủy
    String msg = request.getParameter("msg");
    String msgText = null;
    boolean msgOk = true;
    if ("confirmed".equals(msg))  { msgText = "Đã xác nhận đơn thành công."; }
    else if ("cancelled".equals(msg)) { msgText = "Đã hủy đơn thành công."; }
    else if ("nochange".equals(msg))  { msgText = "Đơn đã được xử lý trước đó (không còn ở trạng thái Chờ)."; msgOk = false; }
    else if ("error".equals(msg))     { msgText = "Có lỗi xảy ra, vui lòng thử lại."; msgOk = false; }
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Xác nhận đặt bàn</h1>
<p class="lead">Danh sách tất cả đơn đặt bàn của khách hàng.</p>

<% if (msgText != null) { %>
<div class="<%= msgOk ? "notice" : "notice notice-err" %>" style="margin-bottom:20px;">
  <p style="margin:0;font-weight:600;"><%= esc(msgText) %></p>
</div>
<% } %>

<!-- Thống kê nhanh -->
<div style="display:flex;gap:12px;flex-wrap:wrap;margin-bottom:20px;">
  <a href="gdReservationList6.jsp" class="btn <%= filterStatus.isEmpty() ? "btn-primary" : "" %>">
    Tất cả (<%= allList.size() %>)
  </a>
  <a href="gdReservationList6.jsp?status=PENDING" class="btn <%= "PENDING".equals(filterStatus) ? "btn-primary" : "" %>">
    Chờ xác nhận (<%= cntPending %>)
  </a>
  <a href="gdReservationList6.jsp?status=CONFIRMED" class="btn <%= "CONFIRMED".equals(filterStatus) ? "btn-primary" : "" %>">
    Đã xác nhận (<%= cntConfirmed %>)
  </a>
  <a href="gdReservationList6.jsp?status=CANCELLED" class="btn <%= "CANCELLED".equals(filterStatus) ? "btn-primary" : "" %>">
    Đã hủy (<%= cntCancelled %>)
  </a>
</div>

<div class="toolbar">
  <span class="count"><%= list.size() %> đơn</span>
</div>

<% if (list.isEmpty()) { %>
<div class="empty">Không có đơn nào trong mục này.</div>
<% } else { %>
<div class="table-wrap">
  <table class="data">
    <thead>
      <tr>
        <th class="stt">STT</th>
        <th>Mã đơn</th>
        <th>Ngày đặt</th>
        <th>Giờ</th>
        <th>Số bàn</th>
        <th>Tên liên hệ</th>
        <th>Điện thoại</th>
        <th>Khách hàng</th>
        <th>Trạng thái</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
    <% int stt = 0; for (Reservation6 r : list) { stt++;
        String dateStr  = fmtDate.format(r.getReservationDate());
        String timeStr  = r.getReservationTime().toString().substring(0, 5);
        String status   = r.getStatus();
        String badgeCss, statusLabel;
        if (Reservation6.CONFIRMED.equals(status)) {
            badgeCss = "badge-on"; statusLabel = "Đã xác nhận";
        } else if (Reservation6.CANCELLED.equals(status)) {
            badgeCss = "badge-off"; statusLabel = "Đã hủy";
        } else {
            badgeCss = "badge-pending"; statusLabel = "Chờ xác nhận";
        }
        String custFullName = (r.getCustomer() != null && r.getCustomer().getFullName() != null)
                ? r.getCustomer().getFullName() : "";
    %>
      <tr>
        <td class="stt"><%= stt %></td>
        <td class="muted">#<%= r.getId() %></td>
        <td><%= dateStr %></td>
        <td><%= timeStr %></td>
        <td><strong><%= esc(r.getTable().getTableNumber()) %></strong></td>
        <td><%= esc(r.getCustomerName()) %></td>
        <td><%= esc(r.getCustomerPhone()) %></td>
        <td class="muted"><%= esc(custFullName) %></td>
        <td><span class="badge <%= badgeCss %>"><%= statusLabel %></span></td>
        <td class="num">
          <% if (Reservation6.PENDING.equals(status)) { %>
          <form method="post" action="doConfirmReservation6Sales.jsp" style="display:inline;margin:0;">
            <input type="hidden" name="rsvId"  value="<%= r.getId() %>">
            <input type="hidden" name="action" value="confirm">
            <button type="submit" class="btn btn-small btn-primary"
                    onclick="return confirm('Xác nhận đơn #<%= r.getId() %>?')">Xác nhận</button>
          </form>
          <form method="post" action="doConfirmReservation6Sales.jsp" style="display:inline;margin:0 0 0 6px;">
            <input type="hidden" name="rsvId"  value="<%= r.getId() %>">
            <input type="hidden" name="action" value="cancel">
            <button type="submit" class="btn btn-small"
                    onclick="return confirm('Hủy đơn #<%= r.getId() %>?')">Hủy đơn</button>
          </form>
          <% } else { %>
          <span class="muted" style="font-size:13px;">—</span>
          <% } %>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>
<% } %>

<div style="margin-top:24px;">
  <a class="btn" href="gdMainSales6.jsp">← Trang chủ</a>
</div>
<%@ include file="../common/foot.jspf" %>

