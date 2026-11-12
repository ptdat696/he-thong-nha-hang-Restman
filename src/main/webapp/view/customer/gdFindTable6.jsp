<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
  import="model.*,java.time.LocalDate,java.time.ZoneId" %>
  <% Object u=session.getAttribute("user"); if (!(u instanceof Customer6)) {
    response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp" ); return; } Customer6
    customer=(Customer6) u; String today=LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")).toString(); String errorText=null;
    String errorCode=request.getParameter("error"); if ("1".equals(errorCode)) {
    errorText="Vui lòng chọn ngày và giờ hợp lệ." ; } else if ("2".equals(errorCode)) {
    errorText="Không thể đặt bàn cho ngày đã qua." ; } else if ("3".equals(errorCode)) {
    errorText="Giờ đã chọn đã qua, vui lòng chọn giờ khác." ; } else if ("4".equals(errorCode)) {
    errorText="Nhà hàng nhận đặt bàn từ 10:00 đến 21:00." ; } String pageTitle="Đặt bàn" ; %>
    <%@ include file="../common/head.jspf" %>
      <h1 class="page-title">Đặt bàn trực tuyến</h1>
      <p class="lead">Chọn ngày và giờ để tìm các bàn còn trống.</p>

      <% if (errorText !=null) { %>
        <div class="alert-err">
          <%= esc(errorText) %>
        </div>
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
          <%@ include file="../common/foot.jspf" %>