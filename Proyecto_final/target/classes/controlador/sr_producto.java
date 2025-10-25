package controlador;

import modelo.Producto;
import modelo.Marca;
import modelo.ConexionBD;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/sr_producto")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class sr_producto extends HttpServlet {
    
    private ConexionBD conexion;
    
    @Override
    public void init() throws ServletException {
        conexion = new ConexionBD();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                showMainPage(request, response);
            } else {
                switch (action) {
                    case "mostrar":
                        listProductos(request, response);
                        break;
                    case "agregar":
                        showNewForm(request, response);
                        break;
                    case "actualizar":
                        showEditForm(request, response);
                        break;
                    case "eliminar":
                        deleteProducto(request, response);
                        break;
                    default:
                        showMainPage(request, response);
                        break;
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("insert".equals(action)) {
                insertProducto(request, response);
            } else if ("update".equals(action)) {
                updateProducto(request, response);
            } else {
                showMainPage(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void showMainPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Solo muestra los botones, sin la tabla
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listProductos(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Producto> listaProductos = new ArrayList<>();
        String sql = "SELECT p.*, m.marca FROM productos p INNER JOIN marcas m ON p.idMarca = m.idmarca ORDER BY p.idProducto";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setProducto(rs.getString("producto"));
                producto.setIdMarca(rs.getInt("idMarca"));
                producto.setDescripcion(rs.getString("Descripcion"));
                producto.setImagen(rs.getString("Imagen"));
                producto.setPrecioCosto(rs.getBigDecimal("precio_costo"));
                producto.setPrecioVenta(rs.getBigDecimal("precio_venta"));
                producto.setExistencia(rs.getInt("existencia"));
                producto.setFechaIngreso(rs.getTimestamp("fecha_ingreso"));
                producto.setNombreMarca(rs.getString("marca"));
                listaProductos.add(producto);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("mostrarTabla", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        request.setAttribute("mostrarFormulario", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = getProductoById(id);
        List<Marca> marcas = getMarcas();
        
        request.setAttribute("marcas", marcas);
        request.setAttribute("producto", producto);
        request.setAttribute("mostrarFormulario", true);
        request.setAttribute("esEdicion", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void insertProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Validaciones
        String errores = validarProducto(request);
        if (!errores.isEmpty()) {
            request.setAttribute("error", errores);
            showNewForm(request, response);
            return;
        }
        
        Producto producto = obtenerProductoDeRequest(request, false);
        String imagenName = procesarImagen(request);
        
        String sql = "INSERT INTO productos (producto, idMarca, Descripcion, Imagen, precio_costo, precio_venta, existencia, fecha_ingreso) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            stmt.setString(1, producto.getProducto());
            stmt.setInt(2, producto.getIdMarca());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, imagenName);
            stmt.setBigDecimal(5, producto.getPrecioCosto());
            stmt.setBigDecimal(6, producto.getPrecioVenta());
            stmt.setInt(7, producto.getExistencia());
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    private void updateProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Validaciones
        String errores = validarProducto(request);
        if (!errores.isEmpty()) {
            request.setAttribute("error", errores);
            showEditForm(request, response);
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = obtenerProductoDeRequest(request, true);
        String imagenName = procesarImagen(request);
        
        String sql = "UPDATE productos SET producto=?, idMarca=?, Descripcion=?, precio_costo=?, precio_venta=?, existencia=?";
        if (imagenName != null) {
            sql += ", Imagen=?";
        }
        sql += " WHERE idProducto=?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            int paramIndex = 1;
            stmt.setString(paramIndex++, producto.getProducto());
            stmt.setInt(paramIndex++, producto.getIdMarca());
            stmt.setString(paramIndex++, producto.getDescripcion());
            stmt.setBigDecimal(paramIndex++, producto.getPrecioCosto());
            stmt.setBigDecimal(paramIndex++, producto.getPrecioVenta());
            stmt.setInt(paramIndex++, producto.getExistencia());
            
            if (imagenName != null) {
                stmt.setString(paramIndex++, imagenName);
            }
            
            stmt.setInt(paramIndex, id);
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    private void deleteProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String sql = "DELETE FROM productos WHERE idProducto = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    // Métodos auxiliares (getMarcas, getProductoById, validarProducto, obtenerProductoDeRequest, procesarImagen)
    private List<Marca> getMarcas() throws SQLException {
        List<Marca> marcas = new ArrayList<>();
        String sql = "SELECT idmarca, marca FROM marcas ORDER BY marca";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Marca marca = new Marca(rs.getInt("idmarca"), rs.getString("marca"));
                marcas.add(marca);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return marcas;
    }
    
    private Producto getProductoById(int id) throws SQLException {
        Producto producto = null;
        String sql = "SELECT * FROM productos WHERE idProducto = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto();
                    producto.setIdProducto(rs.getInt("idProducto"));
                    producto.setProducto(rs.getString("producto"));
                    producto.setIdMarca(rs.getInt("idMarca"));
                    producto.setDescripcion(rs.getString("Descripcion"));
                    producto.setImagen(rs.getString("Imagen"));
                    producto.setPrecioCosto(rs.getBigDecimal("precio_costo"));
                    producto.setPrecioVenta(rs.getBigDecimal("precio_venta"));
                    producto.setExistencia(rs.getInt("existencia"));
                    producto.setFechaIngreso(rs.getTimestamp("fecha_ingreso"));
                }
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return producto;
    }
    
    private String validarProducto(HttpServletRequest request) {
        StringBuilder errores = new StringBuilder();
        
        String producto = request.getParameter("producto");
        String idMarca = request.getParameter("idMarca");
        String precioCosto = request.getParameter("precio_costo");
        String precioVenta = request.getParameter("precio_venta");
        String existencia = request.getParameter("existencia");
        
        if (producto == null || producto.trim().isEmpty()) {
            errores.append("El nombre del producto es obligatorio.<br>");
        }
        
        if (idMarca == null || idMarca.trim().isEmpty()) {
            errores.append("Debe seleccionar una marca.<br>");
        }
        
        try {
            BigDecimal costo = new BigDecimal(precioCosto);
            if (costo.compareTo(BigDecimal.ZERO) < 0) {
                errores.append("El precio costo no puede ser negativo.<br>");
            }
        } catch (Exception e) {
            errores.append("El precio costo debe ser un número válido.<br>");
        }
        
        try {
            BigDecimal venta = new BigDecimal(precioVenta);
            if (venta.compareTo(BigDecimal.ZERO) < 0) {
                errores.append("El precio venta no puede ser negativo.<br>");
            }
        } catch (Exception e) {
            errores.append("El precio venta debe ser un número válido.<br>");
        }
        
        try {
            int exist = Integer.parseInt(existencia);
            if (exist < 0) {
                errores.append("La existencia no puede ser negativa.<br>");
            }
        } catch (Exception e) {
            errores.append("La existencia debe ser un número entero válido.<br>");
        }
        
        return errores.toString();
    }
    
    private Producto obtenerProductoDeRequest(HttpServletRequest request, boolean isUpdate) {
        Producto producto = new Producto();
        
        if (isUpdate) {
            producto.setIdProducto(Integer.parseInt(request.getParameter("id")));
        }
        
        producto.setProducto(request.getParameter("producto"));
        producto.setIdMarca(Integer.parseInt(request.getParameter("idMarca")));
        producto.setDescripcion(request.getParameter("descripcion"));
        producto.setPrecioCosto(new BigDecimal(request.getParameter("precio_costo")));
        producto.setPrecioVenta(new BigDecimal(request.getParameter("precio_venta")));
        producto.setExistencia(Integer.parseInt(request.getParameter("existencia")));
        
        return producto;
    }
    
    private String procesarImagen(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("imagen");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String fileName = getFileName(filePart);
        
        // Validar tipo de archivo
        if (!isValidImageType(fileName)) {
            throw new ServletException("Tipo de archivo no permitido. Solo se permiten imágenes JPG, PNG, GIF.");
        }
        
        // Generar nombre único
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        
        // Ruta donde guardar las imágenes
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        String filePath = uploadPath + File.separator + uniqueFileName;
        try (InputStream fileContent = filePart.getInputStream();
             FileOutputStream out = new FileOutputStream(filePath)) {
            
            int read;
            final byte[] bytes = new byte[1024];
            while ((read = fileContent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
        }
        
        return "uploads/" + uniqueFileName;
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private boolean isValidImageType(String fileName) {
        if (fileName == null || fileName.isEmpty()) return false;
        
        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif"};
        String lowerCaseFileName = fileName.toLowerCase();
        
        for (String ext : allowedExtensions) {
            if (lowerCaseFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }
}