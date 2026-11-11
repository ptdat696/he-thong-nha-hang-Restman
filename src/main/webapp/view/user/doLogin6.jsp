<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*,dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String loginPage = request.getContextPath() + "/view/user/gdLogin6.jsp";

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(loginPage);
        return;
    }

    String username = request.getParameter("inUsername");
    String password = request.getParameter("inPassword");
    User6 user = null;
    if (username != null && password != null && !username.trim().isEmpty()) {
        User6DAO dao = new User6DAO();
        try {
            user = dao.checkLogin(username.trim(), password);
        } finally {
            dao.close();
        }
    }

    if (user == null) {
        response.sendRedirect(loginPage + "?error=1");
        return;
    }

    // Tạo phiên mới sau khi đăng nhập để tránh dùng lại phiên cũ
    session.invalidate();
    request.getSession(true).setAttribute("user", user);
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
