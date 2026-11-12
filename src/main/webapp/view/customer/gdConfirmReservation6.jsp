<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="model.*,java.util.ArrayList,java.sql.Date,java.sql.Time" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    // Bàn khách vừa chọn nằm trong danh sách đã lưu ở trang gdTableList6
    @SuppressWarnings("unchecked")
    ArrayList<Table6> listTable = (ArrayList<Table6>) session.getAttribute("listTable");
    Date date = (Date) session.getAttribute("rsvDate");
    Time time = (Time) session.getAttribute("rsvTime");

    Table6 table = null;
    try {
        int tableId = Integer.parseInt(request.getParameter("tableId").trim());
        if (listTable != null) {
            for (Table6 t : listTable) {
                if (t.getId() == tableId) {
                    table = t;
                    break;
                }
            }
        }
    } catch (RuntimeException e) {
        table = null;
    }
    if (table == null || date == null || time == null) {
        response.sendRedirect("gdFindTable6.jsp");
        return;
    }

    String dateShow = new java.text.SimpleDateFormat("dd/MM/yyyy").format(date);
    String timeShow = time.toString().substring(0, 5);
    String pageTitle = "Xác nhận đặt bàn";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Xác nhận đặt bàn</h1>
<p class="lead">Kiểm tra thông tin bàn và nhập thông tin cá nhân của bạn.</p>

<dl class="summary">
    <dt>Bàn</dt>
    <dd><strong><%= esc(table.getTableNumber()) %></strong></dd>
    <dt>Sức chứa</dt>
    <dd><%= table.getCapacity() %> người</dd>
    <dt>Ngày</dt>
    <dd><%= dateShow %></dd>
    <dt>Giờ</dt>
    <dd><%= timeShow %></dd>
</dl>

<form class="form" method="post" action="doConfirmReservation6.jsp" autocomplete="off">
    <input type="hidden" name="tableId" value="<%= table.getId() %>">

    <label for="inCustomerName">Họ và tên <span class="req">*</span></label>
    <input type="text" id="inCustomerName" name="inCustomerName" maxlength="255"
        value="<%= esc(customer.getFullName()) %>" required>

    <label for="inCustomerPhone">Số điện thoại <span class="req">*</span></label>
    <input type="text" id="inCustomerPhone" name="inCustomerPhone" maxlength="15"
        pattern="[0-9+ ]{8,15}" title="8 đến 15 chữ số" value="<%= esc(customer.getPhone()) %>"
        required>

    <label for="inCustomerEmail">Email</label>
    <input type="email" id="inCustomerEmail" name="inCustomerEmail" maxlength="255"
        value="<%= esc(customer.getEmail()) %>" placeholder="example@email.com">

    <div class="form-actions">
        <button type="submit" class="btn btn-primary" name="btnConfirm">Xác nhận</button>
        <a class="btn" href="gdTableList6.jsp?inDate=<%= date.toString() %>&amp;inTime=<%= timeShow %>">Chọn bàn khác</a>
    </div>
</form>
<%@ include file="../common/foot.jspf" %>
