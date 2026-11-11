<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*,dao.*" %>
<%!
    static String val(String s) {
        return (s == null) ? "" : s.trim();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Manager6 manager = (Manager6) u;

    // ---- Xử lí dữ liệu form (POST) rồi chuyển hướng để tải lại trang không thêm món lần nữa ----
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = val(request.getParameter("inDishName"));
        String description = val(request.getParameter("inDescription"));
        String priceText = val(request.getParameter("inPrice"));
        boolean status = !"0".equals(val(request.getParameter("inStatus")));

        String error = null;
        float price = 0;
        if (name.isEmpty() || name.length() > 255) {
            error = "Tên món ăn không được để trống và tối đa 255 ký tự.";
        } else if (description.length() > 255) {
            error = "Mô tả tối đa 255 ký tự.";
        } else {
            try {
                price = Float.parseFloat(priceText);
                if (Float.isNaN(price) || Float.isInfinite(price) || price < 0) {
                    error = "Giá phải là số không âm.";
                }
            } catch (NumberFormatException e) {
                error = "Giá phải là số không âm.";
            }
        }

        String[] result;
        if (error != null) {
            result = new String[] { "error", error, "gdAddDish6.jsp", "Quay lại" };
        } else {
            // Đóng gói Dish6 rồi lưu bằng Dish6DAO.addDish()
            Dish6 dish = new Dish6();
            dish.setDishName(name);
            dish.setPrice(price);
            dish.setDescription(description);
            dish.setStatus(status);
            dish.setManager(manager);

            boolean saved;
            Dish6DAO dao = new Dish6DAO();
            try {
                saved = dao.addDish(dish);
            } finally {
                dao.close();
            }
            if (saved) {
                result = new String[] { "success", "Thêm món ăn \"" + name + "\" thành công.",
                        "gdDishManagement6.jsp", "OK" };
            } else {
                result = new String[] { "error", "Không lưu được món ăn. Vui lòng thử lại.",
                        "gdAddDish6.jsp", "Quay lại" };
            }
        }
        session.setAttribute("notice", result);
        response.sendRedirect("doAddDish6.jsp");
        return;
    }

    // ---- Hiển thị thông báo kết quả (GET) ----
    String[] notice = (String[]) session.getAttribute("notice");
    session.removeAttribute("notice");
    if (notice == null) {
        response.sendRedirect("gdDishManagement6.jsp");
        return;
    }
    boolean ok = "success".equals(notice[0]);
    String pageTitle = ok ? "Thêm món ăn thành công" : "Không thêm được món ăn";
%>
<%@ include file="../common/head.jspf" %>
<div class="notice <%= ok ? "" : "notice-err" %>" id="boxNotice">
  <h2><%= ok ? "Thành công" : "Có lỗi xảy ra" %></h2>
  <p><%= esc(notice[1]) %></p>
  <a class="btn btn-primary" id="btnOk" href="<%= esc(notice[2]) %>"><%= esc(notice[3]) %></a>
</div>
<%@ include file="../common/foot.jspf" %>
