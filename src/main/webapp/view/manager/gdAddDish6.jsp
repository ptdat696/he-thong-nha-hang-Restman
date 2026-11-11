<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    Object u = session.getAttribute("user");
    if (!(u instanceof Manager6)) {
        response.sendRedirect(request.getContextPath() + "/view/user/gdLogin6.jsp");
        return;
    }
    Manager6 manager = (Manager6) u;
    String pageTitle = "Thêm món ăn";
%>
<%@ include file="../common/head.jspf" %>
<h1 class="page-title">Thêm thông tin món ăn</h1>
<p class="lead">Nhập thông tin món ăn mới rồi bấm Thêm.</p>

<form class="form" method="post" action="doAddDish6.jsp" autocomplete="off">
  <label for="inDishName">Tên món ăn <span class="req">*</span></label>
  <input type="text" id="inDishName" name="inDishName" maxlength="255" required autofocus>

  <label for="inPrice">Giá (đồng) <span class="req">*</span></label>
  <input type="number" id="inPrice" name="inPrice" min="0" step="any" required>

  <label for="inDescription">Mô tả</label>
  <textarea id="inDescription" name="inDescription" rows="4" maxlength="255"></textarea>
  <p class="hint">Tối đa 255 ký tự.</p>

  <label for="inStatus">Trạng thái</label>
  <select id="inStatus" name="inStatus">
    <option value="1" selected>Đang bán</option>
    <option value="0">Ngừng bán</option>
  </select>

  <div class="form-actions">
    <button type="submit" class="btn btn-primary" name="btnAdd">Thêm</button>
    <a class="btn" href="gdDishManagement6.jsp">Hủy</a>
  </div>
</form>
<%@ include file="../common/foot.jspf" %>
