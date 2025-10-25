<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Marca"%>
<%
    List<Marca> listaMarcas = (List<Marca>) request.getAttribute("listaMarcas");
    Marca marca = (Marca) request.getAttribute("marca");
    Boolean mostrarTabla = (Boolean) request.getAttribute("mostrarTabla");
    Boolean mostrarFormulario = (Boolean) request.getAttribute("mostrarFormulario");
    Boolean esEdicion = (Boolean) request.getAttribute("esEdicion");
    String error = (String) request.getAttribute("error");
    
   
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CRUD Marcas</title>
    <style>
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .table th { background-color: #f2f2f2; }
        .form-container { background: #f9f9f9; padding: 20px; border-radius: 5px; margin: 20px 0; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { 
            padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; 
            text-decoration: none; display: inline-block; margin: 5px;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 4px; margin: 10px 0; }
        .button-group { margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestión de Marcas</h1>
        
        <div class="button-group">
            <a href="sr_marca?action=mostrar" class="btn btn-info">📋 Mostrar Marcas</a>
            <a href="sr_marca?action=agregar" class="btn btn-success">➕ Agregar Marca</a>
            <a href="productos.jsp" class="btn btn-secondary">📦 Ir a Productos</a>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <% if (mostrarFormulario != null && mostrarFormulario) { %>
        <!-- Formulario de Marca -->
        <div class="form-container">
            <h2><%= esEdicion != null && esEdicion ? "Actualizar Marca" : "Agregar Marca" %></h2>
            <form action="sr_marca" method="post">
                <% if (esEdicion != null && esEdicion) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= marca.getIdmarca() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="insert">
                <% } %>
                
                <div class="form-group">
                    <label for="marca">Nombre de la Marca *</label>
                    <input type="text" id="marca" name="marca" 
                           value="<%= (esEdicion != null && esEdicion) ? marca.getMarca() : "" %>" required>
                </div>
                
                <button type="submit" class="btn btn-success">
                    <%= (esEdicion != null && esEdicion) ? "Actualizar" : "Guardar" %>
                </button>
                <a href="sr_marca" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
        <% } %>

        <% if (mostrarTabla != null && mostrarTabla && listaMarcas != null) { %>
        <!-- Tabla de Marcas -->
        <h2>Lista de Marcas</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Marca</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Marca m : listaMarcas) { %>
                <tr>
                    <td><%= m.getIdmarca() %></td>
                    <td><%= m.getMarca() %></td>
                    <td>
                        <a href="sr_marca?action=actualizar&id=<%= m.getIdmarca() %>" class="btn btn-warning">✏️ Actualizar</a>
                        <a href="sr_marca?action=eliminar&id=<%= m.getIdmarca() %>" 
                           class="btn btn-danger" 
                           onclick="return confirm('¿Está seguro de eliminar esta marca?')">🗑️ Eliminar</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</body>
</html>