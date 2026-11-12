
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="model.*,dao.*" %>
<%!
    static String val(String s) {
        return (s == null) ? "" : s.trim();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath()
            + "/view/user/gdLogin6.jsp");
        return;
    }

    Manager6 manager = (Manager6) u;

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String action = val(request.getParameter("action"));
        boolean isEdit = "edit".equals(action);

        String name = val(request.getParameter("inDishName"));
        String description = val(request.getParameter("inDescription"));
        String priceText = val(request.getParameter("inPrice"));
        String statusText = val(request.getParameter("inStatus"));

        String error = null;
        float price = 0;
        int id = 0;

        // Kiểm tra thao tác
        if (!"add".equals(action) && !isEdit) {
            error = "Thao tác không hợp lệ.";
        }

        // Kiểm tra ID khi sửa
        if (error == null && isEdit) {
            try {
                id = Integer.parseInt(
                    request.getParameter("id"));

                if (id <= 0) {
                    error = "ID món ăn không hợp lệ.";
                }
            } catch (NumberFormatException e) {
                error = "ID món ăn không hợp lệ.";
            }
        }

        // Kiểm tra thông tin
        if (error == null) {
            if (name.isEmpty() || name.length() > 255) {
                error = "Tên món ăn không được để trống "
                      + "và tối đa 255 ký tự.";
            } else if (description.length() > 255) {
                error = "Mô tả tối đa 255 ký tự.";
            } else {
                try {
                    price = Float.parseFloat(priceText);

                    if (!Float.isFinite(price) || price < 0) {
                        error = "Giá phải là số không âm.";
                    }
                } catch (NumberFormatException e) {
                    error = "Giá phải là số không âm.";
                }
            }
        }

        // Chỉ kiểm tra trạng thái khi sửa
        if (error == null && isEdit
                && !("0".equals(statusText)
                     || "1".equals(statusText))) {
            error = "Trạng thái không hợp lệ.";
        }

        String[] result;

        if (error != null) {
            result = new String[] {
                "error",
                error,
                "gdDishManagement6.jsp",
                "Quay lại danh sách"
            };
        } else {

            Dish6 dish = new Dish6();
            dish.setDishName(name);
            dish.setPrice(price);
            dish.setDescription(description);

            boolean saved;

            Dish6DAO dao = new Dish6DAO();

            try {
                if (isEdit) {
                    // Sửa món ăn
                    dish.setId(id);
                    dish.setStatus("1".equals(statusText));

                    saved = dao.updateDish(dish);
                } else {
                    // Thêm món ăn
                    dish.setStatus(true);
                    dish.setManager(manager);

                    saved = dao.addDish(dish);
                }
            } finally {
                dao.close();
            }

            if (saved) {
                result = new String[] {
                    "success",
                    isEdit
                        ? "Cập nhật món ăn thành công."
                        : "Thêm món ăn \"" + name
                          + "\" thành công.",
                    "gdDishManagement6.jsp",
                    "OK"
                };
            } else {
                result = new String[] {
                    "error",
                    isEdit
                        ? "Không thể cập nhật món ăn."
                        : "Không thể thêm món ăn.",
                    "gdDishManagement6.jsp",
                    "Quay lại"
                };
            }
        }

        session.setAttribute("notice", result);
        response.sendRedirect("doAddDish6.jsp");
        return;
    }

    // Hiển thị thông báo kết quả
    String[] notice =
        (String[]) session.getAttribute("notice");

    session.removeAttribute("notice");

    if (notice == null) {
        response.sendRedirect("gdDishManagement6.jsp");
        return;
    }

    boolean ok = "success".equals(notice[0]);

    String pageTitle = ok
        ? "Thao tác thành công"
        : "Thao tác thất bại";
%>

<%@ include file="../common/head.jspf" %>

<div class="notice <%= ok ? "" : "notice-err" %>"
     id="boxNotice">

    <h2>
        <%= ok ? "Thành công" : "Có lỗi xảy ra" %>
    </h2>

    <p><%= esc(notice[1]) %></p>

    <a class="btn btn-primary" id="btnOk"
       href="<%= esc(notice[2]) %>">
        <%= esc(notice[3]) %>
    </a>
</div>

<%@ include file="../common/foot.jspf" %>
