<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    // Điều hướng theo vai trò sau đăng nhập; chưa đăng nhập thì về trang đăng nhập.
    Object u = session.getAttribute("user");
    String base = request.getContextPath() + "/view/";
    String target;
    if (u instanceof Manager6) {
        target = base + "manager/gdMainManager6.jsp";
    } else if (u instanceof WarehouseStaff6) {
        target = base + "warehouse/gdMainWarehouse6.jsp";
    } else if (u instanceof SalesStaff6) {
        target = base + "sales/gdMainSales6.jsp";
    } else if (u instanceof Customer6) {
        target = base + "customer/gdMainCustomer6.jsp";
    } else {
        target = base + "user/gdLogin6.jsp";
    }
    response.sendRedirect(target);
%>
