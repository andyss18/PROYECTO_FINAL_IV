<%-- 
    Document   : compras
    Created on : 23 oct 2025, 10:28:06 p.m.
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Compra,modelo.Proveedor,modelo.Producto" %>
<%@page import="java.util.*" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Compras</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    td.hide, th.hide { display:none; }
    .w-100p { width: 100px; }
  </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="index.jsp">Proyecto UMG</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" href="puestos.jsp">Puestos</a></li>
        <li class="nav-item"><a class="nav-link" href="empleados.jsp">Empleados</a></li>
        <li class="nav-item"><a class="nav-link" href="clientes.jsp">Clientes</a></li>
        <li class="nav-item"><a class="nav-link" href="proveedores.jsp">Proveedores</a></li>
        <li class="nav-item"><a class="nav-link" href="marcas.jsp">Marcas</a></li>
        <li class="nav-item"><a class="nav-link" href="productos.jsp">Productos</a></li>
        <li class="nav-item"><a class="nav-link active" href="compras.jsp">Compras</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container py-4">
  <h3 class="mb-3">Compra (Maestro–Detalle)</h3>

  <form action="sr_compra" method="post" id="frmCompra" class="row g-3">

    <div class="col-md-3">
      <label class="form-label">No. Orden</label>
      <input type="number" class="form-control" name="txt_no_orden" required>
    </div>
    <div class="col-md-3">
      <label class="form-label">Fecha</label>
      <input type="date" class="form-control" name="txt_fecha" required>
    </div>
    <div class="col-md-6">
      <label class="form-label">Proveedor</label>
      <select class="form-select" name="drop_proveedor" required>
        <%
          Proveedor pv = new Proveedor();
          Map<String,String> prov = pv.leerDrop();
          for (String id: prov.keySet()){
            out.println("<option value='"+id+"'>"+prov.get(id)+"</option>");
          }
        %>
      </select>
    </div>

    <!-- Detalle -->
    <div class="col-12">
      <h5 class="mt-3">Detalle</h5>
      <table class="table table-bordered" id="tbl_det">
        <thead class="table-light">
          <tr>
            <th style="width:45%">Producto</th>
            <th class="text-end" style="width:10%">Exist.</th>
            <th class="text-end" style="width:15%">Costo Unit.</th>
            <th class="text-end" style="width:15%">Cantidad</th>
            <th class="text-end" style="width:15%">Subtotal</th>
            <th style="width:10%"></th>
          </tr>
        </thead>
        <tbody></tbody>
        <tfoot>
          <tr>
            <td colspan="4" class="text-end"><strong>Total</strong></td>
            <td class="text-end"><strong id="lbl_total">0.00</strong></td>
            <td></td>
          </tr>
        </tfoot>
      </table>
      <button type="button" class="btn btn-outline-primary" id="btn_add_row">Agregar producto</button>
    </div>

    <div class="col-12">
      <button class="btn btn-primary" name="btn_crear" value="crear">Guardar Compra</button>
    </div>
  </form>

  <hr>
  <h5 class="mb-3">Compras recientes</h5>
  <div class="table-responsive">
    <table class="table table-hover">
      <thead class="table-dark">
        <tr><th>ID</th><th>No. Orden</th><th>Fecha</th><th>Proveedor</th><th>Total</th></tr>
      </thead>
      <tbody>
        <%
          Compra c = new Compra();
          DefaultTableModel t = c.leer();
          for (int i=0; i<t.getRowCount(); i++){
            out.println("<tr>");
            for (int j=0; j<t.getColumnCount(); j++){
              out.println("<td>"+ t.getValueAt(i,j) +"</td>");
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
  // Catálogo: id, nombre, costo, existencia
  const catalogo = [
    <%
      Producto p = new Producto();
      java.util.List<String[]> prods = p.leerDropProductosCompra();
      for(int i=0;i<prods.size();i++){
        String[] r = prods.get(i); // id, nombre, costo, existencia
        out.print("{id:"+r[0]+", nom:\""+r[1].replace("\"","\\\"")+"\", costo:"+r[2]+", exist:"+r[3]+"}");
        if(i<prods.size()-1) out.print(",");
      }
    %>
  ];
  const fmt = n => (Number(n)||0).toFixed(2);

  function optionHtml(o){
    return '<option value="'+o.id+'" data-costo="'+o.costo+'" data-exist="'+o.exist+'">'+o.nom+'</option>';
  }
  function filaDetalle(){
    var opts = ''; for(var i=0;i<catalogo.length;i++) opts += optionHtml(catalogo[i]);
    var html = ''
      + '<tr>'
      +   '<td><select class="form-select sel-prod">'+opts+'</select>'
      +       '<input type="hidden" name="detail_idProducto" class="idProd"></td>'
      +   '<td class="text-end exist"></td>'
      +   '<td class="text-end"><input type="number" step="0.01" min="0" class="form-control text-end w-100p costo" name="detail_costo" value=""></td>'
      +   '<td class="text-end"><input type="number" min="1" class="form-control text-end w-100p cant" name="detail_cantidad" value="1"></td>'
      +   '<td class="text-end sub">0.00</td>'
      +   '<td><button type="button" class="btn btn-outline-danger btn-sm btn-del">X</button></td>'
      + '</tr>';
    return html;
  }
  function recalc(){
    var total=0;
    $("#tbl_det tbody tr").each(function(){
      var costo = parseFloat($(this).find(".costo").val())||0;
      var cant  = parseInt($(this).find(".cant").val())||0;
      var sub = costo*cant;
      $(this).find(".sub").text(fmt(sub));
      total += sub;
    });
    $("#lbl_total").text(fmt(total));
  }
  $("#btn_add_row").on("click", function(){
    $("#tbl_det tbody").append( filaDetalle() );
    var $tr=$("#tbl_det tbody tr").last();
    var $sel=$tr.find(".sel-prod"), opt=$sel.find("option").first();
    $sel.val(opt.val());
    $tr.find(".idProd").val(opt.val());
    $tr.find(".costo").val(opt.data("costo"));
    $tr.find(".exist").text(opt.data("exist"));
    recalc();
  });
  $("#tbl_det tbody")
    .on("change",".sel-prod", function(){
      var opt=$(this).find(":selected"); var $tr=$(this).closest("tr");
      $tr.find(".idProd").val(opt.val());
      $tr.find(".costo").val(opt.data("costo"));
      $tr.find(".exist").text(opt.data("exist"));
      recalc();
    })
    .on("input",".costo,.cant", function(){ recalc(); })
    .on("click",".btn-del", function(){ $(this).closest("tr").remove(); recalc(); });
  $("#btn_add_row").trigger("click");
</script>
</body>
</html>

