<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*,dao.*,java.util.ArrayList" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Manager6 manager = (Manager6) u;

    // Lấy danh sách món ăn từ Dish6DAO.getAllDishes()
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
<p class="lead">Danh sách món ăn hiện có của nhà hàng.</p>

<div class="toolbar">
  <span class="count"><%= listDish.size() %> món ăn</span>
  <span>
    <a class="btn" href="gdMainManager6.jsp">Về trang chủ</a>
    <a class="btn btn-primary" id="linkAddDish" href="gdAddDish6.jsp">Thêm món ăn</a>
  </span>
</div>

<% if (listDish.isEmpty()) { %>
<div class="empty">Chưa có món ăn nào. Bấm &ldquo;Thêm món ăn&rdquo; để tạo món đầu tiên.</div>
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
      </tr>
    </thead>
    <tbody>
    <% int stt = 0; for (Dish6 d : listDish) { stt++; %>
      <tr>
        <td class="stt"><%= stt %></td>
        <td><strong><%= esc(d.getDishName()) %></strong></td>
        <td class="num"><%= money(d.getPrice()) %></td>
        <td class="muted"><%= esc(d.getDescription()) %></td>
        <td>
          <% if (d.isStatus()) { %>
          <span class="badge badge-on">Đang bán</span>
          <% } else { %>
          <span class="badge badge-off">Ngừng bán</span>
          <% } %>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>
<% } %>
<%@ include file="../common/foot.jspf" %>
