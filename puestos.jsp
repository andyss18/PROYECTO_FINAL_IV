<%-- 
    Document   : puestos
    Created on : 15 oct 2025, 10:51:43 p.m.
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Puesto" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Puestos</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="index.jsp">Proyecto UMG</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link active" href="puestos.jsp">Puestos</a></li>
        <li class="nav-item"><a class="nav-link" href="empleados.jsp">Empleados</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container py-4">
  <h3 class="mb-3">CRUD de Puestos</h3>

  <form action="sr_puesto" method="post" class="row g-3">
    <div class="col-sm-2">
      <label class="form-label">ID</label>
      <input type="text" class="form-control" id="txt_id" name="txt_id" value="0" readonly>
    </div>
    <div class="col-sm-6">
      <label class="form-label">Puesto</label>
      <input type="text" class="form-control" id="txt_puesto" name="txt_puesto" placeholder="Ej: Cajero" required>
    </div>
    <div class="col-12">
      <button class="btn btn-primary" name="btn_crear" value="crear">Crear</button>
      <button class="btn btn-success" name="btn_actualizar" value="actualizar">Actualizar</button>
      <button class="btn btn-danger" name="btn_borrar" value="borrar">Borrar</button>
    </div>
  </form>

  <hr>

  <div class="table-responsive">
    <table class="table table-hover" id="tbl_puestos">
      <thead class="table-dark">
      <tr><th>ID</th><th>Puesto</th></tr>
      </thead>
      <tbody>
      <%
        Puesto p = new Puesto();
        DefaultTableModel t = p.leer();
        for (int i=0; i<t.getRowCount(); i++){
          out.println("<tr data-id='"+t.getValueAt(i,0)+"'>");
          out.println("<td>"+t.getValueAt(i,0)+"</td>");
          out.println("<td>"+t.getValueAt(i,1)+"</td>");
          out.println("</tr>");
        }
      %>
      </tbody>
    </table>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  $("#tbl_puestos").on("click","tr",function(){
    const id = $(this).data("id");
    const nom = $(this).find("td").eq(1).text();
    $("#txt_id").val(id);
    $("#txt_puesto").val(nom);
  });
</script>
</body>
</html>
