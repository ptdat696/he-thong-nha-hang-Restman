<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList,java.sql.Date,java.sql.Time,java.time.LocalDate,java.time.LocalTime,java.time.ZoneId" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    ZoneId zone = ZoneId.of("Asia/Ho_Chi_Minh");
    String today = LocalDate.now(zone).toString();

    // Đọc tham số inDate, inTime nếu người dùng đã bấm "Tìm bàn"
    String dateText = request.getParameter("inDate");
    String timeText = request.getParameter("inTime");
    Date date = null;
    Time time = null;
    int err = 0;
    boolean hasSearched = (dateText != null && timeText != null);

    if (hasSearched) {
        try {
            date = Date.valueOf(dateText.trim());
            String t = timeText.trim();
            time = Time.valueOf(t.length() == 5 ? t + ":00" : t);
        } catch (RuntimeException e) {
            err = 1;
        }
        if (err == 0) {
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
    }

    String errorText = null;
    if (err == 1) {
        errorText = "Vui lòng chọn ngày và giờ hợp lệ.";
    } else if (err == 2) {
        errorText = "Không thể đặt bàn cho ngày đã qua.";
    } else if (err == 3) {
        errorText = "Giờ đã chọn đã qua, vui lòng chọn giờ khác.";
    } else if (err == 4) {
        errorText = "Nhà hàng nhận đặt bàn từ 10:00 đến 21:00.";
    }

    // Lấy dữ liệu bàn
    Table6DAO dao = new Table6DAO();
    ArrayList<Table6> availableTables = null;
    ArrayList<Table6> allTables = null;
    try {
        if (hasSearched && err == 0) {
            availableTables = dao.getAvailableTables(date, time);
            session.setAttribute("listTable", availableTables);
            session.setAttribute("rsvDate", date);
            session.setAttribute("rsvTime", time);
        }
        // Tất cả bàn của nhà hàng
        allTables = dao.getAllTables(java.sql.Date.valueOf(today));
    } finally {
        dao.close();
    }

    java.text.SimpleDateFormat dayFmt = new java.text.SimpleDateFormat("dd/MM");
    String pageTitle = "Đặt bàn";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Đặt bàn trực tuyến</h1>
<p class="lead">Chọn ngày và giờ bạn muốn đến, hệ thống sẽ tìm các bàn còn trống ngay bên dưới.</p>

<% if (errorText != null) { %>
<div class="alert-err"><%= esc(errorText) %></div>
<% } %>

<form class="form" method="get" action="gdFindTable6.jsp" autocomplete="off">
  <label for="inDate">Ngày <span class="req">*</span></label>
  <input type="date" id="inDate" name="inDate" min="<%= today %>" value="<%= (dateText != null) ? esc(dateText) : today %>" required>

  <label for="inTime">Giờ <span class="req">*</span></label>
  <input type="time" id="inTime" name="inTime" min="10:00" max="21:00" step="900" value="<%= (timeText != null) ? esc(timeText) : "12:00" %>" required>
  <p class="hint">Nhà hàng nhận đặt bàn từ 10:00 đến 21:00. Mỗi lượt giữ bàn 2 giờ.</p>

  <div class="form-actions">
    <button type="submit" class="btn btn-primary" name="btnFind">Tìm bàn</button>
    <a class="btn" href="gdMainCustomer6.jsp">Hủy</a>
  </div>
</form>

<% if (hasSearched && err == 0 && availableTables != null) { 
     String dateShow = new java.text.SimpleDateFormat("dd/MM/yyyy").format(date);
     String timeShow = time.toString().substring(0, 5);
%>
  <h2 class="section-title">Danh sách bàn trống phù hợp</h2>
  <p class="lead">Thời điểm: <strong><%= dateShow %></strong> lúc <strong><%= timeShow %></strong> (<%= availableTables.size() %> bàn trống).</p>

  <% if (availableTables.isEmpty()) { %>
    <div class="empty">Không còn bàn trống vào thời điểm này. Vui lòng chọn ngày hoặc giờ khác.</div>
  <% } else { %>
    <div class="table-wrap">
      <table class="data" id="tblAvailableTables">
        <thead>
          <tr>
            <th class="stt">STT</th>
            <th>Số bàn</th>
            <th>Sức chứa</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody>
        <% int sttAvail = 0; for (Table6 t : availableTables) { sttAvail++; %>
          <tr>
            <td class="stt"><%= sttAvail %></td>
            <td><strong><%= esc(t.getTableNumber()) %></strong></td>
            <td><%= t.getCapacity() %> người</td>
            <td><span class="badge badge-on">Còn trống</span></td>
            <td class="num">
              <a class="btn btn-small btn-primary" href="gdConfirmReservation6.jsp?tableId=<%= t.getId() %>">Đặt bàn này</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  <% } %>
<% } %>

<h2 class="section-title">Tất cả bàn của nhà hàng</h2>
<p class="lead">Danh sách tất cả bàn và lịch đã đặt hiện tại.</p>

<div class="table-wrap">
  <table class="data" id="tblAllTables">
    <thead>
      <tr>
        <th class="stt">STT</th>
        <th>Số bàn</th>
        <th>Sức chứa</th>
        <th>Tình trạng</th>
        <th>Lịch đã đặt</th>
        <th>Hành động</th>
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
        <td class="num">
          <% if (!maintenance) { %>
            <button type="button" class="btn btn-small" onclick="quickSelectTable('<%= esc(t.getTableNumber()) %>')">Chọn bàn</button>
          <% } else { %>
            <span class="muted">—</span>
          <% } %>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>

<script>
function quickSelectTable(tableNum) {
  var dateInput = document.getElementById('inDate');
  var timeInput = document.getElementById('inTime');
  dateInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
  dateInput.focus();
}
</script>

<%@ include file="../common/foot.jspf" %>
