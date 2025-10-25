<%-- 
    Document   : empleados
    Created on : 15 oct 2025, 10:51:54 p.m.
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Empleado" %>
<%@page import="modelo.Puesto" %>
<%@page import="java.util.HashMap" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Empleados</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="index.jsp">Proyecto UMG</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" href="puestos.jsp">Puestos</a></li>
        <li class="nav-item"><a class="nav-link active" href="empleados.jsp">Empleados</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container py-4">
  <h3 class="mb-3">CRUD de Empleados</h3>

  <form action="sr_empleado" method="post" class="row g-3">
    <div class="col-md-2">
      <label class="form-label">ID</label>
      <input type="text" class="form-control" id="txt_id" name="txt_id" value="0" readonly>
    </div>

    <div class="col-md-5">
      <label class="form-label">Nombres</label>
      <input type="text" class="form-control" id="txt_nombres" name="txt_nombres" required>
    </div>
    <div class="col-md-5">
      <label class="form-label">Apellidos</label>
      <input type="text" class="form-control" id="txt_apellidos" name="txt_apellidos" required>
    </div>

    <div class="col-md-6">
      <label class="form-label">Dirección</label>
      <input type="text" class="form-control" id="txt_direccion" name="txt_direccion">
    </div>
    <div class="col-md-3">
      <label class="form-label">Teléfono</label>
      <input type="text" class="form-control" id="txt_telefono" name="txt_telefono">
    </div>
    <div class="col-md-3">
      <label class="form-label">DPI</label>
      <input type="text" class="form-control" id="txt_dpi" name="txt_dpi">
    </div>

    <div class="col-md-3">
      <label class="form-label">Género</label>
      <select class="form-select" id="drop_genero" name="drop_genero">
        <option value="">(sin especificar)</option>
        <option value="1">Masculino</option>
        <option value="0">Femenino</option>
      </select>
    </div>

    <div class="col-md-3">
      <label class="form-label">Fecha Nacimiento</label>
      <input type="date" class="form-control" id="txt_fecha_nac" name="txt_fecha_nac">
    </div>

    <div class="col-md-3">
      <label class="form-label">Puesto</label>
      <select class="form-select" id="drop_puesto" name="drop_puesto" required>
        <%
          Puesto p = new Puesto();
          HashMap<String,String> mapa = p.leerDrop();
          for(String id: mapa.keySet()){
            out.println("<option value='"+id+"'>"+mapa.get(id)+"</option>");
          }
        %>
      </select>
    </div>

    <div class="col-md-3">
      <label class="form-label">Inicio Labores</label>
      <input type="date" class="form-control" id="txt_fecha_inicio" name="txt_fecha_inicio">
    </div>

    <div class="col-12">
      <button class="btn btn-primary" name="btn_crear" value="crear">Crear</button>
      <button class="btn btn-success" name="btn_actualizar" value="actualizar">Actualizar</button>
      <button class="btn btn-danger" name="btn_borrar" value="borrar">Borrar</button>
    </div>
  </form>

  <hr>

  <div class="table-responsive">
    <table class="table table-hover" id="tbl_empleados">
      <thead class="table-dark">
        <tr>
          <th>ID</th><th>Nombres</th><th>Apellidos</th><th>Dirección</th><th>Teléfono</th>
          <th>DPI</th><th>Genero</th><th>Fecha Nac.</th><th>Puesto</th><th>idPuesto</th><th>Inicio</th><th>Ingreso</th>
        </tr>
      </thead>
      <tbody>
        <%
          Empleado e = new Empleado();
          DefaultTableModel t = e.leer();
          for (int i=0; i<t.getRowCount(); i++){
            out.println("<tr>");
            for (int c=0; c<t.getColumnCount(); c++){
              out.println("<td>"+ t.getValueAt(i,c) +"</td>");
            }
            out.println("</tr>");
          }
        %>
      </tbody>
    </table>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  // Al hacer click en una fila, llenar el formulario
  $("#tbl_empleados").on("click","tr", function(){
    const tds = $(this).find("td");
    $("#txt_id").val( tds.eq(0).text() );
    $("#txt_nombres").val( tds.eq(1).text() );
    $("#txt_apellidos").val( tds.eq(2).text() );
    $("#txt_direccion").val( tds.eq(3).text() );
    $("#txt_telefono").val( tds.eq(4).text() );
    $("#txt_dpi").val( tds.eq(5).text() );
    const generoTxt = tds.eq(6).text().trim();
$("#drop_genero").val(
  generoTxt === "Masculino" ? "1" :
  generoTxt === "Femenino"  ? "0" : ""
);
             // "1" o "0"
    $("#txt_fecha_nac").val( tds.eq(7).text() );               // yyyy-mm-dd
    $("#drop_puesto").val( tds.eq(9).text() );                 // idPuesto
    $("#txt_fecha_inicio").val( tds.eq(10).text() );           // yyyy-mm-dd
  });
</script>
</body>
</html>
