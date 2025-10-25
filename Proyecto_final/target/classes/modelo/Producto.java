package modelo;

import java.math.BigDecimal;
import java.util.Date;

public class Producto {
    private int idProducto;
    private String producto;
    private int idMarca;
    private String descripcion;
    private String imagen;
    private BigDecimal precioCosto;
    private BigDecimal precioVenta;
    private int existencia;
    private Date fechaIngreso;
    private String nombreMarca;
    
    public Producto() {}
    
    // Getters y Setters
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    
    public String getProducto() { return producto; }
    public void setProducto(String producto) { this.producto = producto; }
    
    public int getIdMarca() { return idMarca; }
    public void setIdMarca(int idMarca) { this.idMarca = idMarca; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }
    
    public BigDecimal getPrecioCosto() { return precioCosto; }
    public void setPrecioCosto(BigDecimal precioCosto) { this.precioCosto = precioCosto; }
    
    public BigDecimal getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(BigDecimal precioVenta) { this.precioVenta = precioVenta; }
    
    public int getExistencia() { return existencia; }
    public void setExistencia(int existencia) { this.existencia = existencia; }
    
    public Date getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(Date fechaIngreso) { this.fechaIngreso = fechaIngreso; }
    
    public String getNombreMarca() { return nombreMarca; }
    public void setNombreMarca(String nombreMarca) { this.nombreMarca = nombreMarca; }
}