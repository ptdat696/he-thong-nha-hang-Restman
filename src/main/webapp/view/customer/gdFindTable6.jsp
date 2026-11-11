<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList,java.time.LocalDate,java.time.ZoneId" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    String today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")).toString();

    // Danh sách mọi bàn (trống và đã có lịch đặt) hiển thị bên dưới form chọn ngày giờ
    ArrayList<Table6> allTables;
    Table6DAO dao = new Table6DAO();
    try {
        allTables = dao.getAllTables(java.sql.Date.valueOf(today));
    } finally {
        dao.close();
    }
    java.text.SimpleDateFormat dayFmt = new java.text.SimpleDateFormat("dd/MM");

    String errorText = null;
    String errorCode = request.getParameter("error");
    if ("1".equals(errorCode)) {
        errorText = "Vui lòng chọn ngày và giờ hợp lệ.";
    } else if ("2".equals(errorCode)) {
        errorText = "Không thể đặt bàn cho ngày đã qua.";
    } else if ("3".equals(errorCode)) {
        errorText = "Giờ đã chọn đã qua, vui lòng chọn giờ khác.";
    } else if ("4".equals(errorCode)) {
        errorText = "Nhà hàng nhận đặt bàn từ 10:00 đến 21:00.";
    }
    String pageTitle = "Đặt bàn";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Đặt bàn trực tuyến</h1>
<p class="lead">Chọn ngày và giờ bạn muốn đến, hệ thống sẽ tìm các bàn còn trống.</p>

<% if (errorText != null) { %>
<div class="alert-err"><%= esc(errorText) %></div>
<% } %>

<form class="form" method="get" action="gdTableList6.jsp" autocomplete="off">
  <label for="inDate">Ngày <span class="req">*</span></label>
  <input type="date" id="inDate" name="inDate" min="<%= today %>" required>

  <label for="inTime">Giờ <span class="req">*</span></label>
  <input type="time" id="inTime" name="inTime" min="10:00" max="21:00" step="900" required>
  <p class="hint">Nhà hàng nhận đặt bàn từ 10:00 đến 21:00. Mỗi lượt giữ bàn 2 giờ.</p>

  <div class="form-actions">
    <button type="submit" class="btn btn-primary" name="btnFind">Tìm bàn</button>
    <a class="btn" href="gdMainCustomer6.jsp">Hủy</a>
  </div>
</form>

<h2 class="section-title">Tất cả bàn của nhà hàng</h2>
<p class="lead">Danh sách bàn và các lịch đã đặt. Chọn ngày giờ ở trên để xem bàn trống phù hợp.</p>

<div class="table-wrap">
  <table class="data" id="tblAllTables">
    <thead>
      <tr>
        <th class="stt">STT</th>
        <th>Số bàn</th>
        <th>Sức chứa</th>
        <th>Tình trạng</th>
        <th>Lịch đã đặt</th>
      </tr>
    </thead>
    <tbody>
    <% int stt = 0; for (Table6 t : allTables) { stt++;
         boolean maintenance = !"ACTIVE".equals(t.getStatus());
         boolean booked = !t.getReservations().isEmpty(); %>
      <tr>
        <td class="stt"><%= stt %></td>
        <td><strong><%= esc(t.getTableNumber()) %></strong></td>
        <td><%= t.getCapacity() %> người</td>
        <td>
          <% if (maintenance) { %>
          <span class="badge badge-off">Bảo trì</span>
          <% } else if (booked) { %>
          <span class="badge badge-busy">Đã có lịch đặt</span>
          <% } else { %>
          <span class="badge badge-on">Trống</span>
          <% } %>
        </td>
        <td class="muted">
          <% if (maintenance) { %>
          Tạm ngưng nhận đặt
          <% } else if (!booked) { %>
          Chưa có lịch đặt
          <% } else {
               int shown = 0;
               for (Reservation6 r : t.getReservations()) {
                 if (shown == 5) break;
                 shown++; %><span class="slot"><%= dayFmt.format(r.getReservationDate()) %> <%= r.getReservationTime().toString().substring(0, 5) %></span> <%
               }
               if (t.getReservations().size() > 5) { %>và <%= t.getReservations().size() - 5 %> lịch khác<% }
             } %>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>
<%@ include file="../common/foot.jspf" %>
