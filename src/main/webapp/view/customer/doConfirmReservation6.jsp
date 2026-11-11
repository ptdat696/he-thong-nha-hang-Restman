<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="model.*,dao.*,java.util.ArrayList,java.sql.Date,java.sql.Time" %>
<%! static String val(String s) { return (s==null) ? "" : s.trim(); } %>
<%
    request.setCharacterEncoding("UTF-8");
    Object u = session.getAttribute("user");
    if (!(u instanceof Customer6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Customer6 customer = (Customer6) u;

    // ---- Xử lí dữ liệu form (POST) rồi chuyển hướng để tải lại trang không đặt bàn lần nữa ----
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        @SuppressWarnings("unchecked")
        ArrayList<Table6> listTable = (ArrayList<Table6>) session.getAttribute("listTable");
        Date date = (Date) session.getAttribute("rsvDate");
        Time time = (Time) session.getAttribute("rsvTime");

        Table6 table = null;
        try {
            int tableId = Integer.parseInt(val(request.getParameter("tableId")));
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

        String name = val(request.getParameter("inCustomerName"));
        String phone = val(request.getParameter("inCustomerPhone"));
        int guests = 0;
        try {
            guests = Integer.parseInt(val(request.getParameter("inNumberOfGuests")));
        } catch (NumberFormatException e) {
            guests = 0;
        }

        String error = null;
        if (table == null || date == null || time == null) {
            error = "Phiên đặt bàn đã hết hạn, vui lòng tìm bàn lại.";
        } else if (name.isEmpty() || name.length() > 255) {
            error = "Họ tên không được để trống và tối đa 255 ký tự.";
        } else if (!phone.matches("[0-9+ ]{8,15}")) {
            error = "Số điện thoại không hợp lệ.";
        } else if (guests < 1 || guests > table.getCapacity()) {
            error = "Số người phải từ 1 đến " + table.getCapacity() + ".";
        }

        String[] result;
        if (error != null) {
            result = new String[] { "error", error, "gdFindTable6.jsp", "Quay lại" };
        } else {
            // Đóng gói Reservation6 rồi lưu bằng Reservation6DAO.createReservation()
            Reservation6 reservation = new Reservation6();
            reservation.setReservationDate(date);
            reservation.setReservationTime(time);
            reservation.setNumberOfGuests(guests);
            reservation.setCustomerName(name);
            reservation.setCustomerPhone(phone);
            reservation.setStatus(Reservation6.PENDING);
            reservation.setTable(table);
            reservation.setCustomer(customer);

            boolean saved;
            Reservation6DAO dao = new Reservation6DAO();
            try {
                saved = dao.createReservation(reservation);
            } finally {
                dao.close();
            }
            if (saved) {
                session.removeAttribute("listTable");
                session.removeAttribute("rsvDate");
                session.removeAttribute("rsvTime");
                result = new String[] { "success",
                        "Đặt bàn " + table.getTableNumber() + " thành công. Đơn đặt bàn của bạn đang chờ nhân viên xác nhận.",
                        "gdMainCustomer6.jsp", "OK" };
            } else {
                result = new String[] { "error",
                        "Bàn này vừa có người đặt hoặc không còn khả dụng. Vui lòng chọn lại.",
                        "gdFindTable6.jsp", "Quay lại" };
            }
        }
        session.setAttribute("notice", result);
        response.sendRedirect("doConfirmReservation6.jsp");
        return;
    }

    // ---- Hiển thị thông báo kết quả (GET) ----
    String[] notice = (String[]) session.getAttribute("notice");
    session.removeAttribute("notice");
    if (notice == null) {
        response.sendRedirect("gdMainCustomer6.jsp");
        return;
    }
    boolean ok = "success".equals(notice[0]);
    String pageTitle = ok ? "Đặt bàn thành công" : "Không đặt được bàn";
%>
<%@ include file="../common/head.jspf" %>
<div class="notice <%= ok ? "" : "notice-err" %>" id="boxNotice">
    <h2><%= ok ? "Thành công" : "Có lỗi xảy ra" %></h2>
    <p><%= esc(notice[1]) %></p>
    <a class="btn btn-primary" id="btnOk" href="<%= esc(notice[2]) %>"><%= esc(notice[3]) %></a>
</div>
<%@ include file="../common/foot.jspf" %>
