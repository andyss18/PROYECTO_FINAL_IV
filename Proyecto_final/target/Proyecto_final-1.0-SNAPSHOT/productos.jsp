<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Producto"%>
<%@page import="modelo.Marca"%>
<%
    List<Producto> listaProductos = (List<Producto>) request.getAttribute("listaProductos");
    List<Marca> marcas = (List<Marca>) request.getAttribute("marcas");
    Producto producto = (Producto) request.getAttribute("producto");
    Boolean mostrarTabla = (Boolean) request.getAttribute("mostrarTabla");
    Boolean mostrarFormulario = (Boolean) request.getAttribute("mostrarFormulario");
    Boolean esEdicion = (Boolean) request.getAttribute("esEdicion");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CRUD Productos</title>
    <style>
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .table th { background-color: #f2f2f2; }
        .img-thumbnail { 
            max-width: 60px; 
            max-height: 60px; 
            cursor: pointer;
            border: 2px solid #ddd;
            border-radius: 5px;
            transition: transform 0.3s;
        }
        .img-thumbnail:hover {
            transform: scale(1.1);
            border-color: #007bff;
        }
        .preview-image {
            max-width: 100px;
            max-height: 100px;
            margin-top: 10px;
            border: 2px solid #007bff;
            border-radius: 5px;
            display: none;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.9);
        }
        .modal-content {
            margin: auto;
            display: block;
            max-width: 80%;
            max-height: 80%;
        }
        .close {
            position: absolute;
            top: 15px;
            right: 35px;
            color: #f1f1f1;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
        }
        .form-container { background: #f9f9f9; padding: 20px; border-radius: 5px; margin: 20px 0; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select, .form-group textarea { 
            width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; 
        }
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
        .current-image { margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestión de Productos</h1>
        
        <div class="button-group">
            <a href="sr_producto?action=mostrar" class="btn btn-info">📋 Mostrar Productos</a>
            <a href="sr_producto?action=agregar" class="btn btn-success">➕ Agregar Producto</a>
            <a href="marcas.jsp" class="btn btn-secondary">🏷️ Ir a Marcas</a>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <% if (mostrarFormulario != null && mostrarFormulario) { %>
        <!-- Formulario de Producto -->
        <div class="form-container">
            <h2><%= esEdicion != null && esEdicion ? "Actualizar Producto" : "Agregar Producto" %></h2>
            <form action="sr_producto" method="post" enctype="multipart/form-data" id="productoForm">
                <% if (esEdicion != null && esEdicion) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= producto.getIdProducto() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="insert">
                <% } %>
                
                <div class="form-group">
                    <label for="producto">Producto *</label>
                    <input type="text" id="producto" name="producto" 
                           value="<%= (esEdicion != null && esEdicion) ? producto.getProducto() : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="idMarca">Marca *</label>
                    <select id="idMarca" name="idMarca" required>
                        <option value="">Seleccionar Marca</option>
                        <% for (Marca marca : marcas) { %>
                            <option value="<%= marca.getIdmarca() %>" 
                                <%= (esEdicion != null && esEdicion && producto.getIdMarca() == marca.getIdmarca()) ? "selected" : "" %>>
                                <%= marca.getMarca() %>
                            </option>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="descripcion">Descripción</label>
                    <textarea id="descripcion" name="descripcion" rows="3"><%= (esEdicion != null && esEdicion) ? producto.getDescripcion() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="imagen">Imagen</label>
                    <input type="file" id="imagen" name="imagen" accept="image/*" onchange="previewImage(this)">
                    
                    <!-- Previsualización de imagen nueva -->
                    <img id="imagePreview" class="preview-image" alt="Vista previa">
                    
                    <!-- Imagen actual (solo en edición) -->
                    <% if (esEdicion != null && esEdicion && producto.getImagen() != null && !producto.getImagen().isEmpty()) { %>
                        <div class="current-image">
                            <strong>Imagen actual:</strong><br>
                            <img src="<%= producto.getImagen() %>" class="img-thumbnail" alt="Imagen actual" 
                                 onclick="openModal('<%= producto.getImagen() %>')">
                            <br><small>Haz clic para ver en tamaño completo</small>
                        </div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="precio_costo">Precio Costo *</label>
                    <input type="number" id="precio_costo" name="precio_costo" step="0.01" min="0"
                           value="<%= (esEdicion != null && esEdicion) ? producto.getPrecioCosto() : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="precio_venta">Precio Venta *</label>
                    <input type="number" id="precio_venta" name="precio_venta" step="0.01" min="0"
                           value="<%= (esEdicion != null && esEdicion) ? producto.getPrecioVenta() : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="existencia">Existencia *</label>
                    <input type="number" id="existencia" name="existencia" min="0"
                           value="<%= (esEdicion != null && esEdicion) ? producto.getExistencia() : "" %>" required>
                </div>
                
                <button type="submit" class="btn btn-success">
                    <%= (esEdicion != null && esEdicion) ? "Actualizar" : "Guardar" %>
                </button>
                <a href="sr_producto" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
        <% } %>

        <% if (mostrarTabla != null && mostrarTabla && listaProductos != null) { %>
        <!-- Tabla de Productos -->
        <h2>Lista de Productos</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Producto</th>
                    <th>Marca</th>
                    <th>Descripción</th>
                    <th>Imagen</th>
                    <th>Precio Costo</th>
                    <th>Precio Venta</th>
                    <th>Existencia</th>
                    <th>Fecha Ingreso</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Producto p : listaProductos) { %>
                <tr>
                    <td><%= p.getIdProducto() %></td>
                    <td><%= p.getProducto() %></td>
                    <td><%= p.getNombreMarca() %></td>
                    <td><%= p.getDescripcion() != null ? p.getDescripcion() : "" %></td>
                    <td>
                        <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                            <img src="<%= p.getImagen() %>" class="img-thumbnail" alt="Imagen producto" 
                                 onclick="openModal('<%= p.getImagen() %>')">
                        <% } else { %>
                            <span style="color: #999;">Sin imagen</span>
                        <% } %>
                    </td>
                    <td>Q<%= p.getPrecioCosto() %></td>
                    <td>Q<%= p.getPrecioVenta() %></td>
                    <td><%= p.getExistencia() %></td>
                    <td><%= p.getFechaIngreso() %></td>
                    <td>
                        <a href="sr_producto?action=actualizar&id=<%= p.getIdProducto() %>" class="btn btn-warning">✏️ Actualizar</a>
                        <a href="sr_producto?action=eliminar&id=<%= p.getIdProducto() %>" 
                           class="btn btn-danger" 
                           onclick="return confirm('¿Está seguro de eliminar este producto?')">🗑️ Eliminar</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <!-- Modal para ver imagen en tamaño completo -->
    <div id="imageModal" class="modal">
        <span class="close" onclick="closeModal()">&times;</span>
        <img class="modal-content" id="modalImage">
    </div>

    <script>
        // Función para previsualizar imagen antes de subir
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }
        
        // Función para abrir el modal con la imagen
        function openModal(imageSrc) {
            document.getElementById('modalImage').src = imageSrc;
            document.getElementById('imageModal').style.display = "block";
        }
        
        // Función para cerrar el modal
        function closeModal() {
            document.getElementById('imageModal').style.display = "none";
        }
        
        // Cerrar modal al hacer clic fuera de la imagen
        window.onclick = function(event) {
            var modal = document.getElementById('imageModal');
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Cerrar modal con tecla ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeModal();
            }
        });
    </script>
</body>
</html>