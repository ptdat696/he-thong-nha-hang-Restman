<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList,java.sql.Date,java.sql.Time,java.time.LocalDate,java.time.LocalTime,java.time.ZoneId" %>
<%
    request.setCharacterEncoding("UTF-8");
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    // ---- Đọc và kiểm tra ngày, giờ khách chọn ở trang gdFindTable6 ----
    String dateText = request.getParameter("inDate");
    String timeText = request.getParameter("inTime");
    Date date = null;
    Time time = null;
    int err = 0;
    try {
        date = Date.valueOf(dateText.trim());
        String t = timeText.trim();
        time = Time.valueOf(t.length() == 5 ? t + ":00" : t);
    } catch (RuntimeException e) {
        err = 1;
    }
    if (err == 0) {
        ZoneId zone = ZoneId.of("Asia/Ho_Chi_Minh");
        LocalDate chosenDay = date.toLocalDate();
        LocalTime chosenTime = time.toLocalTime();
        if (chosenDay.isBefore(LocalDate.now(zone))) {
            err = 2;
        } else if (chosenDay.isEqual(LocalDate.now(zone)) && !chosenTime.isAfter(LocalTime.now(zone))) {
            err = 3;
        } else if (chosenTime.isBefore(LocalTime.of(10, 0)) || chosenTime.isAfter(LocalTime.of(21, 0))) {
            err = 4;
        }
    }
    if (err != 0) {
        response.sendRedirect("gdFindTable6.jsp?error=" + err);
        return;
    }

    // ---- Tìm bàn trống bằng Table6DAO.getAvailableTables() ----
    ArrayList<Table6> listTable;
    Table6DAO dao = new Table6DAO();
    try {
        listTable = dao.getAvailableTables(date, time);
    } finally {
        dao.close();
    }

    // Lưu lại để trang xác nhận dùng (khách chọn bàn trong danh sách này)
    session.setAttribute("listTable", listTable);
    session.setAttribute("rsvDate", date);
    session.setAttribute("rsvTime", time);

    String dateShow = new java.text.SimpleDateFormat("dd/MM/yyyy").format(date);
    String timeShow = time.toString().substring(0, 5);
    String pageTitle = "Danh sách bàn trống";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Danh sách bàn trống</h1>
<p class="lead">Ngày <strong><%= dateShow %></strong>, lúc <strong><%= timeShow %></strong>. Chọn một bàn để tiếp tục.</p>

<div class="toolbar">
  <span class="count"><%= listTable.size() %> bàn trống</span>
  <a class="btn" href="gdFindTable6.jsp">Chọn lại ngày giờ</a>
</div>

<% if (listTable.isEmpty()) { %>
<div class="empty">Không còn bàn trống vào thời điểm này. Vui lòng chọn ngày hoặc giờ khác.</div>
<% } else { %>
<div class="table-wrap">
  <table class="data" id="tblTable">
    <thead>
      <tr>
        <th class="stt">STT</th>
        <th>Số bàn</th>
        <th>Sức chứa</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
    <% int stt = 0; for (Table6 t : listTable) { stt++; %>
      <tr>
        <td class="stt"><%= stt %></td>
        <td><strong><%= esc(t.getTableNumber()) %></strong></td>
        <td><%= t.getCapacity() %> người</td>
        <td class="num"><a class="btn btn-small btn-primary" href="gdConfirmReservation6.jsp?tableId=<%= t.getId() %>">Chọn bàn</a></td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>
<% } %>
<%@ include file="../common/foot.jspf" %>
