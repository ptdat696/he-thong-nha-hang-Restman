<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    Object u = session.getAttribute("user");
    if (!(u instanceof SalesStaff6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    SalesStaff6 staff = (SalesStaff6) u;

    // Đọc tham số
    String rsvIdStr = request.getParameter("rsvId");
    String action   = request.getParameter("action"); // "confirm" hoặc "cancel"

    int rsvId = 0;
    try {
        rsvId = Integer.parseInt(rsvIdStr.trim());
    } catch (RuntimeException e) {
        response.sendRedirect("gdReservationList6.jsp?msg=error");
        return;
    }

    if (!"confirm".equals(action) && !"cancel".equals(action)) {
        response.sendRedirect("gdReservationList6.jsp?msg=error");
        return;
    }

    String newStatus = "confirm".equals(action) ? Reservation6.CONFIRMED : Reservation6.CANCELLED;

    Reservation6DAO dao = new Reservation6DAO();
    boolean updated;
    try {
        updated = dao.updateStatus(rsvId, newStatus, staff.getId());
    } finally {
        dao.close();
    }

    if (!updated) {
        // Đơn không còn ở PENDING nữa (đã xử lý trước đó)
        response.sendRedirect("gdReservationList6.jsp?msg=nochange");
        return;
    }

    String msgParam = "confirm".equals(action) ? "confirmed" : "cancelled";
    response.sendRedirect("gdReservationList6.jsp?msg=" + msgParam);
%>

