
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="model.*,dao.*" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath()
            + "/view/user/gdLogin6.jsp");
        return;
    }

    Manager6 manager = (Manager6) u;

    // Kiểm tra chế độ thêm hay sửa
    boolean isEdit = request.getParameter("id") != null;
    Dish6 dish = null;

    if (isEdit) {
        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
            if (id <= 0) {
                response.sendRedirect("gdDishManagement6.jsp");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("gdDishManagement6.jsp");
            return;
        }

        Dish6DAO dao = new Dish6DAO();
        try {
            dish = dao.getDishById(id);
        } finally {
            dao.close();
        }

        if (dish == null) {
            response.sendRedirect("gdDishManagement6.jsp");
            return;
        }
    }

    String pageTitle = isEdit
        ? "Sửa thông tin món ăn"
        : "Thêm món ăn";
%>

<%@ include file="../common/head.jspf" %>

<h1 class="page-title">
    <%= isEdit ? "Sửa thông tin món ăn"
               : "Thêm thông tin món ăn" %>
</h1>

<form class="form" method="post"
      action="doAddDish6.jsp" autocomplete="off">

    <input type="hidden" name="action"
           value="<%= isEdit ? "edit" : "add" %>">

    <% if (isEdit) { %>
        <input type="hidden" name="id"
               value="<%= dish.getId() %>">
    <% } %>

    <label for="inDishName">
        Tên món ăn <span class="req">*</span>
    </label>

    <input type="text" id="inDishName"
           name="inDishName" maxlength="255"
           value="<%= isEdit
               ? esc(dish.getDishName()) : "" %>"
           required autofocus>

    <label for="inPrice">
        Giá (đồng) <span class="req">*</span>
    </label>

    <input type="number" id="inPrice"
           name="inPrice" min="0" step="any"
           value="<%= isEdit
               ? dish.getPrice() : "" %>"
           required>

    <label for="inDescription">Mô tả</label>

    <textarea id="inDescription"
              name="inDescription"
              rows="4" maxlength="255"><%= isEdit
                  ? esc(dish.getDescription()) : "" %></textarea>

    <p class="hint">Tối đa 255 ký tự.</p>

    <% if (isEdit) { %>
        <label for="inStatus">Trạng thái</label>

        <select id="inStatus" name="inStatus">
            <option value="1"
                <%= dish.isStatus() ? "selected" : "" %>>
                Đang bán
            </option>

            <option value="0"
                <%= !dish.isStatus() ? "selected" : "" %>>
                Ngừng bán
            </option>
        </select>
    <% } %>

    <div class="form-actions">
        <button type="submit"
                class="btn btn-primary">
            <%= isEdit ? "Lưu thay đổi" : "Thêm" %>
        </button>

        <a class="btn" href="gdDishManagement6.jsp">
            Hủy
        </a>
    </div>
</form>

<%@ include file="../common/foot.jspf" %>
