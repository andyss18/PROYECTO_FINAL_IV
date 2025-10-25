<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sistema de Gestión</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f5f5; 
        }
        .container { 
            max-width: 600px; 
            margin: 50px auto; 
            background: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 { 
            color: #333; 
            margin-bottom: 30px;
        }
        .menu { 
            display: flex; 
            flex-direction: column;
            gap: 15px; 
        }
        .btn { 
            display: block;
            padding: 15px; 
            background: #007bff; 
            color: white; 
            text-decoration: none; 
            text-align: center; 
            border-radius: 5px; 
            font-size: 16px;
            font-weight: bold;
            transition: background 0.3s; 
        }
        .btn:hover { 
            background: #0056b3; 
        }
        .btn-productos { background: #28a745; }
        .btn-productos:hover { background: #1e7e34; }
        .btn-marcas { background: #ffc107; color: black; }
        .btn-marcas:hover { background: #e0a800; }
        .btn-puestos { background: #28a745; }
        .btn-puestos:hover { background: #1e7e34; }
        .btn-empleados { background: #ffc107; color: black; }
        .btn-empleados:hover { background: #e0a800; }
        .btn-clientes { background: #28a745; }
        .btn-clientes:hover { background: #1e7e34; }
        .btn-proveedores { background: #ffc107; color: black; }
        .btn-proveedores:hover { background: #e0a800; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏢 Sistema de Gestión</h1>
        <p>Seleccione el módulo a gestionar:</p>

        <div class="menu">
            <a href="productos.jsp" class="btn btn-productos">📦 Gestión de Productos</a>
            <a href="marcas.jsp" class="btn btn-marcas">🏷️ Gestión de Marcas</a>
            <a href="clientes.jsp" class="btn btn-clientes">👥 CRUD Clientes</a>
            <a href="proveedores.jsp" class="btn btn-proveedores">🏢 CRUD Proveedores</a>
            <a class="btn btn-puestos" href="puestos.jsp">Puestos</a>
            <a class="btn btn-empleados" href="empleados.jsp">Empleados</a>
        </div>
    </div>
    <%@ page import="modelo.Usuario" %>
    <%
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        Usuario u = (Usuario) sesion.getAttribute("usuario");
    %>

    <h2>Bienvenido, <%= u.getUsername()%>!</h2>


</body>
</html>