<%@page contentType="text/html;charset=UTF-8" %>
<h2>Reporte de Ventas por Cliente y Fecha</h2>
<form method="get" action="${pageContext.request.contextPath}/reporte">
    Cliente:
    <select name="cliente_id">
       <option value="">--Todos--</option>
       <c:forEach var="c" items="${clientes}">
         <option value="${c.id}">${c.nombre}</option>
       </c:forEach>
    </select>
    Desde: <input type="date" name="desde"/>
    Hasta: <input type="date" name="hasta"/>
    <button type="submit">Generar</button>
</form>

<table>
    <tr><th>Venta ID</th><th>Fecha</th><th>Cliente</th><th>Total</th></tr>
    <c:forEach var="v" items="${reporte}">
        <tr>
            <td>${v.id}</td>
            <td>${v.fecha}</td>
            <td>${v.cliente.nombre}</td>
            <td>${v.total}</td>
        </tr>
    </c:forEach>
</table>
