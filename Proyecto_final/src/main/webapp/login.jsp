<%-- 
    Document   : login
    Created on : 21/10/2025, 11:56:37 p. m.
    Author     : itsan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>

    <form action="login" method="post">
        <label>Usuario:</label>
        <input type="text" name="username" required><br><br>
        <label>Contraseña:</label>
        <input type="password" name="password" required><br><br>
        <button type="submit">Ingresar</button>
    </form>

    <% 
        if (request.getParameter("error") != null) { 
    %>
        <p style="color:red;">Credenciales inválidas</p>
    <% 
        } 
    %>
</body>
</html>