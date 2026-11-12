
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");

    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath()
            + "/view/user/gdLogin6.jsp");
        return;
    }

    Manager6 manager = (Manager6) u;

    // Xử lý xóa món ăn
    if ("POST".equalsIgnoreCase(request.getMethod())
            && "delete".equals(request.getParameter("action"))) {

        boolean deleted = false;

        try {
            int id = Integer.parseInt(
                request.getParameter("id"));

            if (id > 0) {
                Dish6DAO deleteDao = new Dish6DAO();

                try {
                    deleted = deleteDao.deleteDish(id);
                } finally {
                    deleteDao.close();
                }
            }
        } catch (NumberFormatException e) {
            deleted = false;
        }

        session.setAttribute("deleteMessage",
            deleted
                ? "Xóa món ăn thành công."
                : "Không thể xóa món ăn.");

        response.sendRedirect("gdDishManagement6.jsp");
        return;
    }

    String deleteMessage =
        (String) session.getAttribute("deleteMessage");

    session.removeAttribute("deleteMessage");

    // Lấy danh sách món ăn
    ArrayList<Dish6> listDish;

    Dish6DAO dao = new Dish6DAO();

    try {
        listDish = dao.getAllDishes();
    } finally {
        dao.close();
    }

    String pageTitle = "Quản lí món ăn";
%>

<%@ include file="../common/head.jspf" %>

<h1 class="page-title">Quản lí món ăn</h1>

<p class="lead">
    Danh sách món ăn hiện có của nhà hàng.
</p>

<% if (deleteMessage != null) { %>
    <p class="lead">
        <%= esc(deleteMessage) %>
    </p>
<% } %>

<div class="toolbar">
    <span class="count">
        <%= listDish.size() %> món ăn
    </span>

    <span>
        <a class="btn" href="gdMainManager6.jsp">
            Về trang chủ
        </a>

        <a class="btn btn-primary"
           id="linkAddDish"
           href="gdAddDish6.jsp">
            Thêm món ăn
        </a>
    </span>
</div>

<% if (listDish.isEmpty()) { %>

    <div class="empty">
        Chưa có món ăn nào.
        Bấm "Thêm món ăn" để tạo món đầu tiên.
    </div>

<% } else { %>

<div class="table-wrap">
    <table class="data" id="tblDish">

        <thead>
            <tr>
                <th class="stt">STT</th>
                <th>Tên món ăn</th>
                <th class="num">Giá</th>
                <th>Mô tả</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>

        <tbody>
        <%
            int stt = 0;

            for (Dish6 d : listDish) {
                stt++;
        %>
            <tr>
                <td class="stt">
                    <%= stt %>
                </td>

                <td>
                    <strong>
                        <%= esc(d.getDishName()) %>
                    </strong>
                </td>

                <td class="num">
                    <%= money(d.getPrice()) %>
                </td>

                <td class="muted">
                    <%= esc(d.getDescription()) %>
                </td>

                <td>
                    <% if (d.isStatus()) { %>
                        <span class="badge badge-on">
                            Đang bán
                        </span>
                    <% } else { %>
                        <span class="badge badge-off">
                            Ngừng bán
                        </span>
                    <% } %>
                </td>

                <td>
                    <!-- Nút sửa -->
                    <a class="btn"
                       href="gdAddDish6.jsp?id=<%= d.getId() %>">
                        Sửa
                    </a>

                    <!-- Nút xóa -->
                    <form method="post"
                          action="gdDishManagement6.jsp"
                          style="display:inline;"
                          onsubmit="return confirm('Bạn có chắc muốn xóa món ăn này?');">

                        <input type="hidden"
                               name="action"
                               value="delete">

                        <input type="hidden"
                               name="id"
                               value="<%= d.getId() %>">

                        <button type="submit" class="btn">
                            Xóa
                        </button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<% } %>

<%@ include file="../common/foot.jspf" %>
